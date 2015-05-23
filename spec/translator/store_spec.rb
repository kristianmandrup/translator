require 'spec_helper'

describe Translator::Store do
  let(:store) { Translator::Store.instance }

  before { store.clear }

  describe '#write' do
    before { store.write('first_name', nil) }

    it 'writes to the storage' do
      store.write('first_name', 'Kuldeep')
      expect(store.read('first_name')).to eq('Kuldeep')
    end
  end

  describe '#read' do
    context 'storage has nothing as data' do
      it 'returns nil' do
        expect(store.read('first_name')).to eq(nil)
      end
    end

    context 'storage has something as data' do
      before do
        store.write('first_name', 'Kuldeep')
        store.write('lastname', nil)
      end

      it 'lastname is nil' do
        expect(store.read('lastname')).to eq(nil)
      end

      it 'first_name == Kuldeep' do
        expect(store.read('first_name')).to eq('Kuldeep')
      end
    end
  end

  describe '#load_files' do
    let(:yaml_data) {
      {
        en: { first_name: 'Kuldeep' },
        pa: { first_name: 'ਕੁਲਦੀਪ'   }
      }
    }
    before do
      allow_any_instance_of(Translator::YamlFileFlattener).to receive(:process).and_return(yaml_data)
    end
    after do
      store.clear
    end

    it 'loads all yml files in the storage' do
      store.load_files(nil)
      expect(store[:en]).to eq(first_name: 'Kuldeep')
      expect(store[:pa]).to eq(first_name: 'ਕੁਲਦੀਪ')
    end
  end

  describe 'Delegations' do
    it 'responds to key?, clear, adapter, backend, keys' do
      expect(store).to respond_to(:key?)
      expect(store).to respond_to(:clear)
      expect(store).to respond_to(:adapter)
      expect(store).to respond_to(:keys)
      expect(store).to respond_to(:backend)
    end
  end
end
