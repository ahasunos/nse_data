# frozen_string_literal: true

require_relative 'nse_data/version'
require_relative 'nse_data/api_manager'

# The NseData module serves as the namespace for the NSE Data gem,
# which provides an interface to interact with and retrieve stock market data
# from the National Stock Exchange of India.
module NseData
  class Error < StandardError; end

  # This module provides functionality for accessing NSE data.
  def self.define_api_methods
    api_manager = APIManager.new
    api_manager.endpoints.each_key do |method_name|
      define_singleton_method("fetch_#{method_name}") do
        api_manager.fetch_data(method_name).body
      end
    end
  end

  # Returns a list of all available endpoints.
  #
  # @return [Array] An array of endpoint names.
  def self.list_all_endpoints
    @list_all_endpoints ||= APIManager.new.load_endpoints
  end
end

NseData.define_api_methods
