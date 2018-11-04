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
        finish_hour_of_day 7
        months :january
        weekdays :monday, :wednesday
        weeks_of_month 1, 3
        days [15, 18]
      end

      expected = {
        start_time: Time.parse('2019-01-01'),
        finish_time: Time.parse('2020-01-01'),
        start_time_of_day: 18,
        finish_hour_of_day: 7,
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
end
