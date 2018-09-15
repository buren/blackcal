# frozen_string_literal: true

require 'spec_helper'
require 'time'

RSpec.describe Blackcal::WeekdayRange do
  describe '#cover?' do
    it 'returns false if weekdays are nil' do
      expect(described_class.new(nil).cover?(Time.parse('2018-01-01'))).to eq(false)
    end

    it 'returns false if weekdays are empty' do
      expect(described_class.new([]).cover?(Time.parse('2018-01-01'))).to eq(false)
    end

    context 'with single weekday' do
      it 'returns true if covers' do
        range = described_class.new(:saturday)

        expect(range.cover?(Time.parse('2018-09-15'))).to eq(true)
      end

      it 'returns false if does not cover' do
        range = described_class.new(:saturday)

        expect(range.cover?(Time.parse('2018-09-14'))).to eq(false)
      end
    end

    context 'with multiple weekdays' do
      it 'returns true if covers' do
        range = described_class.new(%i[monday saturday])

        expect(range.cover?(Time.parse('2018-09-15'))).to eq(true)
      end

      it 'returns true if it does not cover' do
        range = described_class.new(%i[saturday thursday wednesday])

        expect(range.cover?(Time.parse('2018-09-14'))).to eq(false)
      end
    end
  end
end
