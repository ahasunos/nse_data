# frozen_string_literal: true

require_relative '../lib/nse_data'

# Get a special preopen API instance
api = NseData.special_preopen_api

# Fetch data
response = api.fetch
# require "byebug"; byebug
puts response

client = NseData::Client.new

# Fetch data from the special pre-open listing endpoint
response = client.get('special-preopen-listing')

# Output the response (which is a Hash)
puts response
