# frozen_string_literal: true

require 'spec_helper'
require 'time'

RSpec.describe Blackcal::Builder do
  describe '::dsl' do
    it 'can build' do
      builder = described_class.dsl do
        start_time Time.parse('2019-01-01')
        finish_time Time.parse('2020-01-01')
        start_time_of_day 18
        finish_time_of_day 7
        months :january
        weekdays :monday, :wednesday
        weeks_of_month 1, 3
        days [15, 18]
      end

      expected = {
        start_time: Time.parse('2019-01-01'),
        finish_time: Time.parse('2020-01-01'),
        start_time_of_day: 18,
        finish_time_of_day: 7,
        months: [:january],
        weekdays: [:monday, :wednesday],
        days: [15, 18],
        weeks_of_month: [1, 3]
      }

      expect(builder.to_h).to eq(expected)
    end
  end

  describe '::new' do
    it 'can be initialized with data' do
      time = Time.parse('2019-01-01')
      builder = described_class.new(start_time: time)

      expect(builder.to_h[:start_time]).to eq(time)
    end
  end

  describe '#start_time' do
    it 'can set start_time' do
      builder = described_class.new
      time = Time.parse('2019-01-01')
      builder.start_time(time)

      expect(builder.to_h[:start_time]).to eq(time)
    end

    it 'can set and convert start_time' do
      builder = described_class.new
      time = '2019-01-01'
      builder.start_time(time)

      expect(builder.to_h[:start_time]).to eq(Time.parse(time))
    end
  end

  describe '#finish_time' do
    it 'can set finish_time' do
      builder = described_class.new
      time = Time.parse('2019-01-01')
      builder.finish_time(time)

      expect(builder.to_h[:finish_time]).to eq(time)
    end

    it 'can set and convert finish_time' do
      builder = described_class.new
      time = '2019-01-01'
      builder.finish_time(time)

      expect(builder.to_h[:finish_time]).to eq(Time.parse(time))
    end
  end

  describe '#months' do
    it 'can set months' do
      builder = described_class.new
      builder.months :january

      expect(builder.to_h[:months]).to eq([:january])
    end
  end

  describe '#weekdays' do
    it 'can set weekdays' do
      builder = described_class.new
      builder.weekdays :monday

      expect(builder.to_h[:weekdays]).to eq([:monday])
    end
  end

  describe '#weeks_of_month' do
    it 'can set weeks_of_month' do
      builder = described_class.new
      builder.weeks_of_month 1

      expect(builder.to_h[:weeks_of_month]).to eq([1])
    end
  end

  describe '#days' do
    it 'can set days' do
      builder = described_class.new
      builder.days 13

      expect(builder.to_h[:days]).to eq([13])
    end
  end

  %i[start_time_of_day finish_time_of_day].each do |attribute|
    describe "##{attribute}" do
      [
        # hour_of_day, min, expected
        [13, 42, Blackcal::TimeOfDay.new(13, 42)],
        [13, nil, Blackcal::TimeOfDay.new(13, 0)],
        [Blackcal::TimeOfDay.new(13, 42), nil, Blackcal::TimeOfDay.new(13, 42)],
        [Time.parse('2019-01-01 13:42'), nil, Blackcal::TimeOfDay.new(13, 42)],
      ].each do |data|
        hour_of_day, min, expected = data

        it 'sets the correct start time of day' do
          builder = described_class.new
          time = builder.public_send(attribute, hour_of_day, min)
          expect(time).to eq(expected)
        end
      end
    end
  end
end
