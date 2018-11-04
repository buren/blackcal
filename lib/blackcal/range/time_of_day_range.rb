# frozen_string_literal: true

require 'blackcal/time_of_day'

module Blackcal
  # Time of day range
  class TimeOfDayRange
    include Enumerable

    # Initialize time of day range
    # @param [TimeOfDay, Time, Integer, nil] start
    # @param [TimeOfDay, Time, Integer, nil] finish
    def initialize(start, finish = nil)
      @start = start
      @finish = finish
    end

    # Returns true if it covers timestamp
    # @param [Time] timestamp
    # @return [Boolean]
    def cover?(timestamp)
      return false if @start.nil? && @finish.nil?

      t1 = TimeOfDay.new(timestamp.hour, timestamp.min)
      if start == finish
        t1 == start
      elsif start > finish
        t1 <= finish || t1 >= start
      else
        t1 >= start && t1 <= finish
      end
    end

    # Return start hour
    # @return [TimeOfDay]
    def start
      @start_time ||= TimeUtil.time_of_day(@start || 0)
    end

    # Return finish hour
    # @return [TimeOfDay]
    def finish
      @finish_time ||= TimeUtil.time_of_day(@finish || 0)
    end

    # Returns range as an array
    # @param resolution [Symbol] :hour our :min
    # @return [Array<Array<Integer>>] times
    def to_a(resolution: :hour)
      return [] if @start.nil? && @finish.nil?

      if finish < start
        to_time_array(start, TimeOfDay.new(23), resolution) +
          to_time_array(TimeOfDay.new(0), finish, resolution)
      else
        to_time_array(start, finish, resolution)
      end
    end

    # Iterate over range
    # @param resolution [Symbol] :hour our :min
    def each(resolution: :hour, &block)
      to_a(resolution: resolution).each(&block)
    end

    private

    def to_time_array(start, finish, resolution)
      if resolution == :hour
        return (start.hour..finish.hour).map { |hour| [hour, 0] }
      end

      # minute resolution
      times = []
      (start.hour..finish.hour).each do |hour|
        finish_min = if hour == finish.hour && finish.min != 0
                       finish.min
                     else
                       59
                     end
        (start.min..finish_min).each { |min| times << [hour, min] }
      end
      times
    end
  end
end
