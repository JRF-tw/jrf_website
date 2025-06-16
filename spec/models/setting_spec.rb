require "rails_helper"

describe Setting do
  it "should load from config file" do
    expect(Setting).to respond_to(:url)
    expect(Setting.url.host).to eq("localhost:3000")
  end

  it "should have required configuration keys" do
    expect(Setting.url).to be_present
    expect(Setting.google_auth_key).to be_present
    expect(Setting.facebook_auth_key).to be_present
  end

  it "should access nested configuration" do
    expect(Setting.url.host).to eq("localhost:3000")
    expect(Setting.url.protocol).to eq("http")
    expect(Setting.google_auth_key.client_id).to be_present
  end
end