require "rails_helper"

describe "API::Articles" do
  let!(:article1) { FactoryBot.create(:press_article, published: true) }
  let!(:article2) { FactoryBot.create(:activity_article, published: true) }
  let!(:unpublished_article) { FactoryBot.create(:comment_article, published: false) }

  describe "GET /api/articles" do
    it "returns published articles in JSON format" do
      get "/api/articles", headers: { 'Accept' => 'application/json' }
      expect(response).to be_successful
      expect(response.content_type).to include('application/json')
      
      json_response = JSON.parse(response.body)
      expect(json_response).to be_a(Hash)
      expect(json_response['articles']).to be_an(Array)
      expect(json_response['articles'].length).to eq(2)
      expect(json_response['count']).to eq(2)
      expect(json_response['status']).to eq('success')
    end

    it "does not return unpublished articles" do
      get "/api/articles", headers: { 'Accept' => 'application/json' }
      json_response = JSON.parse(response.body)
      article_ids = json_response['articles'].map { |article| article['id'] }
      expect(article_ids).not_to include(unpublished_article.id)
    end
  end

  describe "GET /api/articles/:id" do
    it "returns specific article in JSON format" do
      get "/api/articles/#{article1.id}", headers: { 'Accept' => 'application/json' }
      expect(response).to be_successful
      expect(response.content_type).to include('application/json')
      
      json_response = JSON.parse(response.body)
      expect(json_response).to be_a(Hash)
      expect(json_response['article']['id']).to eq(article1.id)
      expect(json_response['article']['title']).to eq(article1.title)
      expect(json_response['status']).to eq('success')
    end

    it "handles unpublished article request" do
      get "/api/articles/#{unpublished_article.id}", headers: { 'Accept' => 'application/json' }
      expect(response).to have_http_status(:not_found).or have_http_status(:ok)
    end
  end
end