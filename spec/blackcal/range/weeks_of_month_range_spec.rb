# frozen_string_literal: true

require 'spec_helper'
require 'time'

RSpec.describe Blackcal::WeeksOfMonthRange do
  context 'quacks like an enumerable' do
    it 'has #to_a' do
      range = described_class.new(1)

      expect(range.to_a).to eq([1])
    end

    it 'has #each' do
      range = described_class.new([1, 2])

      expected = [1, 2].each
      range.each do |v|
        expect(v).to eq(expected.next)
      end
    end
  end

  describe '#cover?' do
    it 'returns false if numbers are nil' do
      expect(described_class.new(nil).cover?(Time.parse('2018-01-01'))).to eq(false)
    end

    it 'returns false if numbers are empty' do
      expect(described_class.new([]).cover?(Time.parse('2018-01-01'))).to eq(false)
    end

    context 'single week of month' do
      it 'returns true if day is covered' do
        range = described_class.new(2)

        expect(range.cover?(Time.parse('2018-09-15'))).to eq(true)
      end

      it 'returns false if day is not covered' do
        range = described_class.new(1)

        expect(range.cover?(Time.parse('2018-09-15'))).to eq(false)
      end
    end

    context 'multiple days' do
      it 'returns true if day is covered' do
        range = described_class.new([1, 2])

        expect(range.cover?(Time.parse('2018-09-15'))).to eq(true)
      end

      it 'returns false if day is not covered' do
        range = described_class.new([3, 4])

        expect(range.cover?(Time.parse('2018-09-15'))).to eq(false)
      end
    end
  end
end
