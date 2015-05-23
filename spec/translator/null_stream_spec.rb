require 'spec_helper'

describe Translator::NullStream do
  let(:subject) { Translator::NullStream.new }

  describe '#puts' do
    it 'does not print' do
      expect(subject.puts("Test")).to eq(nil)
    end
  end

  describe 'Aliasing' do
    it 'write and << are aliases of puts' do
      expect(subject.method(:write)).to eq(subject.method(:puts))
      expect(subject.method(:<<)).to eq(subject.method(:puts))
    end
  end
end
