# frozen_string_literal: true

require 'spec_helper'
require 'nse_data'
require 'nse_data/nse_api_client'

RSpec.describe NseData do
  let(:client) do
    instance_double(NseData::NseApiClient, fetch_data: { key: 'value' },
                                           endpoints: { 'endpoint_key' => 'path/to/endpoint' })
  end

  before do
    allow(NseData).to receive(:nse_api_client).and_return(client)
    NseData.define_api_methods
  end

  describe '.define_api_methods' do
    it 'dynamically defines fetch methods for each endpoint' do
      expect(NseData).to respond_to(:fetch_endpoint_key)
    end
  end

  describe '.list_all_endpoints' do
    it 'returns a list of all endpoints' do
      expect(NseData.list_all_endpoints).to eq({ 'endpoint_key' => 'path/to/endpoint' })
    end
  end

  describe '.fetch_data' do
    it 'fetches data from the specified endpoint' do
      expect(NseData.fetch_data('endpoint_key')).to eq({ key: 'value' })
    end
  end
end
