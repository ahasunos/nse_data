# frozen_string_literal: true

require 'yaml'
require_relative 'http_client/faraday_client'
require_relative 'cache/cache_policy'
require_relative 'cache/cache_store'

module NseData
  # APIManager class to handle API calls to NSE (National Stock Exchange) India website.
  class APIManager
    BASE_URL = 'https://www.nseindia.com/api/'

    # Initializes a new instance of the APIManager class.
    #
    # @param cache_store [CacheStore, RedisCacheStore, nil] The cache store to use for caching.
    # If nil, in-memory cache is used.
    def initialize(cache_store: nil)
      # Initialize cache policy with the provided cache store or default to in-memory cache.
      @cache_policy = NseData::Cache::CachePolicy.new(cache_store || NseData::Cache::CacheStore.new)

      # Configure cache policy (e.g., setting endpoints with no cache or custom TTL).
      configure_cache_policy

      # Initialize Faraday client with the base URL and cache policy.
      @client = NseData::HttpClient::FaradayClient.new(BASE_URL, @cache_policy)

      # Load API endpoints from the configuration file.
      @endpoints = load_endpoints
    end

    # Fetches data from the specified API endpoint.
    #
    # @param endpoint_key [String] The key of the API endpoint to fetch data from.
    # @param force_refresh [Boolean] Whether to force refresh the data, bypassing the cache.
    # @return [Faraday::Response] The response object containing the fetched data.
    # @raise [ArgumentError] If the provided endpoint key is invalid.
    def fetch_data(endpoint_key, force_refresh: false)
      NseData.logger.debug("#{self.class}##{__method__}: fetching data for #{endpoint_key}")
      endpoint = @endpoints[endpoint_key]
      raise ArgumentError, "Invalid endpoint key: #{endpoint_key}" unless endpoint

      # Use cache policy to fetch data, with an option to force refresh.
      @cache_policy.fetch(endpoint['path'], force_refresh:) do
        @client.get(endpoint['path'])
      end
    end

    # Loads the API endpoints from the configuration file.
    #
    # @return [Hash] The hash containing the loaded API endpoints.
    # @raise [RuntimeError] If the configuration file is missing or has syntax errors.
    def load_endpoints
      yaml_content = YAML.load_file(File.expand_path('config/api_endpoints.yml', __dir__))
      yaml_content['apis']
    rescue Errno::ENOENT => e
      raise "Configuration file not found: #{e.message}"
    rescue Psych::SyntaxError => e
      raise "YAML syntax error: #{e.message}"
    end

    # @return [Hash] The hash containing the loaded API endpoints.
    attr_reader :endpoints

    private

    # Configures the cache policy with specific settings.
    #
    # This method sets endpoints that should not be cached and custom TTL values for specific endpoints.
    def configure_cache_policy
      # TODO: Review and refine cache policy for endpoints.
      # Plan to analyze the API responses and categorize endpoints into:
      # - No cache
      # - Cacheable
      # - Custom TTL

      # Set specific endpoints that should not be cached.
      @cache_policy.add_no_cache_endpoint('market_status')

      # Set custom TTL (time-to-live) for specific endpoints.
      @cache_policy.add_custom_ttl('equity_master', 600) # Custom TTL: 10 mins
    end
  end
end
