require "rails_helper"

describe "Admin/Article" do

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:article) { FactoryGirl.create(:press_article) }
  let(:slide) { FactoryGirl.create(:article_slide) }
  let(:new_article) do
    {
      title: "new_article_title",
      content: "new_article_content",
      kind: "activity",
      published_at: 1.day.ago,
      image: File.open(File.join(Rails.root, 'spec', 'fixtures', 'test.jpg')),
      published: true
    }
  end

  describe "before login" do
    describe "#index" do
      it "redirect" do
        get "/admin/articles/"
        expect(response).to be_redirect
      end
    end

    describe "#new" do
      it "redirect" do
        get "/admin/articles/new"
        expect(response).to be_redirect
      end
    end

    describe "#edit" do
      it "redirect" do
        get "/admin/articles/#{article.id}/edit"
        expect(response).to be_redirect
      end
    end

    describe "#create" do
      it "redirect" do
        post "/admin/articles", article: new_article
        expect(response).to be_redirect
      end
    end

    describe "#update" do
      it "redirect" do
        article
        update_data = { title: "new_title" }
        put "/admin/articles/#{article.id}", article: update_data
        expect(response).to be_redirect
      end
    end

    describe "#destroy" do
      it "redirect" do
        article
        expect {
          delete "/admin/articles/#{article.id}"
        }.to change { Article.count }.by(0)
        expect(response).to be_redirect
      end
    end
  end
  describe "after login" do
    before { sign_in(user) }
    after { sign_out }

    describe "#index" do
      it "redirect" do
        get "/admin/articles/"
        expect(response).to be_redirect
      end
    end

    describe "#new" do
      it "redirect" do
        get "/admin/articles/new"
        expect(response).to be_redirect
      end
    end

    describe "#edit" do
      it "redirect" do
        get "/admin/articles/#{article.id}/edit"
        expect(response).to be_redirect
      end
    end

    describe "#create" do
      it "redirect" do
        post "/admin/articles", article: new_article
        expect(response).to be_redirect
      end
    end

    describe "#update" do
      it "redirect" do
        article
        update_data = { title: "new_title" }
        put "/admin/articles/#{article.id}", article: update_data
        expect(response).to be_redirect
      end
    end

    describe "#destroy" do
      it "redirect" do
        article
        expect {
          delete "/admin/articles/#{article.id}"
        }.to change { Article.count }.by(0)
        expect(response).to be_redirect
      end
    end
  end

  describe "after login admin" do
    before { sign_in(admin) }
    after { sign_out }

    describe "#index" do
      it "success" do
        get "/admin/articles/"
        expect(response).to be_success
      end
    end

    describe "#new" do
      it "success" do
        get "/admin/articles/new"
        expect(response).to be_success
      end
    end

    describe "#edit" do
      it "success" do
        get "/admin/articles/#{article.id}/edit"
        expect(response).to be_success
      end
    end

    describe "#create" do
      it "success" do
        post "/admin/articles", article: new_article
        expect(response).to be_redirect
      end
    end

    describe "#update" do
      it "success" do
        article
        update_data = { title: "new_title" }
        put "/admin/articles/#{article.id}", article: update_data
        expect(response).to be_redirect
      end
    end

    describe "nested slide #update" do
      it "success" do
        slide
        update_slide_data = {
          slides_attributes: [
            {
              id: slide.id,
              image: File.open(File.join(Rails.root, 'spec', 'fixtures', 'test1.jpg'))
            }
          ]
        }
        put "/admin/articles/#{slide.slideable_id}", article: update_slide_data
        expect(response).to be_redirect
        slide.reload
        expect(File.basename(slide.image.url)).to match('test1.jpg')
      end
    end

    describe "nested slide #update delete" do
      it "success" do
        slide
        update_slide_data = {
          slides_attributes: [
            {
              id: slide.id,
              _destroy: 1
            }
          ]
        }
        expect {
          put "/admin/articles/#{slide.slideable.id}", article: update_slide_data
        }.to change { Slide.count }.by(-1)
      end
    end

    describe "#destroy" do
      it "success" do
        article
        expect {
          delete "/admin/articles/#{article.id}"
        }.to change { Article.count }.by(-1)
        expect(response).to be_redirect
      end
    end
  end
end