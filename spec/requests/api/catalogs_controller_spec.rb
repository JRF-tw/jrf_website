require "rails_helper"

describe "API::Catalogs" do
  let!(:catalog1) { FactoryBot.create(:catalog) }
  let!(:catalog2) { FactoryBot.create(:catalog) }

  describe "GET /api/catalogs" do
    it "returns catalogs in JSON format" do
      get "/api/catalogs", headers: { 'Accept' => 'application/json' }
      expect(response).to be_successful
      expect(response.content_type).to include('application/json')
      
      json_response = JSON.parse(response.body)
      expect(json_response).to be_a(Hash)
      expect(json_response['catalogs']).to be_an(Array)
      expect(json_response['catalogs'].length).to eq(2)
      expect(json_response['count']).to eq(2)
      expect(json_response['status']).to eq('success')
    end
  end

  describe "GET /api/catalogs/:id" do
    it "returns specific catalog in JSON format" do
      get "/api/catalogs/#{catalog1.id}", headers: { 'Accept' => 'application/json' }
      expect(response).to be_successful
      expect(response.content_type).to include('application/json')
      
      json_response = JSON.parse(response.body)
      expect(json_response).to be_a(Hash)
      expect(json_response['catalog']['id']).to eq(catalog1.id)
      expect(json_response['catalog']['name']).to eq(catalog1.name)
      expect(json_response['status']).to eq('success')
    end
  end
end