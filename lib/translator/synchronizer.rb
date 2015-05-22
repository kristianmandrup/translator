module Translator
  class Synchronizer
    attr_reader :paths, :output_stream
    def initialize(paths, output_stream = Translator.output_stream)
      @paths = (Array(paths) + Translator.default_file_paths).uniq
      @output_stream = output_stream || Translator.default_output_stream
    end

    def process
      push
      update
    end

    private
      def push
        pusher = ::Localeapp::CLI::Push.new(output: output_stream)
        paths.each { |path| pusher.execute(path)  }
      end

      def update
        pull unless pulled?
        Localeapp::CLI::Update.new(output: output_stream).execute
      end

      def pull
        require 'fileutils'
        FileUtils.mkdir_p(Translator.data_directory)
        FileUtils.mkdir_p(Pathname.new(Translator.synchronization_data_file).parent)
        File.open(Translator.synchronization_data_file, 'w') { }
        Localeapp::CLI::Pull.new(output: output_stream).execute
      end

      def pulled?
        File.exist?(resolve_path(Translator.synchronization_data_file))
      end

      def resolve_path(path)
        File.expand_path(path, __FILE__)
      end

  end
end
