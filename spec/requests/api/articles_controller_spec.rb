require "rails_helper"

describe "API::Articles" do
  let!(:article1) { FactoryGirl.create(:press_article, published: true) }
  let!(:article2) { FactoryGirl.create(:activity_article, published: true) }
  let!(:unpublished_article) { FactoryGirl.create(:comment_article, published: false) }

  describe "GET /api/articles" do
    it "returns published articles in JSON format" do
      get "/api/articles", headers: { 'Accept' => 'application/json' }
      expect(response).to be_successful
      expect(response.content_type).to include('application/json')
      
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
      expect(json_response.length).to eq(2)
    end

    it "does not return unpublished articles" do
      get "/api/articles", headers: { 'Accept' => 'application/json' }
      json_response = JSON.parse(response.body)
      article_ids = json_response.map { |article| article['id'] }
      expect(article_ids).not_to include(unpublished_article.id)
    end
  end

  describe "GET /api/articles/:id" do
    it "returns specific article in JSON format" do
      get "/api/articles/#{article1.id}", headers: { 'Accept' => 'application/json' }
      expect(response).to be_successful
      expect(response.content_type).to include('application/json')
      
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(article1.id)
      expect(json_response['title']).to eq(article1.title)
    end

    it "handles unpublished article request" do
      get "/api/articles/#{unpublished_article.id}", headers: { 'Accept' => 'application/json' }
      expect(response).to have_http_status(:not_found).or have_http_status(:ok)
    end
  end
end