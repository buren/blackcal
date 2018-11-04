# frozen_string_literal: true

module Blackcal
  # Builder provides a DSL for schedule options
  class Builder
    # Enables a DSL for building schedule options
    # @param [Hash] default data for builder (optional)
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
    # @option finish_time_of_day [TimeOfDay, Time, Integer, nil]
    # @option months [Array<String>, Array<Symbol>, String, Symbol, nil]
    # @option weekdays [Array<String>, Array<Symbol>, String, Symbol, nil]
    # @option weeks_of_month [Array<Integer>, nil]
    # @option days [Array<Integer>, Integer, nil]
    def initialize(data = {}, &block)
      @data = data
      data.each { |attribute, value| send(attribute, value) }
      self.instance_eval(&block) if block
    end

    # @param [Time, Date, String, nil] start_time
    def start_time(start_time)
      @data[:start_time] = TimeUtil.parse(start_time)
    end

    # @param [Time, Date, String, nil] finish_time
    def finish_time(finish_time)
      @data[:finish_time] = TimeUtil.parse(finish_time)
    end

    # @param [TimeOfDay, Time, Integer, nil] start_time_of_day
    # @param [Integer, nil] min minute
    def start_time_of_day(start_time_of_day, min = nil)
      @data[:start_time_of_day] = TimeUtil.time_of_day(start_time_of_day, min)
    end

    # @param [TimeOfDay, Time, Integer, nil] finish_time_of_day
    # @param [Integer, nil] min minute
    def finish_time_of_day(finish_time_of_day, min = nil)
      @data[:finish_time_of_day] = TimeUtil.time_of_day(finish_time_of_day, min)
    end

    # @param [Array<String>, Array<Symbol>, String, Symbol, nil] months
    def months(*months)
      @data[:months] = ArrayUtil.flatten(months)
    end

    # @param [Array<String>, Array<Symbol>, String, Symbol, nil] weekdays
    def weekdays(*weekdays)
      @data[:weekdays] = ArrayUtil.flatten(weekdays)
    end

    # @param [Array<Integer>, nil] weeks_of_month
    def weeks_of_month(*weeks_of_month)
      @data[:weeks_of_month] = ArrayUtil.flatten(weeks_of_month)
    end

    # @param days [Array<Integer>, Integer, nil]
    def days(*days)
      @data[:days] = ArrayUtil.flatten(days)
    end

    # The builder represented as a hash
    # @return [Hash]
    def to_h
      @data
    end
  end
end
