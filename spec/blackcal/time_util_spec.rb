# frozen_string_literal: true

require 'spec_helper'
require 'time'

RSpec.describe Blackcal::TimeUtil do
  describe '::parse' do
    [
      # input, expected
      ['2019-01-01 10:00', Time.parse('2019-01-01 10:00')],
      [Time.parse('2019-01-01 10:00'), Time.parse('2019-01-01 10:00')],
      [nil, nil],
    ].each do |data|
      input, expected = data

      it 'returns time presented as Time object' do
        expect(described_class.parse(input)).to eq(expected)
      end
    end
  end

  describe '::week_of_month' do
    [
      # expected, date, start_of_week
      [3, '2018-09-16', :sunday],
      [2, '2018-09-16', :monday],
      [1, '2018-10-03', :sunday],
      [2, '2018-10-12', :sunday],
      [5, '2018-10-30', :sunday],
    ].each do |data|
      expected, date, start_of_week = data

      it "returns #{expected} for #{date} when week starts on #{start_of_week}" do
        time = Time.parse(date)
        expect(described_class.week_of_month(time, start_of_week)).to eq(expected)
      end
    end
  end

  describe 'time_of_day' do
    [
      # hour, min, expected
      [13, nil, Blackcal::TimeOfDay.new(13)],
      [13, 42, Blackcal::TimeOfDay.new(13, 42)],
      ['2019-01-01 13:42', nil, Blackcal::TimeOfDay.new(13, 42)],
      [Time.parse('2019-01-01 13:42'), nil, Blackcal::TimeOfDay.new(13, 42)],
      [13.42, nil, Blackcal::TimeOfDay.new(13, 42)],
    ].each do |data|
      hour, min, expected = data

      it 'converts arguments to TimeOfDay object' do
        expect(described_class.time_of_day(hour, min)).to eq(expected)
      end
    end
  end
end
