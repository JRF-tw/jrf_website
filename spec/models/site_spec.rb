require "rails_helper"

describe Site do
  let(:site) { FactoryGirl.create(:site) }

  it "#factory_create_success" do
    expect {
      FactoryGirl.create :site
    }.to change { Site.count }.by(1)
  end

  it "should order by position asc" do
    site1 = FactoryGirl.create(:site, position: 2)
    site2 = FactoryGirl.create(:site, position: 1)
    expect(Site.all).to eq([site2, site1])
  end

  it "should set position before save" do
    site = FactoryGirl.build(:site, position: nil)
    site.save
    expect(site.position).to be > 0
  end

  it "should auto increment position" do
    existing_site = FactoryGirl.create(:site, position: 5)
    new_site = FactoryGirl.build(:site, position: nil)
    new_site.save
    expect(new_site.position).to eq(6)
  end
end