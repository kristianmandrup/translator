$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'byebug'
require 'simplecov'
require 'translator'
SimpleCov.start

Translator.setup do |config|
  config.synchronization_data_file = File.expand_path('../.localeapp/log.yml', __FILE__)
  config.data_directory            = File.expand_path('../locales', __FILE__)
end

RSpec.configure do |config|
  config.after(:all) do
    FileUtils.rm_rf(Translator.data_directory)
    FileUtils.rm_rf(Pathname.new(Translator.synchronization_data_file).parent)
  end
end
