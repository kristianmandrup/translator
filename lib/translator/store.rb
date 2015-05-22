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

    def read(key)
      @storage[key]
    end

    def [](key)
      read(key)
    end

    def []=(key, value)
      write(key, value)
    end

    def load_files(paths)
      require 'yaml'
      paths = (Array(paths) + Translator.default_file_paths).uniq
      paths.each(&method(:load_file))
    end

    def load_file(path)
      YAML.load_file(path).each { |lang, data| write(lang, data) }
    end
  end
end
