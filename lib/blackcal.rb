# frozen_string_literal: true

require 'blackcal/version'
require 'blackcal/time_util'
require 'blackcal/array_util'
require 'blackcal/schedule'
require 'blackcal/builder'

# Main module
module Blackcal
  # Initialize schedule
  # @return [Schedule]
  # @example All options – using method arguments
  #   schedule = Blackcal.schedule(
  #     months: [:january],
  #     weeks_of_month: [3],
  #     weekdays: [:monday, :tuesday],
  #     start_time_of_day: 18,
  #     finish_time_of_day: 7,
  #     days: 15..25
  #   )
  # @example All options – using block builder
  #   schedule = Blackcal.schedule do
  #     months [:january]
  #     weeks_of_month [3]
  #     weekdays [:monday, :tuesday]
  #     start_time_of_day 18
  #     finish_time_of_day 7
  #     days 15..25
  #   end
  # @see Schedule#initialize
  # @see Builder::dsl
  def self.schedule(**keyword_args, &block)
    builder = Builder.dsl(keyword_args, &block)
    Schedule.new(builder.to_h)
  end
end
