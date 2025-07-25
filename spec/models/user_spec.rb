require "rails_helper"

describe User do
  let(:user) {FactoryBot.create(:user)}

  it "#factory_creat_success" do
    expect {
      FactoryBot.create :user
    }.to change { User.count }.by(1)
  end

  it "#factory_creat_admin_success" do
    expect {
      FactoryBot.create :admin
    }.to change { User.count }.by(1)
  end

  it "should have admin method" do
    expect(user).to respond_to(:admin?)
  end

  it "regular user should not be admin" do
    expect(user.admin?).to be_falsey
  end

  it "admin user should be admin" do
    admin = FactoryBot.create(:admin)
    expect(admin.admin?).to be_truthy
  end

  it "should have articles association" do
    expect(user).to respond_to(:articles)
  end
end