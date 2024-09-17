# frozen_string_literal: true

require 'api_wrapper'

module NseData
  # Handles API interactions with the NSE using ApiWrapper.
  class NseApiClient
    attr_reader :api_configuration_path, :cache_store

    # Initializes with optional custom settings.
    #
    # @param api_configuration_path [String] Path to the API configuration file.
    # @param cache_store [Object] Custom cache store for caching responses.
    def initialize(api_configuration_path: nil, cache_store: nil)
      @api_configuration_path = api_configuration_path || default_configuration_path
      @cache_store = cache_store
      configure_api_wrapper
    end

    # Fetches data from the specified API endpoint.
    #
    # @param endpoint_key [String] Key for the API endpoint.
    # @param force_refresh [Boolean] Skip cache if true.
    # @return [Hash, String] Response data or raises an error if unsuccessful.
    def fetch_data(endpoint_key, force_refresh: false)
      response = ApiWrapper.fetch_data(endpoint_key, force_refresh:)
      handle_response(response)
    end

    # Returns all API endpoints available in the configuration.
    #
    # @return [Hash] List of endpoints.
    def endpoints
      @endpoints ||= ApiWrapper::ApiManager.new(api_configuration_path).endpoints
    end

    private

    # Configures ApiWrapper with the provided settings.
    def configure_api_wrapper
      ApiWrapper.configure do |config|
        config.api_configuration_path = api_configuration_path
        config.cache_store = cache_store if cache_store
      end
    end

    # Processes the API response.
    #
    # @param response [Faraday::Response] The API response.
    # @return [Hash, String] Parsed response or error message.
    def handle_response(response)
      raise ApiError, "Error: #{response.status} - #{response.body}" unless response.success?

      response.body
    end

    # Default path to the API configuration file.
    def default_configuration_path
      File.join(__dir__, 'config', 'api_endpoints.yml')
    end
  end

  # Custom error class for handling API errors.
  class ApiError < StandardError; end
end
