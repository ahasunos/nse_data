# frozen_string_literal: true

require 'faraday'
require 'json'
require_relative 'base_client'

module NseData
  module HttpClient
    # FaradayClient class is responsible for making HTTP requests using Faraday.
    class FaradayClient < BaseClient
      # Sends a GET request to the specified endpoint.
      #
      # @param endpoint [String] The endpoint to send the request to.
      # @return [Faraday::Response] The response object.
      def get(endpoint)
        handle_connection do |connection|
          connection.get(endpoint)
        end
      end

      private

      # Handles the connection to the base URL.
      #
      # @yield [connection] The Faraday connection object.
      # @yieldparam connection [Faraday::Connection] The Faraday connection object.
      # @return [Object] The result of the block execution.
      # @raise [Faraday::Error] If there is an error with the connection.
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
