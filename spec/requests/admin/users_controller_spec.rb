require "rails_helper"

describe "Admin/User" do

  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:admin) }

  describe "before login" do
    describe "#index" do
      it "redirect" do
        get "/admin/users/"
        expect(response).to be_redirect
      end
    end

    describe "#update" do
      it "redirect" do
        user
        update_data = { admin: 1 }
        put "/admin/users/#{user.id}", params: { user: update_data }
        expect(response).to be_redirect
      end
    end
  end

  describe "after login" do
    before { sign_in(user) }
    after { sign_out }

    describe "#index" do
      it "redirect" do
        get "/admin/users/"
        expect(response).to be_redirect
      end
    end

    describe "#update" do
      it "redirect" do
        user
        update_data = { admin: 1 }
        put "/admin/users/#{user.id}", params: { user: update_data }
        expect(response).to be_redirect
      end
    end
  end

  describe "after login admin" do
    before { sign_in(admin) }
    after { sign_out }

    describe "#index" do
      it "success" do
        get "/admin/users/"
        expect(response).to be_successful
      end
    end

    describe "#update" do
      it "success with nested params" do
        user
        update_data = { admin: 1 }
        put "/admin/users/#{user.id}", params: { user: update_data }
        expect(response).to be_redirect
        user.reload
        expect(user.admin).to eq(true)
      end

      it "success with query params (from link_to)" do
        user
        put "/admin/users/#{user.id}", params: { admin: 1 }
        expect(response).to be_redirect
        user.reload
        expect(user.admin).to eq(true)
      end

      it "can revoke admin permission" do
        admin_user = FactoryBot.create(:admin)
        put "/admin/users/#{admin_user.id}", params: { admin: 0 }
        expect(response).to be_redirect
        admin_user.reload
        expect(admin_user.admin).to eq(false)
      end
    end
  end
end