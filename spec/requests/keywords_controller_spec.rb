require "spec_helper"

describe "Keyword" do


  let(:keyword) { FactoryBot.create(:keyword) }
  let(:new_keyword) do
    {
      name: "new_keyword_name",
    }
  end

  describe "#show" do
    it "success" do
      get "/keywords/#{keyword.id}"
      expect(response).to be_successful
    end
  end

  describe "#show_with_faq" do
    it "success" do
      2.times { FactoryBot.create(:faq, keyword: keyword) }
      get "/keywords/#{keyword.id}"
      expect(response).to be_successful
    end
  end
end