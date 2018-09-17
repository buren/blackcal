# frozen_string_literal: true

module Blackcal
  # Month range
  class MonthRange
    include Enumerable

    # Map month name to number
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

    # Map month number to name
    MONTH_INVERT_MAP = MONTH_MAP.invert.freeze

    # @return [Array<Symbol>] months in range
    attr_reader :months

    # Initialize month range
    # @param [Array<String>, Array<Symbol>, Array<Integer>, String, Symbol, Integer, nil] months
    # @example
    #   MonthRange.new(:january)
    # @example
    #   MonthRange.new([:december, :january])
    def initialize(months)
      return unless months

      @months = Array(months).map do |month|
        next MONTH_INVERT_MAP.fetch(month) if month.is_a?(Integer)

        month.downcase.to_sym
      end
    end

    # Returns true if it covers timestamp
    # @return [Boolean]
    def cover?(timestamp)
      return false if @months.nil? || @months.empty?

      months.any? do |month|
        MONTH_MAP.fetch(month) == timestamp.month
      end
    end

    # @return [Array<Symbol>] months in range
    alias_method :to_a, :months

    # Iterate over range
    # @see #to_a
    def each(&block)
      to_a.each(&block)
    end
  end
end
