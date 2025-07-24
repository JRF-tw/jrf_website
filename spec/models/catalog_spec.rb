require 'spec_helper'

describe Catalog do
  let(:catalog) {FactoryBot.create(:catalog)}

  it "#factory_creat_success" do
    expect {
      FactoryBot.create :catalog
    }.to change { Catalog.count }.by(1)
  end
end