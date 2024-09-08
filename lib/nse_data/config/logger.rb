# frozen_string_literal: true

require 'logger'
require 'tempfile'
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
      # Creates a default temporary log file.
      def self.default_log_file
        temp_file = Tempfile.new(['nse_data', '.log'])
        temp_file.close # Close the file immediately after creation
        temp_file.path # Return the file path for the Logger
      end

      # Initializes the Logger with a default or custom Logger instance.
      #
      # @param logger [Logger] Optional custom Logger instance.
      def initialize(logger = ::Logger.new(self.class.default_log_file))
        super()
        @logger = logger
        @settings[:logger] = logger
        # puts "Log file created at: #{self.class.default_log_file}"
      end

      # Retrieves/Sets the Logger instance.
      attr_accessor :logger
    end
  end
end
