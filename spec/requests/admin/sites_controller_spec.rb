require "rails_helper"

describe "Admin::Sites" do
  let(:admin) { FactoryBot.create(:admin) }
  let(:site) { FactoryBot.create(:site) }
  let(:new_site_params) do
    {
      title: "New Site",
      url: "http://example.com",
      description: "Test site description",
      image: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'test.jpg'))
    }
  end

  before { sign_in(admin) }
  after { sign_out }

  describe "GET /admin/sites" do
    it "shows sites index" do
      get "/admin/sites"
      expect(response).to be_successful
    end
  end

  describe "GET /admin/sites/new" do
    it "shows new site form" do
      get "/admin/sites/new"
      expect(response).to be_successful
    end
  end

  describe "POST /admin/sites" do
    it "creates new site" do
      expect {
        post "/admin/sites", params: { site: new_site_params }
      }.to change { Site.count }.by(1)
      expect(response).to be_redirect
    end
  end

  describe "GET /admin/sites/:id/edit" do
    it "shows edit site form" do
      get "/admin/sites/#{site.id}/edit"
      expect(response).to be_successful
    end
  end

  describe "PUT /admin/sites/:id" do
    it "updates site" do
      put "/admin/sites/#{site.id}", params: { site: { title: "Updated Title" } }
      expect(response).to be_redirect
      site.reload
      expect(site.title).to eq("Updated Title")
    end
  end

  describe "DELETE /admin/sites/:id" do
    it "deletes site" do
      site
      expect {
        delete "/admin/sites/#{site.id}"
      }.to change { Site.count }.by(-1)
      expect(response).to be_redirect
    end
  end
end