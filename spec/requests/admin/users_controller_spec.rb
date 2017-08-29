require "rails_helper"

describe "Admin/User" do

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }

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
        expect(response).to be_success
      end
    end

    describe "#update" do
      it "success" do
        user
        update_data = { admin: 1 }
        put "/admin/users/#{user.id}", params: { user: update_data }
        expect(response).to be_redirect
        user.reload
        expect(user.admin).to eq(true)
      end
    end
  end
end