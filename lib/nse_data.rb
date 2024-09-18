# frozen_string_literal: true

require_relative 'nse_data/version'
require_relative 'nse_data/nse_api_client'

# The NseData module serves as the namespace for the NSE Data gem,
# which provides an interface to interact with and retrieve stock market data
# from the National Stock Exchange of India.
module NseData
  class Error < StandardError; end

  class << self
    # Caches the instance of NseApiClient.
    def nse_api_client
      @nse_api_client ||= NseApiClient.new
    end

    # Dynamically define fetch methods for each API endpoint.
    def define_api_methods
      nse_api_client.endpoints.each_key do |method_name|
        define_singleton_method("fetch_#{method_name}") do |force_refresh: false|
          nse_api_client.fetch_data(method_name, force_refresh:)
        end
      end
    end

    # Returns a list of all available endpoints.
    #
    # @return [Array] An array of endpoint names.
    def list_all_endpoints
      nse_api_client.endpoints
    end

    # Fetches data from a specific API endpoint.
    #
    # @param endpoint [String] The endpoint key.
    # @param force_refresh [Boolean] Skip cache if true.
    # @return [Hash, String] The API response.
    def fetch_data(endpoint, force_refresh: false)
      nse_api_client.fetch_data(endpoint, force_refresh:)
    end
  end

  # Define API methods at runtime.
  define_api_methods
end
