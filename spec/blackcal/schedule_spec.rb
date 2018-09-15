# frozen_string_literal: true

require 'spec_helper'
require 'time'

RSpec.describe Blackcal::Schedule do
  describe '#cover?' do
    it 'given no arguments it allows nothing' do
      rule = described_class.new

      expect(rule.cover?('2019-01-01 19:00')).to eq(false)
    end

    it 'given only start date allows nothing' do
      rule = described_class.new(start_time: '2000-01-01')

      expect(rule.cover?('2019-01-01 19:00')).to eq(false)
    end

    context 'with start and end hour' do
      it 'handles disallowed cases' do
        rule = described_class.new(start_hour: 18, finish_hour: 12)

        expect(rule.cover?('2019-01-01 19:00')).to eq(false)
      end

      it 'handles allowed cases' do
        rule = described_class.new(start_hour: 18, finish_hour: 12)

        expect(rule.cover?('2019-01-01 17:00')).to eq(true)
      end
    end

    [
      # expected, timestamp, start_hour, finish_hour, weekdays, days
      [true, '2018-09-15 19:00Z', 18, 12, :monday, 15],
      [false, '2018-09-15 19:00Z', 18, 12, :saturday, 15],
      [true, '2018-09-15 13:00Z', 18, 12, :saturday, 15],
      [false, '2018-09-15 13:00Z', nil, nil, :saturday, 15],
      [false, '2018-09-15 13:00Z', nil, nil, :saturday, nil],
      [true, '2018-09-15 13:00Z', nil, nil, :monday, nil],
      [true, '2018-09-15 13:00Z', nil, nil, :monday, 15],
      [true, '2018-09-15 13:00Z', nil, nil, :monday, 15],
      [true, '2018-09-15 13:00Z', 18, 12, :saturday, nil],
      [false, '2018-09-15 13:00Z', 10, 18, :saturday, nil],
      [false, '2018-09-15 13:00Z', nil, nil, nil, 15],
      [true, '2018-09-15 13:00Z', nil, nil, nil, 17],
      [true, '2018-09-15 13:00Z', 10, 14, nil, 17],
      [false, '2018-09-15 13:00Z', 10, 14, nil, nil],
    ].each do |data|
      expected, timestamp, start_hour, finish_hour, weekdays, days = data

      it "returns #{expected}" do
        rule = described_class.new(
          start_time: '2000-01-01',
          start_hour: start_hour,
          finish_hour: finish_hour,
          weekdays: weekdays,
          days: days
        )

        expect(rule.cover?(timestamp)).to eq(expected)
      end
    end
  end
end
