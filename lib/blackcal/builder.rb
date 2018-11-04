# frozen_string_literal: true

module Blackcal
  class Builder
    # Enables a DSL for building schedule options
    # @return [Builder]
    # @example
    # Blackcal.dsl do
    #   months [:january]
    #   days (15..25).to_a
    # end
    def self.dsl(&block)
      new.tap { |b| b.instance_eval(&block) }
    end

    # Returns a new instance of Builder
    def initialize
      @data = {}
    end

    # @param [Time, Date, String, nil] start_time
    def start_time(start_time)
      @data[:start_time] = start_time
    end

    # @param [Time, Date, String, nil] finish_time
    def finish_time(finish_time)
      @data[:finish_time] = finish_time
    end

    # @param [TimeOfDay, Time, Integer, nil] start_time_of_day
    def start_time_of_day(start_time_of_day)
      @data[:start_time_of_day] = start_time_of_day
    end

    # @param [TimeOfDay, Time, Integer, nil] finish_hour_of_day
    def finish_hour_of_day(finish_hour_of_day)
      @data[:finish_hour_of_day] = finish_hour_of_day
    end

    # @param [Array<String>, Array<Symbol>, String, Symbol, nil] months
    def months(*months)
      @data[:months] = flat_array(months)
    end

    # @param [Array<String>, Array<Symbol>, String, Symbol, nil] weekdays
    def weekdays(*weekdays)
      @data[:weekdays] = flat_array(weekdays)
    end

    # @param [Array<Integer>, nil] weeks_of_month
    def weeks_of_month(*weeks_of_month)
      @data[:weeks_of_month] = flat_array(weeks_of_month)
    end

    # @param days [Array<Integer>, Integer, nil]
    def days(*days)
      @data[:days] = flat_array(days)
    end

    # The builder represented as a hash
    # @return [Hash]
    def to_h
      @data
    end

    private

    def flat_array(array)
      Array(array).flatten(1)
    end
  end
end
