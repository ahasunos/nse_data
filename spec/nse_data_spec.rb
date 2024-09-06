# frozen_string_literal: true

require 'spec_helper'
require 'nse_data'
require 'nse_data/api_manager'

RSpec.describe NseData do
  let(:api_manager) { instance_double('NseData::APIManager') }
  let(:endpoints) do
    {
      'market_data' => { 'path' => '/market/data' },
      'stock_summary' => { 'path' => '/stock/summary' }
    }
  end

  before do
    allow(NseData::APIManager).to receive(:new).and_return(api_manager)
    allow(api_manager).to receive(:load_endpoints).and_return(endpoints)
    allow(api_manager).to receive(:fetch_data).and_return(double('Faraday::Response', body: '{}'))
    allow(api_manager).to receive(:endpoints).and_return(endpoints)
    NseData.define_api_methods
  end

  describe '.define_api_methods' do
    it 'dynamically defines methods for each endpoint' do
      expect(NseData).to respond_to(:fetch_market_data)
      expect(NseData).to respond_to(:fetch_stock_summary)
    end

    it 'calls the APIManager to fetch data when method is invoked' do
      NseData.fetch_market_data
      expect(api_manager).to have_received(:fetch_data).with('market_data')

      NseData.fetch_stock_summary
      expect(api_manager).to have_received(:fetch_data).with('stock_summary')
    end
  end

  describe '.list_all_endpoints' do
    it 'returns a list of all available endpoints' do
      expected_endpoints = { 'market_data' => { 'path' => '/market/data' },
                             'stock_summary' => { 'path' => '/stock/summary' } }
      expect(NseData.list_all_endpoints).to eq(expected_endpoints)
    end
  end
end
