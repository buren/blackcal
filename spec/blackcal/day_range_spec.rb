# frozen_string_literal: true

require 'spec_helper'
require 'time'

RSpec.describe Blackcal::DayRange do
  describe '#cover?' do
    it 'returns false if numbers are nil' do
      expect(described_class.new(nil).cover?(Time.parse('2018-01-01'))).to eq(false)
    end

    it 'returns false if numbers are empty' do
      expect(described_class.new([]).cover?(Time.parse('2018-01-01'))).to eq(false)
    end

    context 'single day' do
      it 'returns true if day is covered' do
        range = described_class.new(15)

        expect(range.cover?(Time.parse('2018-09-15'))).to eq(true)
      end

      it 'returns false if day is not covered' do
        range = described_class.new(14)

        expect(range.cover?(Time.parse('2018-09-15'))).to eq(false)
      end
    end

    context 'multiple days' do
      it 'returns true if day is covered' do
        range = described_class.new([15, 17])

        expect(range.cover?(Time.parse('2018-09-15'))).to eq(true)
      end

      it 'returns false if day is not covered' do
        range = described_class.new([14, 13])

        expect(range.cover?(Time.parse('2018-09-15'))).to eq(false)
      end
    end
  end
end
