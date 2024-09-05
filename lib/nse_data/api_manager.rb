# frozen_string_literal: true

require 'yaml'
require_relative 'http_client/faraday_client'

module NseData
  class APIManager
    BASE_URL = 'https://www.nseindia.com/api/'
    def initialize
      @client = NseData::HttpClient::FaradayClient.new(BASE_URL)
      @endpoints = load_endpoints
      define_api_methods
    end

    def fetch_data(endpoint_key)
      endpoint = @endpoints[endpoint_key]
      raise ArgumentError, "Invalid endpoint key: #{endpoint_key}" unless endpoint
      @client.get(endpoint["path"])
    end

    def load_endpoints
      yaml_content = YAML.load_file(File.expand_path('config/api_endpoints.yml', __dir__))
      yaml_content["apis"]
    end

    private

    def define_api_methods
      @endpoints.each do |method_name, endpoint|
        self.class.define_method("get_#{method_name}") do
          fetch_data(method_name)
        end
      end
    end
  end
end
