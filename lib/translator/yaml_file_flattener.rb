require 'yaml'

module Translator
  class YamlFileFlattener

    attr_reader :paths, :result
    def initialize(paths)
      @paths = paths
      @result = Hash.new { |hash, key| hash[key] = {} }
    end

    def process
      paths.each do |path|
        load_file(path) do |lang, data|
          result[lang].merge!(data)
        end
      end
      result
    end

    private
      def load_file(path)
        YAML.load_file(path).each { |lang, data| yield(lang, data) }
      end
  end
end
