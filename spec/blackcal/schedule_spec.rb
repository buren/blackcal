# frozen_string_literal: true

require 'spec_helper'
require 'time'

RSpec.describe Blackcal::Schedule do
  describe '#cover?' do
    it 'given no arguments it covers nothing' do
      schedule = described_class.new

      expect(schedule.cover?('2019-01-01 19:00')).to eq(false)
    end

    it 'given only start date covers nothing' do
      schedule = described_class.new(start_time: '2000-01-01')

      expect(schedule.cover?('2019-01-01 19:00')).to eq(false)
    end

    context 'with months' do
      it 'handles disallowed case' do
        schedule = described_class.new(months: %i[january])

        expect(schedule.cover?('2019-01-01 19:00')).to eq(true)
      end
    end

    context 'with start and end hour' do
      it 'handles covered case' do
        schedule = described_class.new(start_hour: 18, finish_hour: 12)

        expect(schedule.cover?('2019-01-01 19:00')).to eq(true)
      end

      it 'handles not covered cases' do
        schedule = described_class.new(start_hour: 18, finish_hour: 12)

        expect(schedule.cover?('2019-01-01 17:00')).to eq(false)
      end
    end

    [
      # expected, timestamp, start_hour, finish_hour, weekdays, days, months, weeks_of_month
      [false, '2018-10-15 19:00Z', 18, 12, :monday, 15, :november, nil],
      [false, '2018-10-15 19:00Z', 18, 12, :tuesday, 15, nil, nil],
      [true, '2018-10-15 19:00Z', 18, 12, :monday, 15, :october, nil],
      [true, '2018-09-15 19:00Z', 18, 12, nil, 15, :september, 2],
      [false, '2018-09-15 19:00Z', 18, 12, nil, 15, :september, 4],
      [false, '2018-09-15 19:00Z', 18, 12, :monday, 15, nil, nil],
      [true, '2018-09-15 19:00Z', 18, 12, :saturday, 15, nil, nil],
      [false, '2018-09-15 13:00Z', 18, 12, :saturday, 15, nil, nil],
      [true, '2018-09-15 19:31Z', 18, Blackcal::TimeOfDay.new(19, 32), :saturday, 15, nil, nil],
      [false, '2018-09-15 19:31Z', 18, Blackcal::TimeOfDay.new(19, 30), :saturday, 15, nil, nil],
      [true, '2018-09-15 13:00Z', nil, nil, :saturday, 15, nil, nil],
      [true, '2018-09-15 13:00Z', nil, nil, :saturday, nil, nil, nil],
      [false, '2018-09-15 13:00Z', nil, nil, :monday, nil, nil, nil],
      [false, '2018-09-15 13:00Z', nil, nil, :monday, 15, nil, nil],
      [false, '2018-09-15 13:00Z', nil, nil, :monday, 15, nil, nil],
      [false, '2018-09-15 13:00Z', 18, 12, :saturday, nil, nil, nil],
      [true, '2018-09-15 13:00Z', 10, 18, :saturday, nil, nil, nil],
      [true, '2018-09-15 13:00Z', nil, nil, nil, 15, nil, nil],
      [false, '2018-09-15 13:00Z', nil, nil, nil, 17, nil, nil],
      [false, '2018-09-15 13:00Z', 10, 14, nil, 17, nil, nil],
      [true, '2018-09-15 13:00Z', 10, 14, nil, nil, nil, nil],
    ].each do |data|
      expected, timestamp, start_hour, finish_hour, weekdays, days, months, weeks_of_month = data

      it "returns #{expected}" do
        schedule = described_class.new(
          start_time: '2000-01-01',
          start_hour: start_hour,
          finish_hour: finish_hour,
          months: months,
          weeks_of_month: weeks_of_month,
          weekdays: weekdays,
          days: days
        )

        expect(schedule.cover?(timestamp)).to eq(expected)
      end
    end
  end

  describe '#to_matrix' do
    it 'works with hour resolution' do
      schedule = described_class.new(weekdays: :friday, start_hour: 10, finish_hour: 14)
      matrix = schedule.to_matrix(start_date: '2018-09-14', finish_date: '2018-09-16')

      expected = [
        [
          *([false] * 10), # 00-09
          *([true] * 5), # 10-14
          *([false] * 9), # 15-23
        ],
        [false] * 24,
      ]

      expect(matrix).to eq(expected)
    end

    it 'works with minute resolution' do
      schedule = described_class.new(
        start_hour: Blackcal::TimeOfDay.new(23, 58),
        finish_hour: Blackcal::TimeOfDay.new(0, 2)
      )
      matrix = schedule.to_matrix(
        start_date: '2018-09-14',
        finish_date: '2018-09-15',
        resolution: :min
      )

      expected = [
        [
          *([true] * 3),
          *([false] * 1435),
          *([true] * 2),
        ],
      ]

      expect(matrix).to eq(expected)
    end
  end
end
