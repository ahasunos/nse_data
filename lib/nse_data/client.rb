# frozen_string_literal: true

require 'faraday'
require 'json'
require 'uri'

module NseData
  # NseData::Client is responsible for handling the HTTP requests
  # and interacting with the NSE API endpoints. It provides methods
  # for making GET requests and processing the responses.
  class Client
    BASE_URL = 'https://www.nseindia.com/api/'

    def initialize
      @connection = Faraday.new(url: BASE_URL) do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.headers['User-Agent'] = 'NSEDataClient/1.0'
        faraday.response :json
        faraday.headers['Accept'] = 'application/json'
        # faraday.response :logger, Logger.new(STDERR) # For debugging
      end
    end

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
