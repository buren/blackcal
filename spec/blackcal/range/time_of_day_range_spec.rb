# frozen_string_literal: true

require 'spec_helper'
require 'time'

RSpec.describe Blackcal::TimeOfDayRange do
  describe '#start' do
    it 'can handle timestamp' do
      time = described_class.new(Time.parse('2018-01-01 19:31Z'))

      expect(time.start.hour).to eq(19)
      expect(time.start.min).to eq(31)
    end
  end

  describe '#to_a' do
    def zero_zip(arr)
      arr.zip([0] * arr.length)
    end

    it 'returns disallowed mins for one hour' do
      range = described_class.new(18, 18)

      expected = (0..59).map { |min| [18, min] }
      expect(range.to_a(resolution: :min)).to eq(expected)
    end

    it 'returns disallowed mins for multiple hour' do
      range = described_class.new(Blackcal::TimeOfDay.new(23, 4), Blackcal::TimeOfDay.new(1, 31))
      expected = []
      expected.concat((4..59).map { |min| [23, min] })
      expected.concat((0..59).map { |min| [0, min] })
      expected.concat((0..31).map { |min| [1, min] })
      expect(range.to_a(resolution: :min)).to eq(expected)
    end

    it 'returns empty when given neither start or finish time' do
      range = described_class.new(nil, nil)

      expect(range.to_a).to eq([])
    end

    it 'returns disallowed_hours when given only start time' do
      range = described_class.new(18, nil)

      expected = zero_zip([18, 19, 20, 21, 22, 23, 0])
      expect(range.to_a).to eq(expected)
    end

    it 'returns disallowed_hours when given only finish time' do
      range = described_class.new(nil, 9)

      expected = zero_zip([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
      expect(range.to_a).to eq(expected)
    end

    it 'returns disallowed_hours when given start and finish (and start larger than finish)' do # rubocop:disable Metrics/LineLength
      range = described_class.new(18, 5)

      expected = zero_zip([18, 19, 20, 21, 22, 23, 0, 1, 2, 3, 4, 5])
      expect(range.to_a).to eq(expected)
    end

    it 'returns disallowed_hours when given start and finish (and start smaller than finish)' do # rubocop:disable Metrics/LineLength
      range = described_class.new(10, 13)

      expected = zero_zip([10, 11, 12, 13])
      expect(range.to_a).to eq(expected)
    end

    it 'returns disallowed_hours when start and finish are equal' do
      range = described_class.new(9, 9)

      expect(range.to_a).to eq(zero_zip([9]))
    end

    it 'returns disallowed_hours when start is one hour before finish' do
      range = described_class.new(9, 10)

      expect(range.to_a).to eq(zero_zip([9, 10]))
    end

    context 'returns disallowed_hours when arround midnight' do
      it do
        range = described_class.new(23, 0)

        expect(range.to_a).to eq(zero_zip([23, 0]))
      end

      it do
        range = described_class.new(23, 1)

        expect(range.to_a).to eq(zero_zip([23, 0, 1]))
      end

      it do
        range = described_class.new(0, 23)

        expect(range.to_a).to eq(zero_zip((0..23).to_a))
      end
    end
  end

  it 'returns false when both start and finish is nil' do
    range = described_class.new(nil, nil)

    expect(range.cover?(Time.parse('2019-01-01 18:00'))).to eq(false)
  end

  it 'returns true when both start and finish and timestamp are equal' do
    range = described_class.new(10, 10)

    expect(range.cover?(Time.parse('2019-01-01 10:00'))).to eq(true)
  end

  context 'start is nil' do
    it 'returns false finish is before timestamp hour' do
      range = described_class.new(nil, 10)

      expect(range.cover?(Time.parse('2019-01-01 11:00'))).to eq(false)
    end

    it 'returns true finish is after timestamp hour' do
      range = described_class.new(nil, 10)

      expect(range.cover?(Time.parse('2019-01-01 09:00'))).to eq(true)
    end
  end

  context 'finish is nil' do
    it 'returns true if start is before timestamp hour' do
      range = described_class.new(10, nil)

      expect(range.cover?(Time.parse('2019-01-01 11:00'))).to eq(true)
    end

    it 'returns false start is after timestamp hour' do
      range = described_class.new(10, nil)

      expect(range.cover?(Time.parse('2019-01-01 09:00'))).to eq(false)
    end
  end

  context 'start at 18 end at 9' do
    ((19..23).to_a + (0..9).to_a).each do |hour|
      it "returns false for hour #{hour}" do
        range = described_class.new(18, 9)

        expect(range.cover?(Time.parse("2019-01-01 #{hour}:00"))).to eq(true)
      end
    end

    (10..17).each do |hour|
      it "returns true for hour #{hour}" do
        range = described_class.new(18, 9)

        expect(range.cover?(Time.parse("2019-01-01 #{hour}:00"))).to eq(false)
      end
    end
  end

  context 'start at 10 end at 21' do
    ((22..23).to_a + (0..9).to_a).each do |hour|
      it "returns true for hour #{hour}" do
        range = described_class.new(10, 21)

        expect(range.cover?(Time.parse("2019-01-01 #{hour}:00"))).to eq(false)
      end
    end

    (10..21).each do |hour|
      it "returns false for hour #{hour}" do
        range = described_class.new(10, 21)

        expect(range.cover?(Time.parse("2019-01-01 #{hour}:00"))).to eq(true)
      end
    end
  end
end
