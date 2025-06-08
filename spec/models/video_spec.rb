require "rails_helper"

describe Video do
  let(:video) { FactoryGirl.create(:video) }

  it "#factory_create_success" do
    expect {
      FactoryGirl.create :video
    }.to change { Video.count }.by(1)
  end

  it "should belong to user" do
    expect(video.user).to be_present
  end

  it "should have keywords association" do
    keyword = FactoryGirl.create(:keyword)
    video.keywords << keyword
    expect(video.keywords).to include(keyword)
  end

  it "should order by created_at desc" do
    video1 = FactoryGirl.create(:video, created_at: 2.days.ago)
    video2 = FactoryGirl.create(:video, created_at: 1.day.ago)
    expect(Video.all).to eq([video2, video1])
  end

  it "published scope should work" do
    published_video = FactoryGirl.create(:video, published: true)
    unpublished_video = FactoryGirl.create(:video, published: false)
    expect(Video.published).to include(published_video)
    expect(Video.published).not_to include(unpublished_video)
  end
end