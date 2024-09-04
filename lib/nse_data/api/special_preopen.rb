# frozen_string_literal: true

module NseData
  module API
    # NseData::API::SpecialPreopen inherits from NseData::API::Base
    # and is responsible for fetching the special pre-open market data from the NSE.
    class SpecialPreopen < Base
      def endpoint
        'special-preopen-listing'
      end
    end
  end
end
