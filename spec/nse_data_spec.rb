# frozen_string_literal: true

require 'spec_helper'
require 'nse_data'
require 'nse_data/api_manager'

RSpec.describe NseData do
  let(:api_endpoints) do
    {
      'endpoint1' => { 'path' => '/api/endpoint1' },
      'endpoint2' => { 'path' => '/api/endpoint2' }
    }
  end

  before do
    # Mock the APIManager to control its behavior
    api_manager_double = instance_double('NseData::APIManager')
    allow(api_manager_double).to receive(:load_endpoints).and_return(api_endpoints)
    allow(NseData::APIManager).to receive(:new).and_return(api_manager_double)
  end

  describe '.list_all_endpoints' do
    it 'returns all endpoints loaded by APIManager' do
      endpoints = NseData.list_all_endpoints
      expect(endpoints).to eq(api_endpoints)
    end
  end
end
