require "rails_helper"

describe "Admin::Faqs" do
  let(:admin) { FactoryBot.create(:admin) }
  let(:keyword) { FactoryBot.create(:keyword) }
  let(:faq) { FactoryBot.create(:faq, keyword: keyword) }

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
      faq1 = FactoryBot.create(:faq, keyword: keyword, position: 1)
      faq2 = FactoryBot.create(:faq, keyword: keyword, position: 2)
      
      put "/admin/faqs/sort", params: { 
        faq: { 
          order: [
            { id: faq2.id, position: 1 },
            { id: faq1.id, position: 2 }
          ]
        }
      }
      expect(response).to be_successful
    end
  end
end