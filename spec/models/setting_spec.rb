require "rails_helper"

describe Setting do
  it "should load from config file" do
    expect(Setting).to respond_to(:url)
  end

  it "should use current environment namespace" do
    expect(Setting.namespace).to eq(Rails.env)
  end

  it "should have source file path" do
    expect(Setting.source).to include("config/config.yml")
  end
end