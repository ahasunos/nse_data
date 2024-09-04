require_relative "../lib/nse_data"


# Get a special preopen API instance
api = NseData.special_preopen_api

# Fetch data
response = api.fetch
# require "byebug"; byebug
puts response