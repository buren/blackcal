# frozen_string_literal: true

module Blackcal
  # Builder provides a DSL for schedule options
  class Builder
    # Enables a DSL for building schedule options
    # @return [Builder]
    # @example
    #   Blackcal.dsl do
    #     months [:january]
    #     days 15..25
    #   end
    def self.dsl(data = {}, &block)
      new(data, &block)
    end

    # Returns a new instance of Builder
    # @param [Hash] data the initial data
    # @option start_time [Time, Date, String, nil]
    # @option finish_time [Time, Date, String, nil]
    # @option start_time_of_day [TimeOfDay, Time, Integer, nil]
    # @option finish_hour_of_day [TimeOfDay, Time, Integer, nil]
    # @option months [Array<String>, Array<Symbol>, String, Symbol, nil]
    # @option weekdays [Array<String>, Array<Symbol>, String, Symbol, nil]
    # @option weeks_of_month [Array<Integer>, nil]
    # @option days [Array<Integer>, Integer, nil]
    def initialize(data = {}, &block)
      @data = data || {}
      self.instance_eval(&block) if block
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
