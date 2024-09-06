# frozen_string_literal: true

require 'nse_data'

apis = NseData.list_all_endpoints
puts apis

api_manager = NseData::APIManager.new
response = api_manager.fetch_data('index_names')
puts response.body
