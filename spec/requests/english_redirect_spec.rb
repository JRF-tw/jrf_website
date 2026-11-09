require 'rails_helper'

describe "英文版網址" do
  %w[www.jrf.org.tw jrf.org.tw].each do |host|
    it "#{host}/en 301 導到 en.jrf.org.tw/en" do
      host! host
      get "/en"
      expect(response).to have_http_status(:moved_permanently)
      expect(response.location).to eq("https://en.jrf.org.tw/en")
    end
  end

  it "/en 底下的路徑一起帶過去" do
    get "/en/about/history.html"
    expect(response).to have_http_status(:moved_permanently)
    expect(response.location).to eq("https://en.jrf.org.tw/en/about/history.html")
  end
end
