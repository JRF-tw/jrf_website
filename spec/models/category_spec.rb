require 'spec_helper'

describe Category do
  let(:category) {FactoryBot.create(:category)}

  it "#factory_creat_success" do
    expect {
      FactoryBot.create :category
    }.to change { Category.count }.by(1)
  end
end