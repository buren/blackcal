# frozen_string_literal: true

require 'blackcal/time_of_day'

module Blackcal
  # Time utils module
  module TimeUtil
    # @param [String, Time] time
    # @return [Time] tine as time
    # @see [Time::parse]
    def self.parse(time)
      return Time.parse(time) if time.is_a?(String)

      time
    end

    # Returns the week of month
    # @return [Integer] week of month
    # @see https://stackoverflow.com/a/30470158/955366
    def self.week_of_month(date_or_time, start_day = :sunday)
      date = date_or_time.to_date
      week_start_format = start_day == :sunday ? '%U' : '%W'

      week_of_month_start = Date.new(date.year, date.month, 1)
      week_of_month_start_num = week_of_month_start.strftime(week_start_format).to_i
      # Skip first week if doesn't contain a Thursday
      week_of_month_start_num += 1 if week_of_month_start.wday > 4

      month_week_index = date.strftime(week_start_format).to_i - week_of_month_start_num
      month_week_index + 1 # Add 1 so that first week is 1 and not 0
    end

    # @param [TimeOfDay, Time, Integer, nil] time_or_hour
    # @param [Integer, nil] min
    def self.time_of_day(time_or_hour, min = nil)
      return unless time_or_hour
      return time_or_hour if time_or_hour.is_a?(TimeOfDay)

      if time_or_hour.is_a?(Time)
        return TimeOfDay.new(time_or_hour.hour, time_or_hour.min)
      end

      if min
        return TimeOfDay.new(time_or_hour, min)
      end

      TimeOfDay.new(time_or_hour)
    end
  end
end
