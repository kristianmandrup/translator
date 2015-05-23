require 'spec_helper'

describe Translator::YamlFileFlattener do
  describe '#process' do
    let(:file_paths) { Dir[File.expand_path('../../helpers/test_data/*.yml', __FILE__)] }
    let(:flattener) { Translator::YamlFileFlattener.new(file_paths) }

    it 'merges all yaml files data' do
      expect(flattener.process).to eq({
        'en' => {
          'first_name' => 'Kuldeep',
          'last_name'  => 'Aggarwal'
        }
      })
    end
  end
end
