# frozen_string_literal: true

require_relative 'nse_data/version'
require_relative 'nse_data/client'
require_relative 'nse_data/api/base'
require_relative 'nse_data/api/special_preopen'

# The NseData module serves as the namespace for the NSE Data gem,
# which provides an interface to interact with and retrieve stock market data
# from the National Stock Exchange of India.
module NseData
  class Error < StandardError; end

  # Add any additional code or configuration here

  # Example: Expose classes or methods for easy access
  def self.client
    @client ||= Client.new
  end

  def self.special_preopen_api
    @special_preopen_api ||= API::SpecialPreopen.new(client)
  end
end
