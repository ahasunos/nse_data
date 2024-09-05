# frozen_string_literal: true

require 'faraday'
require 'json'
require 'uri'

module NseData
  # This class represents the client to interact with the NSE API.
  class Client
    BASE_URL = 'https://www.nseindia.com/api/'

    # Initializes the client with a base URL.
    #
    # @param base_url [String] the base URL for the NSE API
    def initialize(base_url = BASE_URL)
      @connection = Faraday.new(url: base_url) do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.headers['User-Agent'] = 'NSEDataClient/1.0'
        faraday.response :json
        faraday.headers['Accept'] = 'application/json'
        # faraday.response :logger, Logger.new(STDERR) # For debugging
      end
    end

    # Fetches data from the specified endpoint.
    #
    # @param endpoint [String] the API endpoint to fetch data from
    # @return [Hash] the parsed JSON response
    def get(endpoint)
      url = URI.join(BASE_URL, endpoint).to_s
      response = @connection.get(url)
      response.body
    rescue Faraday::Error => e
      # TODO: Introduce a centralized logger soon.
      puts "Request failed: #{e.message}"
      {}
    end
  end
end
