# frozen_string_literal: true

# spec/api_manager_spec.rb
require 'spec_helper'
require 'yaml'
require 'nse_data/api_manager'
require 'nse_data/cache/cache_policy'
require 'nse_data/cache/cache_store'

RSpec.describe NseData::APIManager do
  let(:api_endpoints) do
    {
      'endpoint1' => { 'path' => '/api/endpoint1' },
      'endpoint2' => { 'path' => '/api/endpoint2' }
    }
  end

  let(:yaml_content) { { 'apis' => api_endpoints } }
  let(:faraday_client) { instance_double('NseData::HttpClient::FaradayClient') }
  let(:cache_store) { instance_double('NseData::Cache::CacheStore') }
  let(:cache_policy) { instance_double('NseData::Cache::CachePolicy') }

  before do
    allow(YAML).to receive(:load_file).and_return(yaml_content)
    allow(NseData::HttpClient::FaradayClient).to receive(:new).with(any_args).and_return(faraday_client)
    allow(NseData::Cache::CachePolicy).to receive(:new).and_return(cache_policy)

    # Mock the methods that are called in the configure_cache_policy
    allow(cache_policy).to receive(:add_no_cache_endpoint).with('market_status')
    allow(cache_policy).to receive(:add_custom_ttl).with('equity_master', 600)
  end

  describe '#fetch_data' do
    before do
      allow(faraday_client).to receive(:get).with('/api/endpoint1').and_return('data1')
      allow(faraday_client).to receive(:get).with('/api/endpoint2').and_return('data2')
      allow(cache_policy).to receive(:fetch).with('/api/endpoint1', force_refresh: false).and_yield.and_return('data1')
      allow(cache_policy).to receive(:fetch).with('/api/endpoint2', force_refresh: false).and_yield.and_return('data2')
    end

    it 'fetches data from the correct endpoint using the cache policy' do
      manager = described_class.new(cache_store: cache_store)

      expect(manager.fetch_data('endpoint1')).to eq('data1')
      expect(manager.fetch_data('endpoint2')).to eq('data2')
    end

    it 'raises an error for invalid endpoint keys' do
      manager = described_class.new(cache_store: cache_store)

      expect { manager.fetch_data('invalid_key') }.to raise_error(ArgumentError, 'Invalid endpoint key: invalid_key')
    end

    it 'forces cache refresh when force_refresh is true' do
      manager = described_class.new(cache_store: cache_store)

      expect(cache_policy).to receive(:fetch).with('/api/endpoint1', force_refresh: true).and_yield.and_return('data1')

      expect(manager.fetch_data('endpoint1', force_refresh: true)).to eq('data1')
    end
  end
end
