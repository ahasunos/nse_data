# frozen_string_literal: true

# spec/nse_data/api/special_preopen_spec.rb
require 'spec_helper'
require 'nse_data/api/special_preopen'

RSpec.describe NseData::API::SpecialPreopen do
  let(:client) { instance_double(NseData::Client) }
  let(:api) { described_class.new(client) }

  describe '#fetch' do
    it 'returns special pre-open data as a hash' do
      response_body = { 'data' => 'sample data' }.to_json
      allow(client).to receive(:get).with('special-preopen-listing').and_return(JSON.parse(response_body))

      result = api.fetch
      expect(result).to be_a(Hash)
      expect(result).to eq({ 'data' => 'sample data' })
    end
  end
end
