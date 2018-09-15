# frozen_string_literal: true

require 'blackcal/version'
require 'blackcal/schedule'

# Main module
module Blackcal
  # Initialize schedule
  # @return [Schedule]
  # @see Schedule#initialize
  def self.schedule(**keyword_args)
    Schedule.new(**keyword_args)
  end
end
