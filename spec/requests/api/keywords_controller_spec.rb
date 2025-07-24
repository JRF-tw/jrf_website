require "rails_helper"

describe "API::Keywords" do
  let!(:keyword1) { FactoryBot.create(:keyword) }
  let!(:keyword2) { FactoryBot.create(:keyword) }

  describe "GET /api/keywords" do
    it "returns keywords in JSON format" do
      get "/api/keywords", headers: { 'Accept' => 'application/json' }
      expect(response).to be_successful
      expect(response.content_type).to include('application/json')
      
      json_response = JSON.parse(response.body)
      expect(json_response).to be_a(Hash)
      expect(json_response['keywords']).to be_an(Array)
      expect(json_response['keywords'].length).to eq(2)
      expect(json_response['count']).to eq(2)
      expect(json_response['status']).to eq('success')
    end
  end

  describe "GET /api/keywords/:id" do
    it "returns specific keyword in JSON format" do
      get "/api/keywords/#{keyword1.id}", headers: { 'Accept' => 'application/json' }
      expect(response).to be_successful
      expect(response.content_type).to include('application/json')
      
      json_response = JSON.parse(response.body)
      expect(json_response).to be_a(Hash)
      expect(json_response['keyword']['id']).to eq(keyword1.id)
      expect(json_response['keyword']['name']).to eq(keyword1.name)
      expect(json_response['status']).to eq('success')
    end
  end
end