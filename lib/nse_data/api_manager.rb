# frozen_string_literal: true

require 'yaml'
require_relative 'http_client/faraday_client'

module NseData
  # APIManager class to handle API calls to NSE (National Stock Exchange) India website.
  class APIManager
    BASE_URL = 'https://www.nseindia.com/api/'

    # Initializes a new instance of the APIManager class.
    def initialize
      @client = NseData::HttpClient::FaradayClient.new(BASE_URL)
      @endpoints = load_endpoints
      define_api_methods
    end

    # Fetches data from the specified API endpoint.
    #
    # @param endpoint_key [String] The key of the API endpoint to fetch data from.
    # @return [Faraday::Response] The response object containing the fetched data.
    # @raise [ArgumentError] If the provided endpoint key is invalid.
    def fetch_data(endpoint_key)
      endpoint = @endpoints[endpoint_key]
      raise ArgumentError, "Invalid endpoint key: #{endpoint_key}" unless endpoint

      @client.get(endpoint['path'])
    end

    private

    # Loads the API endpoints from the configuration file.
    #
    # @return [Hash] The hash containing the loaded API endpoints.
    def load_endpoints
      yaml_content = YAML.load_file(File.expand_path('config/api_endpoints.yml', __dir__))
      yaml_content['apis']
    end

    # Defines dynamic API methods based on the loaded endpoints.
    def define_api_methods
      @endpoints.each_key do |method_name|
        self.class.define_method("get_#{method_name}") do
          fetch_data(method_name)
        end
      end
    end
  end
end
