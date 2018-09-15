# frozen_string_literal: true

require 'spec_helper'
require 'time'

RSpec.describe Blackcal::MonthRange do
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
