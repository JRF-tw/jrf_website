require 'spec_helper'

describe Keyword do
  let(:keyword) {FactoryBot.create(:keyword)}

  it "#factory_creat_success" do
    expect {
      FactoryBot.create :keyword
    }.to change { Keyword.count }.by(1)
  end

  it "should have articles association" do
    expect(keyword).to respond_to(:articles)
  end

  it "should have slides association" do
    expect(keyword).to respond_to(:slides)
  end

  it "should have faqs association" do
    expect(keyword).to respond_to(:faqs)
  end

  describe "cover validation when showed" do
    let(:category) { FactoryBot.create(:category) }

    it "should be valid when showed is true and cover is present" do
      keyword = FactoryBot.build(:keyword, category: category, showed: true)
      expect(keyword).to be_valid
    end

    it "should not be valid when showed is true but cover is blank" do
      keyword = FactoryBot.build(:keyword, category: category, showed: true, cover: nil)
      expect(keyword).not_to be_valid
      expect(keyword.errors[:cover]).to include('當專案在首頁顯示時必須上傳封面圖片')
    end

    it "should be valid when showed is false and cover is blank" do
      keyword = FactoryBot.build(:keyword, category: category, showed: false, cover: nil)
      expect(keyword).to be_valid
    end

    it "should be valid when showed is nil and cover is blank" do
      keyword = FactoryBot.build(:keyword, category: category, showed: nil, cover: nil)
      expect(keyword).to be_valid
    end
  end
end