# lib/nse_data/http_client/faraday_client.rb
require 'faraday'
require 'json'
require_relative 'base_client'

module NseData
  module HttpClient
    class FaradayClient < BaseClient
      def get(endpoint)
        handle_connection do |connection|
          connection.get(endpoint)
        end
      end

      private

      def handle_connection
        connection = Faraday.new(url: @base_url) do |faraday|
          faraday.request :json
          faraday.headers['User-Agent'] = 'NSEDataClient/1.0'
          faraday.response :json
          faraday.headers['Accept'] = 'application/json'
          faraday.adapter Faraday.default_adapter
        end

        yield(connection)
      rescue Faraday::Error => e
        raise e.message
      end
    end
  end
end
