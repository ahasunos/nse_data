module NseData
  module API
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
