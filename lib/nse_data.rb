# frozen_string_literal: true

require_relative 'nse_data/version'
require_relative 'nse_data/client'
require_relative 'nse_data/api/base'
require_relative 'nse_data/api/special_preopen'

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
