require "rails_helper"

describe "Videos" do
  let!(:video1) { FactoryGirl.create(:video, published: true) }
  let!(:video2) { FactoryGirl.create(:video, published: true) }
  let!(:unpublished_video) { FactoryGirl.create(:video, published: false) }

  describe "GET /videos" do
    it "returns videos index page" do
      get "/videos"
      expect(response).to be_successful
    end
  end

  describe "GET /videos/:id" do
    it "shows video page" do
      get "/videos/#{video1.id}"
      expect(response).to be_successful
    end
  end
end