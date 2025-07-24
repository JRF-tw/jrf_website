require 'spec_helper'

describe Faq do
  let(:faq) {FactoryBot.create(:faq)}

  it "#factory_creat_success" do
    expect {
      FactoryBot.create :faq
    }.to change { Faq.count }.by(1)
  end
end