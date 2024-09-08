# frozen_string_literal: true

require_relative 'nse_data/version'
require_relative 'nse_data/api_manager'
require_relative 'nse_data/config/logger'

# The NseData module serves as the namespace for the NSE Data gem,
# which provides an interface to interact with and retrieve stock market data
# from the National Stock Exchange of India.
module NseData
  class Error < StandardError; end

  class << self
    # This module provides functionality for accessing NSE data.
    def define_api_methods
      api_manager = APIManager.new
      api_manager.endpoints.each_key do |method_name|
        define_singleton_method("fetch_#{method_name}") do
          api_manager.fetch_data(method_name).body
        end
      end
    end

    # Returns a list of all available endpoints.
    #
    # @return [Array] An array of endpoint names.
    def list_all_endpoints
      @list_all_endpoints ||= APIManager.new.load_endpoints
    end

    # Configure the logger for the NseData gem.
    #
    # This method allows users to customize the logger used throughout the library.
    # To use it, call `NseData.configure` and provide a block to set up the logger.
    #
    # Example:
    #
    # NseData.configure do |config|
    #   custom_logger = Logger.new('nse_data.log')
    #   custom_logger.level = Logger::DEBUG
    #   config.logger = custom_logger
    # end
    #
    # @yieldparam [NseData::Config::Logger] config The configuration object to be customized.
    def configure
      @logger_config ||= Config::Logger.new
      yield(@logger_config) if block_given?
    end

    # Access the configured logger.
    #
    # This method returns the Logger instance configured through `NseData.configure`.
    #
    # @return [Logger] The configured Logger instance.
    # @raise [RuntimeError] If the logger has not been configured.
    def logger
      @logger_config&.logger || (raise 'Logger not configured. Please call NseData.configure first.')
    end
  end

  # Initialize configuration with default settings.
  @logger_config = Config::Logger.new
end

NseData.define_api_methods
