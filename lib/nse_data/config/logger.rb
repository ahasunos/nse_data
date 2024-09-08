# frozen_string_literal: true

require 'logger'
require_relative 'base'

module NseData
  module Config
    # Logger handles configuration specifically for logging.
    #
    # It inherits from Base to utilize the hash-like configuration
    # interface and provides default settings for logging.
    #
    # @attr_reader [Logger] logger The Logger instance configured by this class.
    class Logger < Base
      DEFAULT_LOGGER = ::Logger.new($stdout).tap do |logger|
        logger.level = ::Logger::INFO
      end

      # Initializes the Logger with a default or custom Logger instance.
      #
      # @param logger [Logger] Optional custom Logger instance.
      def initialize(logger = DEFAULT_LOGGER)
        super()
        @logger = logger
        @settings[:logger] = logger
      end

      # Retrieves/Sets the Logger instance.
      attr_accessor :logger
    end
  end
end
