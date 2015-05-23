require 'spec_helper'

describe Translator do
  it 'has default Redis Storage' do
    expect(Translator.storage).to be :Redis
  end

  it 'has default storage options' do
    expect(Translator.storage_options).to eq({ host: 'localhost', port: 6379, db: 1 })
  end

  it 'has output stream' do
    expect(Translator).to respond_to(:output_stream)
  end

  it 'has default Null output stream' do
    expect(Translator.default_output_stream).to be_an_instance_of(Translator::NullStream)
  end

  it 'has a log file in the .localapp folder' do
    expect(Translator.synchronization_data_file).to_not be_nil
  end

  it 'syncs the data in data directory' do
    expect(Translator.data_directory).to eq(File.expand_path('../../spec/locales', __FILE__))
  end

  it 'does not have localeapp api key' do
    expect(Translator.localeapp_api_key).to be_empty
  end

  describe 'Class Methods' do
    before do
      FileUtils.mkdir_p(Translator.data_directory)
    end

    after { FileUtils.rm_rf(Translator.data_directory) }

    describe '.default_file_paths' do
      let(:file_path) { "#{ Translator.data_directory }/_test.yml" }

      before do
        File.open(file_path, 'w') {}
      end

      it 'returns all .yml file paths in the data directory' do
        expect(Translator.default_file_paths).to eq([file_path])
      end
    end

    describe '.load!' do
      after { Translator.load!(nil) }

      it 'synchronizes locale files from the server' do
        expect_any_instance_of(Translator::Synchronizer).to receive(:process).and_return(true)
      end

      it 'loads the locale in the store' do
        allow_any_instance_of(Translator::Synchronizer).to receive(:process).and_return(true)
        expect(Translator::Store.instance).to receive(:load_files).with(nil)
      end
    end
  end
end
