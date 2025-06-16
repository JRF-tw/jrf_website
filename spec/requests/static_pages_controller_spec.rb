require "rails_helper"

describe "Static Pages" do

  describe "#home" do
    it "success" do
      2.times { FactoryBot.create :keyword }
      2.times { FactoryBot.create :article }
      get "/"
      expect(response).to be_successful
    end
  end

  describe "#about" do
    it "success" do
      FactoryBot.create :about_article
      get "/about"
      expect(response).to be_successful
    end
  end

  describe "#donate" do
    it "success" do
      FactoryBot.create :donate_article
      get "/donate"
      expect(response).to be_successful
    end
  end

  describe "#sitemap" do
    it "success" do
      2.times { FactoryBot.create :keyword }
      2.times { FactoryBot.create :article }
      get "/sitemap.xml"
      expect(response).to be_successful
    end
  end
end