# frozen_string_literal: true

require 'faraday'
require 'faraday-http-cache'
require 'json'
require_relative 'base_client'

module NseData
  module HttpClient
    # FaradayClient class is responsible for making HTTP requests using Faraday.
    class FaradayClient < BaseClient
      # Sends a GET request to the specified endpoint.
      #
      # @param endpoint [String] The endpoint to send the request to.
      # @param force_refresh [Boolean] Whether to force a cache refresh.
      # @return [Faraday::Response] The response object.
      def get(endpoint, force_refresh: false)
        # Use the cache policy to determine whether to fetch from cache or refresh.
        @cache_policy.fetch(endpoint, force_refresh:) do
          handle_connection(endpoint) do |connection|
            connection.get(endpoint)
          end
        end
      end

      private

      # Handles the connection to the base URL.
      #
      # @yield [connection] The Faraday connection object.
      # @yieldparam connection [Faraday::Connection] The Faraday connection object.
      # @return [Object] The result of the block execution.
      # @raise [Faraday::Error] If there is an error with the connection.
      def handle_connection(endpoint)
        connection = build_faraday_connection(endpoint)
        yield(connection)
      rescue Faraday::Error => e
        handle_faraday_error(e)
      end

      def build_faraday_connection(endpoint)
        Faraday.new(url: @base_url) do |faraday|
          configure_faraday(faraday)
          apply_cache_policy(faraday, endpoint) if @cache_policy.use_cache?(endpoint)
          faraday.adapter Faraday.default_adapter
        end
      end

      def configure_faraday(faraday)
        faraday.request :json
        faraday.headers['User-Agent'] = 'NSEDataClient/1.0'
        faraday.response :json
        faraday.headers['Accept'] = 'application/json'
      end

      def apply_cache_policy(faraday, endpoint)
        ttl = @cache_policy.ttl_for(endpoint)
        faraday.use :http_cache, store: @cache_policy.cache_store, expire_after: ttl
      end

      def handle_faraday_error(error)
        raise error.message
      end
    end
  end
end
