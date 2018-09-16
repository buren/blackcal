# frozen_string_literal: true

require 'spec_helper'
require 'time'
require 'blackcal/time_util'

RSpec.describe Blackcal::TimeUtil do
  describe '#week_of_month' do
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
end
