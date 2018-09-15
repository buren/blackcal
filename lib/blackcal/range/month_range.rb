# frozen_string_literal: true

module Blackcal
  # Month range
  class MonthRange
    MONTH_MAP = {
      january: 1,
      february: 2,
      march: 3,
      april: 4,
      may: 5,
      june: 6,
      july: 7,
      august: 8,
      september: 9,
      october: 10,
      november: 11,
      december: 12,
    }.freeze

    # @return [Array<Symbol>] months in range
    attr_reader :months

    # Initialize month range
    # @param [Array<String>, Array<Symbol>, String, Symbol, nil] months
    # @example
    #   MonthRange.new(:january)
    # @example
    #   MonthRange.new([:december, :january])
    def initialize(months)
      @months = Array(months).map(&:to_sym) if months
    end

    # Returns true if it covers timestamp
    # @return [Boolean]
    def cover?(timestamp)
      return false if @months.nil? || @months.empty?

      months.any? do |month|
        MONTH_MAP.fetch(month) == timestamp.month
      end
    end
  end
end
