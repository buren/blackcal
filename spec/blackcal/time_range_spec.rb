# frozen_string_literal: true

require 'spec_helper'
require 'time'

RSpec.describe Blackcal::TimeRange do
  it 'returns false if both start and finish is nil' do
    range = described_class.new(nil)
    expect(range.cover?(Time.parse('2019-02-10'))).to eq(false)
  end

  context 'with finish nil' do
    it 'returns false if start is greater than timestamp' do
      range = described_class.new(Time.parse('2019-02-10'))

      expect(range.cover?(Time.parse('2019-01-01'))).to eq(false)
    end

    it 'returns true if timestamp is greater than start' do
      range = described_class.new(Time.parse('2019-01-01'))

      expect(range.cover?(Time.parse('2019-02-10'))).to eq(true)
    end
  end

  context 'with start nil' do
    it 'returns true if finish is greater than timestamp' do
      range = described_class.new(nil, Time.parse('2019-02-10'))

      expect(range.cover?(Time.parse('2019-01-01'))).to eq(true)
    end

    it 'returns false if timestamp is greater than finish' do
      range = described_class.new(nil, Time.parse('2019-01-01'))

      expect(range.cover?(Time.parse('2019-02-10'))).to eq(false)
    end
  end

  context 'with start and finish' do
    it 'returns true if start is greater than timestamp' do
      range = described_class.new(Time.parse('2019-02-10'), Time.parse('2019-03-10'))

      expect(range.cover?(Time.parse('2019-01-01'))).to eq(true)
    end

    it 'returns true if timestamp is greater than finish' do
      range = described_class.new(Time.parse('2019-02-10'), Time.parse('2019-03-10'))

      expect(range.cover?(Time.parse('2019-04-01'))).to eq(true)
    end

    it 'returns false if timestamp is within start and finish' do
      range = described_class.new(Time.parse('2019-01-01'), Time.parse('2019-03-10'))

      expect(range.cover?(Time.parse('2019-02-10'))).to eq(false)
    end

    it 'returns false if timestamp is equal to finish' do
      range = described_class.new(Time.parse('2019-01-01'), Time.parse('2019-03-10'))

      expect(range.cover?(Time.parse('2019-03-10'))).to eq(false)
    end
  end
end
