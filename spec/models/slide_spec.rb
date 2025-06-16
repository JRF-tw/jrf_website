require 'spec_helper'

describe Slide do
  let(:keyword_slide) {FactoryBot.create(:keyword_slide)}
  let(:article_slide) {FactoryBot.create(:article_slide)}

  it "#factory_keyword_creat_success" do
    expect {
      FactoryBot.create :keyword_slide
    }.to change { Slide.count }.by(1)
  end

  it "#factory_article_creat_success" do
    expect {
      FactoryBot.create :article_slide
    }.to change { Slide.count }.by(1)
  end
end