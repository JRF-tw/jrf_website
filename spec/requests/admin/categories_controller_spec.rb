require "rails_helper"

describe "Admin/Category" do

  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:admin) }
  let(:category) { FactoryBot.create(:category) }
  let(:new_category) do
    {
      name: "new_category_name"
    }
  end

  describe "before login" do
    describe "#index" do
      it "redirect" do
        get "/admin/categories/"
        expect(response).to be_redirect
      end
    end

    describe "#new" do
      it "redirect" do
        get "/admin/categories/new"
        expect(response).to be_redirect
      end
    end

    describe "#edit" do
      it "redirect" do
        get "/admin/categories/#{category.id}/edit"
        expect(response).to be_redirect
      end
    end

    describe "#create" do
      it "redirect" do
        post "/admin/categories", params: { category: new_category }
        expect(response).to be_redirect
      end
    end

    describe "#update" do
      it "redirect" do
        category
        update_data = { name: "new_name" }
        put "/admin/categories/#{category.id}", params: { category: update_data }
        expect(response).to be_redirect
      end
    end

    describe "#destroy" do
      it "redirect" do
        category
        expect {
          delete "/admin/categories/#{category.id}"
        }.to change { Category.count }.by(0)
        expect(response).to be_redirect
      end
    end

    describe "#sort" do
      it "failed" do
        category1 = FactoryBot.create(:category)
        category2 = FactoryBot.create(:category)
        sort_data = {
          category: {
            order: {
              '0': {
                id: category1.id,
                position: 2
              },
              '1': {
                id: category2.id,
                position: 1
              }
            }
          }
        }
        put "/admin/categories/sort", params: sort_data
        category1.reload
        category2.reload
        expect(Category.all).to eq([category1, category2])
      end
    end
  end

  describe "after login" do
    before { sign_in(user) }
    after { sign_out }

    describe "#index" do
      it "redirect" do
        get "/admin/categories/"
        expect(response).to be_redirect
      end
    end

    describe "#new" do
      it "redirect" do
        get "/admin/categories/new"
        expect(response).to be_redirect
      end
    end

    describe "#edit" do
      it "redirect" do
        get "/admin/categories/#{category.id}/edit"
        expect(response).to be_redirect
      end
    end

    describe "#create" do
      it "redirect" do
        post "/admin/categories", params: { category: new_category }
        expect(response).to be_redirect
      end
    end

    describe "#update" do
      it "redirect" do
        category
        update_data = { name: "new_name" }
        put "/admin/categories/#{category.id}", params: { category: update_data }
        expect(response).to be_redirect
      end
    end

    describe "#destroy" do
      it "redirect" do
        category
        expect {
          delete "/admin/categories/#{category.id}"
        }.to change { Category.count }.by(0)
        expect(response).to be_redirect
      end
    end

    describe "#sort" do
      it "failed" do
        category1 = FactoryBot.create(:category)
        category2 = FactoryBot.create(:category)
        sort_data = {
          category: {
            order: {
              '0': {
                id: category1.id,
                position: 2
              },
              '1': {
                id: category2.id,
                position: 1
              }
            }
          }
        }
        put "/admin/categories/sort", params: sort_data
        category1.reload
        category2.reload
        expect(Category.all).to eq([category1, category2])
      end
    end
  end

  describe "after login admin" do
    before { sign_in(admin) }
    after { sign_out }

    describe "#index" do
      it "success" do
        get "/admin/categories/"
        expect(response).to be_successful
      end
    end

    describe "#new" do
      it "success" do
        get "/admin/categories/new"
        expect(response).to be_successful
      end
    end

    describe "#edit" do
      it "success" do
        get "/admin/categories/#{category.id}/edit"
        expect(response).to be_successful
      end
    end

    describe "#create" do
      it "success" do
        post "/admin/categories", params: { category: new_category }
        expect(response).to be_successful
      end
    end

    describe "#update" do
      it "success" do
        category
        update_data = { name: "new_name" }
        put "/admin/categories/#{category.id}", params: { category: update_data }
        expect(response).to be_redirect
      end
    end

    describe "#destroy" do
      it "success" do
        category
        expect {
          delete "/admin/categories/#{category.id}"
        }.to change { Category.count }.by(-1)
        expect(response).to be_redirect
      end
    end

    describe "#sort" do
      it "success" do
        category1 = FactoryBot.create(:category)
        category2 = FactoryBot.create(:category)
        sort_data = {
          category: {
            order: {
              '0': {
                id: category1.id,
                position: 2
              },
              '1': {
                id: category2.id,
                position: 1
              }
            }
          }
        }
        put "/admin/categories/sort", params: sort_data
        category1.reload
        category2.reload
        expect(Category.all).to eq([category2, category1])
      end
    end
  end
end