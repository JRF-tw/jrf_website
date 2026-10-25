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

  # config.yml.default 用 <<: *defaults 共用設定，Ruby 3.1 起 YAML.load 預設不接受 alias
  it "reads config files that use YAML aliases" do
    file = Tempfile.new(["config", ".yml"])
    file.write(<<~YAML)
      defaults: &defaults
        url:
          host: "example.org"
      #{Rails.env}:
        <<: *defaults
        admin_email: "admin@example.org"
    YAML
    file.close
    setting = Setting.new(file.path)
    expect(setting.url.host).to eq("example.org")
    expect(setting.admin_email).to eq("admin@example.org")
  ensure
    file&.unlink
  end

  it "reads config.yml.default" do
    setting = Setting.new(Rails.root.join("config", "config.yml.default").to_s)
    expect(setting.url).to respond_to(:host)
  end
end