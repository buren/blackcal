# frozen_string_literal: true

require 'spec_helper'
require 'time'

RSpec.describe Blackcal::TimeRange do
  context 'quacks like an enumerable' do
    context 'hour resolution' do
      it 'has #to_a' do
        start = Time.parse('2018-01-01 09:00Z')
        finish = Time.parse('2018-01-01 11:00Z')
        range = described_class.new(start, finish)

        expected = [Time.parse('2018-01-01 10:00Z'), Time.parse('2018-01-01 11:00Z')]
        expect(range.to_a).to eq(expected)
      end

      it 'has #to_a (multiple days)' do
        start = Time.parse('2018-01-01 09:00Z')
        finish = Time.parse('2018-01-02 11:00Z')
        range = described_class.new(start, finish)

        first = Time.parse('2018-01-01 10:00Z')
        last = Time.parse('2018-01-02 11:00Z')
        expect(range.to_a.first).to eq(first)
        expect(range.to_a.last).to eq(last)
        expect(range.to_a.length).to eq(26)
      end

      it 'has #each' do
        start = Time.parse('2018-01-01 09:00Z')
        finish = Time.parse('2018-01-01 11:00Z')
        range = described_class.new(start, finish)

        expected = [Time.parse('2018-01-01 10:00Z'), Time.parse('2018-01-01 11:00Z')].each
        range.each do |v|
          expect(v).to eq(expected.next)
        end
      end
    end

    context 'minute resolution' do
      it 'has #to_a' do
        start = Time.parse('2018-01-01 09:00Z')
        finish = Time.parse('2018-01-02 11:00Z')
        range = described_class.new(start, finish)

        first = Time.parse('2018-01-01 09:01Z')
        last = Time.parse('2018-01-02 11:00Z')
        array = range.to_a(resolution: :min)

        expect(array.first).to eq(first)
        expect(array.last).to eq(last)
        expect(array.length).to eq(1560)
      end

      it 'has #each' do
        start = Time.parse('2018-01-01 09:00Z')
        finish = Time.parse('2018-01-01 11:00Z')
        range = described_class.new(start, finish)

        expected = [Time.parse('2018-01-01 10:00Z'), Time.parse('2018-01-01 11:00Z')].each
        range.each do |v|
          expect(v).to eq(expected.next)
        end
      end
    end
  end

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
