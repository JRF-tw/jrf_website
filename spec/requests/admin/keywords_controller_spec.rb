require "rails_helper"

describe "Admin/Keyword" do

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:keyword) { FactoryGirl.create(:keyword) }
  let(:faq) { FactoryGirl.create(:faq) }
  let(:slide) { FactoryGirl.create(:keyword_slide) }
  let(:new_keyword) do
    {
      name: "new_keyword_name"
    }
  end

  describe "before login" do
    describe "#index" do
      it "redirect" do
        get "/admin/keywords/"
        expect(response).to be_redirect
      end
    end

    describe "#new" do
      it "redirect" do
        get "/admin/keywords/new"
        expect(response).to be_redirect
      end
    end

    describe "#edit" do
      it "redirect" do
        get "/admin/keywords/#{keyword.id}/edit"
        expect(response).to be_redirect
      end
    end

    describe "#create" do
      it "redirect" do
        post "/admin/keywords", keyword: new_keyword
        expect(response).to be_redirect
      end
    end

    describe "#update" do
      it "redirect" do
        keyword
        update_data = { name: "new_name" }
        put "/admin/keywords/#{keyword.id}", keyword: update_data
        expect(response).to be_redirect
      end
    end

    describe "#destroy" do
      it "redirect" do
        keyword
        expect {
          delete "/admin/keywords/#{keyword.id}"
        }.to change { Keyword.count }.by(0)
        expect(response).to be_redirect
      end
    end

    describe "#sort" do
      it "failed" do
        keyword1 = FactoryGirl.create(:keyword)
        keyword2 = FactoryGirl.create(:keyword)
        sort_data = {
          keyword: {
            order: {
              '0': {
                id: keyword1.id,
                position: 2
              },
              '1': {
                id: keyword2.id,
                position: 1
              }
            }
          }
        }
        put "/admin/keywords/sort", sort_data
        keyword1.reload
        keyword2.reload
        expect(Keyword.all).to eq([keyword1, keyword2])
      end
    end
  end

  describe "after login" do
    before { sign_in(user) }
    after { sign_out }

    describe "#index" do
      it "redirect" do
        get "/admin/keywords/"
        expect(response).to be_redirect
      end
    end

    describe "#new" do
      it "redirect" do
        get "/admin/keywords/new"
        expect(response).to be_redirect
      end
    end

    describe "#edit" do
      it "redirect" do
        get "/admin/keywords/#{keyword.id}/edit"
        expect(response).to be_redirect
      end
    end

    describe "#create" do
      it "redirect" do
        post "/admin/keywords", keyword: new_keyword
        expect(response).to be_redirect
      end
    end

    describe "#update" do
      it "redirect" do
        keyword
        update_data = { name: "new_name" }
        put "/admin/keywords/#{keyword.id}", keyword: update_data
        expect(response).to be_redirect
      end
    end

    describe "#destroy" do
      it "redirect" do
        keyword
        expect {
          delete "/admin/keywords/#{keyword.id}"
        }.to change { Keyword.count }.by(0)
        expect(response).to be_redirect
      end
    end

    describe "#sort" do
      it "failed" do
        keyword1 = FactoryGirl.create(:keyword)
        keyword2 = FactoryGirl.create(:keyword)
        sort_data = {
          keyword: {
            order: {
              '0': {
                id: keyword1.id,
                position: 2
              },
              '1': {
                id: keyword2.id,
                position: 1
              }
            }
          }
        }
        put "/admin/keywords/sort", sort_data
        keyword1.reload
        keyword2.reload
        expect(Keyword.all).to eq([keyword1, keyword2])
      end
    end
  end

  describe "after login admin" do
    before { sign_in(admin) }
    after { sign_out }

    describe "#index" do
      it "success" do
        get "/admin/keywords/"
        expect(response).to be_success
      end
    end

    describe "#new" do
      it "success" do
        get "/admin/keywords/new"
        expect(response).to be_success
      end
    end

    describe "#edit" do
      it "success" do
        get "/admin/keywords/#{keyword.id}/edit"
        expect(response).to be_success
      end
    end

    describe "#create" do
      it "success" do
        post "/admin/keywords", keyword: new_keyword
        expect(response).to be_redirect
      end
    end

    describe "#update" do
      it "success" do
        keyword
        update_data = { name: "new_name" }
        put "/admin/keywords/#{keyword.id}", keyword: update_data
        expect(response).to be_redirect
      end
    end

    describe "#destroy" do
      it "success" do
        keyword
        expect {
          delete "/admin/keywords/#{keyword.id}"
        }.to change { Keyword.count }.by(-1)
        expect(response).to be_redirect
      end
    end

    describe "nested #update" do
      it "success" do
        faq
        update_faq_data = {
          faqs_attributes: [
            {
              id: faq.id,
              question: 'new_faq_question'
            }
          ]
        }
        put "/admin/keywords/#{faq.keyword_id}", keyword: update_faq_data
        expect(response).to be_redirect
        faq.reload
        expect(faq.question).to match(update_faq_data[:faqs_attributes][0][:question])
      end
    end

    describe "nested #update delete" do
      it "success" do
        faq
        update_faq_data = {
          faqs_attributes: [
            {
              id: faq.id,
              _destroy: 1
            }
          ]
        }
        expect {
          put "/admin/keywords/#{faq.keyword_id}", keyword: update_faq_data
        }.to change { Faq.count }.by(-1)
      end
    end

    describe "nested slide #update" do
      it "success" do
        slide
        update_slide_data = {
          slides_attributes: [
            {
              id: slide.id,
              image: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, 'spec', 'fixtures', 'test1.jpg')))
            }
          ]
        }
        put "/admin/keywords/#{slide.slideable_id}", keyword: update_slide_data
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
          put "/admin/keywords/#{slide.slideable.id}", keyword: update_slide_data
        }.to change { Slide.count }.by(-1)
      end
    end

    describe "#sort" do
      it "success" do
        keyword1 = FactoryGirl.create(:keyword)
        keyword2 = FactoryGirl.create(:keyword)
        sort_data = {
          keyword: {
            order: {
              '0': {
                id: keyword1.id,
                position: 2
              },
              '1': {
                id: keyword2.id,
                position: 1
              }
            }
          }
        }
        put "/admin/keywords/sort", sort_data
        keyword1.reload
        keyword2.reload
        expect(Keyword.all).to eq([keyword2, keyword1])
      end
    end
  end
end
