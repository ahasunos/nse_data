# frozen_string_literal: true

module NseData
  module API
    # NseData::API::Base serves as the base class for making API calls to the NSE.
    # It contains shared functionality that other API classes can inherit and extend.
    class Base
      def initialize(client)
        @client = client
      end

      def endpoint
        raise NotImplementedError, 'Subclasses must define the endpoint method'
      end

      def fetch
        @client.get(endpoint)
      end
    end
  end
end
