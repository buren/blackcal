# frozen_string_literal: true

require 'spec_helper'
require 'time'

RSpec.describe Blackcal::MonthRange do
  describe '#initialize' do
    it 'can handle month numbers' do
      range = described_class.new(1)

      expect(range.months).to eq([:january])
    end

    it 'raises KeyError for unknown month numbers' do
      expect { described_class.new(13) }.to raise_error(KeyError)
    end
  end

  context 'quacks like an enumerable' do
    it 'has #to_a' do
      range = described_class.new(:january)

      expect(range.to_a).to eq([:january])
    end

    it 'has #each' do
      range = described_class.new([:january, :february])

      expected = [:january, :february].each
      range.each do |v|
        expect(v).to eq(expected.next)
      end
    end
  end

  describe '#cover?' do
    it 'returns false if months are nil' do
      expect(described_class.new(nil).cover?(Time.parse('2018-01-01'))).to eq(false)
    end

    it 'returns false if months are empty' do
      expect(described_class.new([]).cover?(Time.parse('2018-01-01'))).to eq(false)
    end

    context 'with single weekday' do
      it 'returns true if covers' do
        range = described_class.new(:september)

        expect(range.cover?(Time.parse('2018-09-15'))).to eq(true)
      end

      it 'returns false if does not cover' do
        range = described_class.new(:september)

        expect(range.cover?(Time.parse('2018-10-14'))).to eq(false)
      end
    end

    context 'with multiple months' do
      it 'returns true if covers' do
        range = described_class.new(%i[january september])

        expect(range.cover?(Time.parse('2018-09-15'))).to eq(true)
      end

      it 'returns false if it does not cover' do
        range = described_class.new(%i[september november december])

        expect(range.cover?(Time.parse('2018-10-14'))).to eq(false)
      end
    end
  end
end
