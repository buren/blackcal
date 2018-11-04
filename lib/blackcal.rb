# frozen_string_literal: true

require 'blackcal/version'
require 'blackcal/schedule'
require 'blackcal/builder'

# Main module
module Blackcal
  # Initialize schedule
  # @return [Schedule]
  # @example All options – using method arguments
  # schedule = Blackcal.schedule(
  #   months: [:january],
  #   weeks_of_month: [3],
  #   weekdays: [:monday, :tuesday],
  #   start_time_of_day: 18,
  #   finish_hour_of_day: 7,
  #   days: (15..25).to_a
  # )
  # @example All options – using block builder
  # schedule = Blackcal.schedule do
  #   months [:january]
  #   weeks_of_month [3]
  #   weekdays [:monday, :tuesday]
  #   start_time_of_day 18
  #   finish_hour_of_day 7
  #   days (15..25).to_a
  # end
  # @see Schedule#initialize
  # @see Builder::dsl
  def self.schedule(**keyword_args, &block)
    schedule_args = keyword_args
    schedule_args.merge!(Builder.dsl(&block).to_h) if block
    Schedule.new(schedule_args)
  end
end
