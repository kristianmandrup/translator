require 'active_support/core_ext/module/attribute_accessors'

module Translator
  autoload :NullStream,        'translator/null_stream'
  autoload :Synchronizer,      'translator/synchronizer'
  autoload :Store,             'translator/store'
  autoload :YamlFileFlattener, 'translator/yaml_file_flattener'

  mattr_accessor :storage
  @@storage = :Redis

  mattr_accessor :storage_options
  @@storage_options = { host: 'localhost', port: 6379, db: 1 }

  mattr_accessor :output_stream
  @@output_stream = nil

  mattr_reader :default_output_stream
  @@default_output_stream = NullStream.new

  mattr_accessor :synchronization_data_file
  @@synchronization_data_file = File.expand_path('../../.localeapp/log.yml', __FILE__)

  mattr_accessor :data_directory
  @@data_directory = File.expand_path('../../locales', __FILE__)

  mattr_accessor :localeapp_api_key
  @@localeapp_api_key = ''


  def self.setup
    yield self if block_given?
    setup_localeapp_configurations
  end

  def self.load!(paths)
    Synchronizer.new(paths, output_stream).process
    Store.instance.load_files(paths)
  end

  def self.default_file_paths
    Dir[File.join(data_directory, '*.yml')]
  end

  def self.setup_localeapp_configurations
    require 'localeapp'
    Localeapp.configure do |config|
      config.api_key                    = localeapp_api_key
      config.translation_data_directory = data_directory
      config.synchronization_data_file  = synchronization_data_file
      config.poll_interval              = 0
    end
  end
  private_class_method :setup_localeapp_configurations
end
