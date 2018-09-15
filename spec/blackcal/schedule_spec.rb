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
      # expected, timestamp, start_hour, finish_hour, weekdays, days, months
      [false, '2018-10-15 19:00Z', 18, 12, :monday, 15, :november],
      [true, '2018-10-15 19:00Z', 18, 12, :tuesday, 15, nil],
      [false, '2018-10-15 19:00Z', 18, 12, :monday, 15, :october],
      [true, '2018-09-15 19:00Z', 18, 12, :monday, 15, nil],
      [false, '2018-09-15 19:00Z', 18, 12, :saturday, 15, nil],
      [true, '2018-09-15 13:00Z', 18, 12, :saturday, 15, nil],
      [false, '2018-09-15 13:00Z', nil, nil, :saturday, 15, nil],
      [false, '2018-09-15 13:00Z', nil, nil, :saturday, nil, nil],
      [true, '2018-09-15 13:00Z', nil, nil, :monday, nil, nil],
      [true, '2018-09-15 13:00Z', nil, nil, :monday, 15, nil],
      [true, '2018-09-15 13:00Z', nil, nil, :monday, 15, nil],
      [true, '2018-09-15 13:00Z', 18, 12, :saturday, nil, nil],
      [false, '2018-09-15 13:00Z', 10, 18, :saturday, nil, nil],
      [false, '2018-09-15 13:00Z', nil, nil, nil, 15, nil],
      [true, '2018-09-15 13:00Z', nil, nil, nil, 17, nil],
      [true, '2018-09-15 13:00Z', 10, 14, nil, 17, nil],
      [false, '2018-09-15 13:00Z', 10, 14, nil, nil, nil],
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

  describe '#to_matrix' do
    it 'works' do
      schedule = described_class.new(weekdays: :friday, start_hour: 10, finish_hour: 14)
      matrix = schedule.to_matrix(start_date: '2018-09-14', finish_date: '2018-09-16')

      expected = [
        [
          true, true, true, true, true, true, true, true, true, true, # 00-09
          false, false, false, false, false, # 10-14
          true, true, true, true, true, true, true, true, true, # 15-23
        ],
        [true] * 24
      ]

      expect(matrix).to eq(expected)
    end
  end
end
