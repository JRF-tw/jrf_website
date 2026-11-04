require 'rails_helper'

describe "英文版網址" do
  it "jrf.org.tw/en 301 導到 www.jrf.org.tw/en" do
    host! "jrf.org.tw"
    get "/en"
    expect(response).to have_http_status(:moved_permanently)
    expect(response.location).to eq("https://www.jrf.org.tw/en")
  end

  it "jrf.org.tw/en 底下的路徑一起帶過去" do
    host! "jrf.org.tw"
    get "/en/about/history.html"
    expect(response.location).to eq("https://www.jrf.org.tw/en/about/history.html")
  end

  it "www.jrf.org.tw/en 不會被導走" do
    host! "www.jrf.org.tw"
    expect { get "/en" }.to raise_error(ActionController::RoutingError)
  end
end
