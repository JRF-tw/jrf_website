require "rails_helper"

describe "Admin/Catalog" do

  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:admin) }
  let(:catalog) { FactoryBot.create(:catalog) }
  let(:new_catalog) do
    {
      name: "new_catalog_name"
    }
  end

  describe "before login" do
    describe "#index" do
      it "redirect" do
        get "/admin/catalogs/"
        expect(response).to be_redirect
      end
    end

    describe "#new" do
      it "redirect" do
        get "/admin/catalogs/new"
        expect(response).to be_redirect
      end
    end

    describe "#edit" do
      it "redirect" do
        get "/admin/catalogs/#{catalog.id}/edit"
        expect(response).to be_redirect
      end
    end

    describe "#create" do
      it "redirect" do
        post "/admin/catalogs", params: { catalog: new_catalog }
        expect(response).to be_redirect
      end
    end

    describe "#update" do
      it "redirect" do
        catalog
        update_data = { name: "new_name" }
        put "/admin/catalogs/#{catalog.id}", params: { catalog: update_data }
        expect(response).to be_redirect
      end
    end

    describe "#destroy" do
      it "redirect" do
        catalog
        expect {
          delete "/admin/catalogs/#{catalog.id}"
        }.to change { Catalog.count }.by(0)
        expect(response).to be_redirect
      end
    end

    describe "#sort" do
      it "failed" do
        catalog1 = FactoryBot.create(:catalog)
        catalog2 = FactoryBot.create(:catalog)
        sort_data = {
          catalog: {
            order: {
              '0': {
                id: catalog1.id,
                position: 2
              },
              '1': {
                id: catalog2.id,
                position: 1
              }
            }
          }
        }
        put "/admin/catalogs/sort", params: sort_data
        catalog1.reload
        catalog2.reload
        expect(Catalog.all).to eq([catalog1, catalog2])
      end
    end
  end

  describe "after login" do
    before { sign_in(user) }
    after { sign_out }

    describe "#index" do
      it "redirect" do
        get "/admin/catalogs/"
        expect(response).to be_redirect
      end
    end

    describe "#new" do
      it "redirect" do
        get "/admin/catalogs/new"
        expect(response).to be_redirect
      end
    end

    describe "#edit" do
      it "redirect" do
        get "/admin/catalogs/#{catalog.id}/edit"
        expect(response).to be_redirect
      end
    end

    describe "#create" do
      it "redirect" do
        post "/admin/catalogs", params: { catalog: new_catalog }
        expect(response).to be_redirect
      end
    end

    describe "#update" do
      it "redirect" do
        catalog
        update_data = { name: "new_name" }
        put "/admin/catalogs/#{catalog.id}", params: { catalog: update_data }
        expect(response).to be_redirect
      end
    end

    describe "#destroy" do
      it "redirect" do
        catalog
        expect {
          delete "/admin/catalogs/#{catalog.id}"
        }.to change { Catalog.count }.by(0)
        expect(response).to be_redirect
      end
    end

    describe "#sort" do
      it "failed" do
        catalog1 = FactoryBot.create(:catalog)
        catalog2 = FactoryBot.create(:catalog)
        sort_data = {
          catalog: {
            order: {
              '0': {
                id: catalog1.id,
                position: 2
              },
              '1': {
                id: catalog2.id,
                position: 1
              }
            }
          }
        }
        put "/admin/catalogs/sort", params: sort_data
        catalog1.reload
        catalog2.reload
        expect(Catalog.all).to eq([catalog1, catalog2])
      end
    end
  end

  describe "after login admin" do
    before { sign_in(admin) }
    after { sign_out }

    describe "#index" do
      it "success" do
        get "/admin/catalogs/"
        expect(response).to be_successful
      end
    end

    describe "#new" do
      it "success" do
        get "/admin/catalogs/new"
        expect(response).to be_successful
      end
    end

    describe "#edit" do
      it "success" do
        get "/admin/catalogs/#{catalog.id}/edit"
        expect(response).to be_successful
      end
    end

    describe "#create" do
      it "success" do
        post "/admin/catalogs", params: { catalog: new_catalog }
        expect(response).to be_successful
      end
    end

    describe "#update" do
      it "success" do
        catalog
        update_data = { name: "new_name" }
        put "/admin/catalogs/#{catalog.id}", params: { catalog: update_data }
        expect(response).to be_redirect
      end
    end

    describe "#destroy" do
      it "success" do
        catalog
        expect {
          delete "/admin/catalogs/#{catalog.id}"
        }.to change { Catalog.count }.by(-1)
        expect(response).to be_redirect
      end
    end

    describe "#sort" do
      it "success" do
        catalog1 = FactoryBot.create(:catalog)
        catalog2 = FactoryBot.create(:catalog)
        sort_data = {
          catalog: {
            order: {
              '0': {
                id: catalog1.id,
                position: 2
              },
              '1': {
                id: catalog2.id,
                position: 1
              }
            }
          }
        }
        put "/admin/catalogs/sort", params: sort_data
        catalog1.reload
        catalog2.reload
        expect(Catalog.all).to eq([catalog2, catalog1])
      end
    end
  end
end