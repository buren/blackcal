# frozen_string_literal: true

require 'spec_helper'
require 'time'

RSpec.describe Blackcal::TimeOfDayRange do
  it 'returns false when both start and finish is nil' do
    range = described_class.new(nil, nil)

    expect(range.cover?(Time.parse('2019-01-01 18:00'))).to eq(false)
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
    it 'returns true start is before timestamp hour' do
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
