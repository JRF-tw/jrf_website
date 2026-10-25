require "rails_helper"

describe "Admin/Slide" do
  let(:article) { FactoryBot.create(:press_article) }
  let!(:first) { FactoryBot.create(:article_slide, slideable: article, position: 1) }
  let!(:second) { FactoryBot.create(:article_slide, slideable: article, position: 2) }
  let(:order) { { order: { "0" => { id: second.id, position: 1 }, "1" => { id: first.id, position: 2 } } } }

  it "未登入不能排序" do
    put "/admin/slides/sort", params: { slide: order }
    expect(response).to be_redirect
    expect(first.reload.position).to eq(1)
  end

  it "非管理員不能排序" do
    sign_in FactoryBot.create(:user)
    put "/admin/slides/sort", params: { slide: order }
    expect(first.reload.position).to eq(1)
  end

  it "管理員拖曳排序輪播圖" do
    sign_in FactoryBot.create(:admin)
    put "/admin/slides/sort", params: { slide: order }
    expect(response).to be_successful
    expect([first.reload.position, second.reload.position]).to eq([2, 1])
  end
end
