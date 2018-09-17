# frozen_string_literal: true

module Blackcal
  # Time utils module
  module TimeUtil
    # Returns the week of month
    # @return [Integer] week of month
    # @see https://stackoverflow.com/a/30470158/955366
    def self.week_of_month(date_or_time, start_day = :sunday)
      date = date_or_time.to_date
      week_start_format = start_day == :sunday ? '%U' : '%W'

      week_of_month_start = Date.new(date.year, date.month, 1)
      week_of_month_start_num = week_of_month_start.strftime(week_start_format).to_i
      week_of_month_start_num += 1 if week_of_month_start.wday > 4 # Skip first week if doesn't contain a Thursday

      month_week_index = date.strftime(week_start_format).to_i - week_of_month_start_num
      month_week_index + 1 # Add 1 so that first week is 1 and not 0
    end
  end
end
