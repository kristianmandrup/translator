require 'singleton'
require 'forwardable'
require 'moneta'

module Translator
  class Store
    include Singleton
    extend Forwardable

    def initialize(type = Translator.storage, options = Translator.storage_options)
      @type    = type # can be removed
      @options = options # can be removed
      @storage = Moneta.new(type, options)
    end
    def_delegators :@storage, :key?, :clear

    def write(key, value)
      @storage[key] = value
    end
    alias :[]= :write

    def read(key)
      @storage[key]
    end
    alias :[] :read

    def load_files(paths)
      paths = (Array(paths) + Translator.default_file_paths).uniq
      YamlFileFlattener.new(paths).process.each { |language, data| write(language, data) }
    end
  end
end
