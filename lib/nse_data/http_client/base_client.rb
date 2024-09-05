# frozen_string_literal: true

# lib/nse_data/http_client/base_client.rb
module NseData
  module HttpClient
    # Base class for HTTP clients
    class BaseClient
      def initialize(base_url)
        @base_url = base_url
      end

      def get(endpoint)
        raise NotImplementedError, 'Subclasses must implement the get method'
      end

      # TODO: Other HTTP methods like post, put, delete can be added here if needed
    end
  end
end
