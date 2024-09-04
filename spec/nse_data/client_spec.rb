# frozen_string_literal: true

# spec/nse_data/client_spec.rb
require 'spec_helper'
require 'nse_data/client'

RSpec.describe NseData::Client do
  let(:client) { described_class.new }

  describe '#get' do
    it 'returns a hash when calling a valid endpoint' do
      response_body = { 'key' => 'value' }.to_json
      stub_request(:get, "#{NseData::Client::BASE_URL}special-preopen-listing")
        .with(
          headers: {
            'Accept' => 'application/json',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'NSEDataClient/1.0'
          }
        )
        .to_return(status: 200, body: response_body, headers: {})
      result = client.get('special-preopen-listing')
      # Parse the JSON response to a Ruby hash
      result_hash = JSON.parse(result)
      expect(result_hash).to be_a(Hash)
      expect(result_hash).to eq({ 'key' => 'value' })
    end

    it 'returns an empty hash for an invalid endpoint' do
      stub_request(:get, URI.join(NseData::Client::BASE_URL, 'invalid-endpoint').to_s)
        .to_return(status: 404, body: {}.to_json, headers: {})

      result = JSON.parse(client.get('invalid-endpoint'))
      expect(result).to eq({})
    end
  end
end
