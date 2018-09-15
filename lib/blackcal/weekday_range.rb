# frozen_string_literal: true

module Blackcal
  # Weekday range
  class WeekdayRange
    WEEKDAY_MAP = {
      sunday: 0,
      monday: 1,
      tuesday: 2,
      wednesday: 3,
      thursday: 4,
      friday: 5,
      saturday: 6,
    }.freeze

    # @return [Array<Symbol>] weekdays in range
    attr_reader :weekdays

    # Initialize weekday range
    # @param [Array<String>, Array<Symbol>, String, Symbol, nil] weekdays
    # @example
    #   WeekdayRange.new(:monday)
    # @example
    #   WeekdayRange.new([:monday, :thursday])
    def initialize(weekdays)
      @weekdays = Array(weekdays).map(&:to_sym) if weekdays
    end

    # Returns true if it covers timestamp
    # @return [Boolean]
    def cover?(timestamp)
      return false if @weekdays.nil? || @weekdays.empty?

      weekdays.any? do |weekday|
        WEEKDAY_MAP.fetch(weekday) == timestamp.wday
      end
    end
  end
end
