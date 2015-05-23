require 'spec_helper'

class TestSynchronizer
  def execute(*args); end
end

class TestPusher < TestSynchronizer; end
class TestPuller < TestSynchronizer; end
class TestUpdator < TestSynchronizer; end

describe Translator::Synchronizer do
  let(:file_paths) { Dir[File.expand_path('../../helpers/test_data/*.yml', __FILE__)] }
  let(:synchronizer) do
    syn = Translator::Synchronizer.new(file_paths)
    syn.instance_eval do
      def puller
        @puller ||= TestPuller.new
      end

      def pusher
        @pusher ||= TestPusher.new
      end

      def updator
        @updator ||= TestUpdator.new
      end
    end
    syn
  end

  describe '#process' do
    it 'pushes and updates all files for processing' do
      expect(synchronizer).to receive(:push)
      expect(synchronizer).to receive(:update)
      synchronizer.process
    end
  end

  describe '#push' do
    it 'pushes all file by Localeapp' do
      expect(synchronizer.pusher).to receive(:execute).exactly(file_paths.count).times
      synchronizer.send(:push)
    end
  end

  describe '#update' do
    context 'when ever pulled' do
      before { allow(synchronizer).to receive(:pulled?).and_return(true) }

      it 'does not pull the files' do
        expect(synchronizer).to_not receive(:pull)
        synchronizer.send(:update)
      end
    end

    context 'when pulled neever' do
      before { allow(synchronizer).to receive(:pulled?).and_return(false) }
      after { FileUtils.rm_rf(Pathname.new(Translator.synchronization_data_file).parent) }

      it 'pulls the file' do
        expect(synchronizer.puller).to receive(:execute)
        synchronizer.send(:update)
        expect(File.exist?(Translator.synchronization_data_file)).to eq(true)
      end
    end

    it 'updates the files' do
      expect(synchronizer.updator).to receive(:execute)
      synchronizer.send(:update)
    end
  end

  describe '#puller' do
    it 'is an instance of Localeapp::CLI::Pull' do
      expect(Translator::Synchronizer.new([]).send(:puller)).to be_an_instance_of(Localeapp::CLI::Pull)
    end
  end

  describe '#pusher' do
    it 'is an instance of Localeapp::CLI::Push' do
      expect(Translator::Synchronizer.new([]).send(:pusher)).to be_an_instance_of(Localeapp::CLI::Push)
    end
  end

  describe '#updator' do
    it 'is an instance of Localeapp::CLI::Update' do
      expect(Translator::Synchronizer.new([]).send(:updator)).to be_an_instance_of(Localeapp::CLI::Update)
    end
  end
end
