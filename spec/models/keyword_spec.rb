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
end