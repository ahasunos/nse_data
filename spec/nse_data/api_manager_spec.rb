# frozen_string_literal: true

# spec/api_manager_spec.rb
require 'spec_helper'
require 'yaml'
require 'nse_data/api_manager'

RSpec.describe NseData::APIManager do
  let(:api_endpoints) do
    {
      'endpoint1' => { 'path' => '/api/endpoint1' },
      'endpoint2' => { 'path' => '/api/endpoint2' }
    }
  end

  let(:yaml_content) { { 'apis' => api_endpoints } }
  let(:faraday_client) { instance_double('NseData::HttpClient::FaradayClient') }

  before do
    allow(YAML).to receive(:load_file).and_return(yaml_content)
    allow(NseData::HttpClient::FaradayClient).to receive(:new).with('https://www.nseindia.com/api/').and_return(faraday_client)
  end

  describe '#fetch_data' do
    before do
      allow(faraday_client).to receive(:get).with('/api/endpoint1').and_return('data1')
      allow(faraday_client).to receive(:get).with('/api/endpoint2').and_return('data2')
    end

    it 'fetches data from the correct endpoint' do
      manager = described_class.new

      expect(manager.fetch_data('endpoint1')).to eq('data1')
      expect(manager.fetch_data('endpoint2')).to eq('data2')
    end

    it 'raises an error for invalid endpoint keys' do
      manager = described_class.new

      expect { manager.fetch_data('invalid_key') }.to raise_error(ArgumentError, 'Invalid endpoint key: invalid_key')
    end
  end
end
