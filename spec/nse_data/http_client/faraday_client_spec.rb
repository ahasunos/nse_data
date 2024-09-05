# frozen_string_literal: true

# spec/nse_data/http_client/faraday_client_spec.rb
require 'spec_helper'
require 'nse_data/http_client/faraday_client'

RSpec.describe NseData::HttpClient::FaradayClient do
  let(:base_url) { 'https://www.nseindia.com/api/' }
  let(:client) { described_class.new(base_url) }

  describe '#get' do
    context 'when a connection is successful' do
      it 'returns the response body' do
        endpoint = 'special-preopen-listing'
        response_body = { 'status' => 'success' }.to_json

        stub_request(:get, "#{base_url}#{endpoint}")
          .with(
            headers: {
              'Accept' => 'application/json',
              'User-Agent' => 'NSEDataClient/1.0'
            }
          )
          .to_return(status: 200, body: response_body, headers: {})

        result = client.get(endpoint)
        expect(JSON.parse(result.body)).to eq('status' => 'success')
      end
    end

    context 'when a connection failure occurs' do
      it 'raises Faraday::Error' do
        endpoint = 'some-endpoint'

        # Simulate a Faraday connection failure
        allow_any_instance_of(Faraday::Connection).to receive(:get)
          .and_raise(Faraday::Error.new('Connection failed'))

        expect { client.get(endpoint) }.to raise_error('Connection failed')
      end
    end
  end
end
