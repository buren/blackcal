# frozen_string_literal: true

module Blackcal
  # Weekday range
  class WeekdayRange
    include Enumerable

    # Map weekday name to number
    WEEKDAY_MAP = {
      sunday: 0,
      monday: 1,
      tuesday: 2,
      wednesday: 3,
      thursday: 4,
      friday: 5,
      saturday: 6,
    }.freeze

    # Map weekday number to name
    WEEKDAY_INVERT_MAP = WEEKDAY_MAP.invert.freeze

    # @return [Array<Symbol>] weekdays in range
    attr_reader :weekdays

    # Initialize weekday range
    # @param [Array<String>, Array<Symbol>, Array<Integer>, String, Symbol, Integer, nil] weekdays
    # @example
    #   WeekdayRange.new(:monday)
    # @example
    #   WeekdayRange.new([:monday, :thursday])
    def initialize(weekdays)
      return unless weekdays

      @weekdays = Array(weekdays).map do |week|
        next WEEKDAY_INVERT_MAP.fetch(week) if week.is_a?(Integer)

        week.downcase.to_sym
      end
    end

    # Returns true if it covers timestamp
    # @param [Time] timestamp
    # @return [Boolean]
    def cover?(timestamp)
      return false if @weekdays.nil? || @weekdays.empty?

      weekdays.any? do |weekday|
        WEEKDAY_MAP.fetch(weekday) == timestamp.wday
      end
    end

    # @return [Array<Symbol>] weekdays in range
    alias_method :to_a, :weekdays

    # Iterate over range
    # @see #to_a
    def each(&block)
      to_a.each(&block)
    end
  end
end
