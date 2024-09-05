# frozen_string_literal: true

require_relative 'nse_data/version'
require_relative 'nse_data/api_manager'

# The NseData module serves as the namespace for the NSE Data gem,
# which provides an interface to interact with and retrieve stock market data
# from the National Stock Exchange of India.
module NseData
  class Error < StandardError; end

  # Add any additional code or configuration here

  def self.get_all_endpoints
    @endpoints ||= NseData::APIManager.new().load_endpoints
  end
end
