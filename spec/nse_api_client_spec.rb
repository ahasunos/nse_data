# frozen_string_literal: true

require 'spec_helper'
require 'api_wrapper'
require_relative '../lib/nse_data/nse_api_client'

RSpec.describe NseData::NseApiClient do
  let(:api_config_path) { File.join(__dir__, 'fixtures', 'api_endpoints.yml') }
  let(:endpoints) do
    {
      'endpoint1' => {
        'path' => 'path/to/endpoint1',
        'description' => 'Endpoint 1 description',
        'no_cache' => true
      }
    }
  end
  let(:response_body) { { 'status' => 'success' }.to_json }

  subject(:client) { described_class.new(api_configuration_path: api_config_path) }

  describe '#endpoints' do
    it 'returns the endpoints from ApiManager' do
      expect(client.endpoints).to include endpoints
    end
  end

  describe '#fetch_date' do
    it 'returns the body of the response when success' do
      stub_request(:get, 'https://api.example.com/path/to/endpoint1')
        .to_return(status: 200, body: response_body, headers: {})
      expect(client.fetch_data('endpoint1')).to eq(response_body)
    end

    it 'raises an ApiError when response is not success' do
      stub_request(:get, 'https://api.example.com/path/to/endpoint2')
        .to_return(status: 404, body: {}.to_json, headers: {})
      expect { client.fetch_data('endpoint2') }.to raise_error(NseData::ApiError, 'Error: 404 - {}')
    end
  end
end
