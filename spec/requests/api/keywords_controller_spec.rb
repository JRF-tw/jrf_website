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
      expect(json_response).to be_an(Array)
      expect(json_response.length).to eq(2)
    end
  end

  describe "GET /api/keywords/:id" do
    it "returns specific keyword in JSON format" do
      get "/api/keywords/#{keyword1.id}", headers: { 'Accept' => 'application/json' }
      expect(response).to be_successful
      expect(response.content_type).to include('application/json')
      
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(keyword1.id)
      expect(json_response['name']).to eq(keyword1.name)
    end
  end
end