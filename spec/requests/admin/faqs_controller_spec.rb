require "rails_helper"

describe "Admin::Faqs" do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:keyword) { FactoryGirl.create(:keyword) }
  let(:faq) { FactoryGirl.create(:faq, keyword: keyword) }

  before { sign_in(admin) }
  after { sign_out }

  describe "GET /admin/keywords/:keyword_id/faqs" do
    it "shows faqs for keyword" do
      get "/admin/keywords/#{keyword.id}/faqs"
      expect(response).to be_successful
    end
  end

  describe "PUT /admin/faqs/sort" do
    it "handles faq sorting" do
      faq1 = FactoryGirl.create(:faq, keyword: keyword, position: 1)
      faq2 = FactoryGirl.create(:faq, keyword: keyword, position: 2)
      
      put "/admin/faqs/sort", params: { faq: [faq2.id, faq1.id] }
      expect(response).to be_successful
    end
  end
end