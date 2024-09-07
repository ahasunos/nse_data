module NseData
  module Cache
    class CachePolicy
      attr_reader :cache_store

      # Initializes the CachePolicy with a cache store and global TTL.
      #
      # @param cache_store [CacheStore, RedisCacheStore] The cache store to use for caching.
      # @param global_ttl [Integer] The default TTL (in seconds) for caching.
      def initialize(cache_store, global_ttl = 300)
        @cache_store = cache_store
        @global_ttl = global_ttl
        @custom_ttls = {}
        @no_cache_endpoints = []
      end

      # Adds an endpoint that should bypass the cache.
      #
      # @param endpoint [String] The endpoint to exclude from caching.
      def add_no_cache_endpoint(endpoint)
        @no_cache_endpoints << endpoint
      end

      # Adds a custom TTL for a specific endpoint.
      #
      # @param endpoint [String] The endpoint to apply a custom TTL to.
      # @param ttl [Integer] The custom TTL value in seconds.
      def add_custom_ttl(endpoint, ttl = 300)
        @custom_ttls[endpoint] = ttl
      end

      # Returns the TTL for a specific endpoint. Defaults to the global TTL if no custom TTL is set.
      #
      # @param endpoint [String] The endpoint to fetch the TTL for.
      # @return [Integer] The TTL in seconds.
      def ttl_for(endpoint)
        @custom_ttls.fetch(endpoint, @global_ttl)
      end

      # Determines if caching should be used for the given endpoint.
      #
      # @param endpoint [String] The endpoint to check.
      # @return [Boolean] True if caching is enabled for the endpoint, false otherwise.
      def use_cache?(endpoint)
        !@no_cache_endpoints.include?(endpoint)
      end

      # Fetches the data for the given endpoint, using cache if applicable.
      #
      # @param endpoint [String] The endpoint to fetch data for.
      # @param force_refresh [Boolean] Whether to force refresh the data, bypassing the cache.
      # @yield The block that fetches fresh data if cache is not used or is stale.
      # @return [Object] The data fetched from cache or fresh data.
      def fetch(endpoint, force_refresh: false)
        ttl = @custom_ttls.fetch(endpoint, @global_ttl)

        if force_refresh || !use_cache?(endpoint)
          fresh_data = yield
          # Ensure that fresh_data is wrapped as a Faraday::Response
          @cache_store.write(endpoint, fresh_data.body, ttl) if fresh_data.is_a?(Faraday::Response)
          fresh_data
        else
          cached_data = @cache_store.read(endpoint)
          if cached_data
            # Return cached data wrapped in a Faraday::Response object
            Faraday::Response.new(body: cached_data)
          else
            # Fetch fresh data and store it in the cache
            fresh_data = yield
            @cache_store.write(endpoint, fresh_data.body, ttl) if fresh_data.is_a?(Faraday::Response)
            fresh_data
          end
        end
      end
    end
  end
end
