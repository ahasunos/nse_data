require 'faraday'
require 'json'
require "ostruct"

module NseData
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
      response = @connection.get(endpoint)
      response.body
    rescue Faraday::Error => e
      # TODO: Introduce a centralized logger soon.
      puts "Request failed: #{e.message}"
      {}
    end
  end
end
