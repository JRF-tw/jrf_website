# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'open-uri'

def get_img_url_from_html(html)
  doc = Nokogiri::HTML(html)
  img_url = nil
  og_img = doc.css("meta[property='og:image']").first
  if og_img
    img_url = og_img.attributes["content"]
  end
  if img_url.blank?
    img = doc.xpath("//img[@src[contains(.,'://') and not(contains(.,'ads.') or contains(.,'ad.') or contains(.,'?'))]][1]")
    if img.any?
      img_url = img.first.attr('src')
    end
  end
  img_url = nil if img_url.blank?
  return img_url
end

include ActionView::Helpers

Catalog.delete_all
Category.delete_all
Keyword.delete_all
Article.delete_all
Faq.delete_all
ApplicationRecord.connection.execute("Delete from articles_keywords;");

ApplicationRecord.connection.tables.each do |t|
  ApplicationRecord.connection.reset_pk_sequence!(t)
end


# kinds = [
#   {
#     name: '新聞稿',
#     en_name: 'news'
#   }, {
#     name: '活動',
#     en_name: 'active'
#   }, {
#     name: '評論',
#     en_name: 'article'
#   }
# ]

# kinds.each do |k|
#   kind = Kind.new
#   kind.name = k[:name]
#   kind.en_name = k[:en_name]
#   kind.title = k[:title] if k[:title]
#   kind.description = k[:description] if k[:description]
#   kind.image = File.open(Rails.root.join('db', 'data', 'images', 'keywords', k[:image])) if k[:image]
#   kind.cover = File.open(Rails.root.join('db', 'data', 'images', 'keywords', k[:cover])) if k[:cover]
#   kind.showed = true if k[:showed]
#   kind.save
# end

catalogs = [
  {
    id: 1,
    name: '建立信賴的司法',
    image: 'trust.jpg',
    categories: [
      {
        name: '司法改革藍圖',
        keywords: [
          {
            name: '司法憲政改革'
          }, {
            name: '全國司法改革會議'
          }, {
            name: '第一代司法改革藍圖'
          }, {
            name: '第二代司法改革藍圖'
          }
        ]
      }, {
        name: '司法民主化',
        keywords: [
          {
            name: '人民參與審判',
            title: '人民參與審判：不只讓你看，更讓你判！',
            description: '人民參與審判制度，根據人民介入的力道深淺，可概分為英美實施的陪審制、德日實施的參審制。目前台灣司法院想推動的叫觀審制，有一點點綜合的味道，但人民的介入程度，卻都是最淺的。',
            image: 'jury-image.jpg',
            cover: 'jury-cover.jpg',
            showed: true
          }
        ]
      }, {
        name: '司法品質監督',
        keywords: [
          {
            name: '違憲審查制度改革'
          }, {
            name: '最高法院法庭觀察'
          }, {
            name: '鑑定制度改革'
          }, {
            name: '《訴訟影音資料法》增訂'
          }, {
            name: '監聽制度改革'
          }, {
            name: '落實偵查不公開'
          }, {
            name: '律師制度改革'
          }, {
            name: '其他法案推動'
          }
        ]
      }
    ]
  }, {
    id: 2,
    name: '監督法官檢察官',
    image: 'supervise.jpg',
    categories: [
      {
        name: '檢舉不適任法官檢察官',
        keywords: [
          {
            name: '申訴中心'
          }, {
            name: '法官檢察官監督網'
          }
        ]
      }, {
        name: '法官制度改革',
        keywords: [
          {
            name: '法官制度改革介紹'
          }, {
            name: '法官制度改革法案'
          }, {
            name: '法官個案評鑑'
          }
        ]
      }, {
        name: '檢察官制度改革',
        keywords: [
          {
            name: '檢察官個案評鑑'
          }, {
            name: '檢察官制度相關法案'
          }
        ]
      }
    ]
  }, {
    id: 3,
    name: '冤案救援',
    image: 'rescue.jpg',
    categories: [
      {
        name: '救援個案',
        keywords: [
          {
            name: '冤案申訴'
          }, {
            name: '徐自強案'
          }, {
            name: '邱和順案'
          }, {
            name: '江國慶案'
          }, {
            name: '蘇建和案'
          }, {
            name: '蔡學良案'
          }, {
            name: '梅福安案'
          }
        ]
      }, {
        name: '釋憲小組',
        keywords: []
      }
    ]
  }, {
    id: 4,
    name: '實現社會正義',
    image: 'justice.jpg',
    categories: [
      {
        name: '控訴國家暴力',
        keywords: [
          {
            name: '反黑箱服貿案',
            showed: true,
            image: '318-image.jpg',
            cover: '318-cover.jpg'
          }, {
            name: '反核四案'
          }, {
            name: '烏來案'
          }, {
            name: '華光社區案'
          }, {
            name: '陳雲林案'
          }
        ]
      }, {
        name: '人頭帳戶案',
        keywords: []
      }, {
        name: '監所制度改革',
        keywords: [
          {
            name: '監獄行刑法'
          }, {
            name: '羈押法'
          }
        ]
      }
    ]
  }, {
    id: 5,
    name: '法治紮根',
    image: 'justice.jpg',
    categories: [
      {
        name: '教育推廣',
        keywords: [
          {
            name: '學生暑期營隊'
          }, {
            name: '鄉民說法'
          }, {
            name: '實習計畫'
          }, {
            name: '校園模擬法庭'
          }
        ]
      }, {
        name: '出版品',
        kinds: [
          {
            name: '電子報',
            en_name: 'epaper'
          }, {
            name: '書籍',
            en_name: 'book'
          }
        ]
      }
    ]
  }
]


# catalogs.each do |c|
#   catalog = Catalog.new
#   catalog.name = c[:name]
#   catalog.id = c[:id]
#   catalog.image = File.open(Rails.root.join('db', 'data', 'images', 'catalogs', c[:image])) if c[:image]
#   catalog.save
#   c[:categories].each do |cc|
#     category = Category.new
#     category.name = cc[:name]
#     category.catalog_id = catalog.id
#     category.save
#     if cc[:keywords] and cc[:keywords].any?
#       cc[:keywords].each do |k|
#         keyword = Keyword.new
#         keyword.name = k[:name]
#         keyword.title = k[:title] if k[:title]
#         keyword.description = k[:description] if k[:description]
#         keyword.image = File.open(Rails.root.join('db', 'data', 'images', 'keywords', k[:image])) if k[:image]
#         keyword.cover = File.open(Rails.root.join('db', 'data', 'images', 'keywords', k[:cover])) if k[:cover]
#         keyword.showed = true if k[:showed]
#         keyword.category_id = category.id
#         keyword.save
#       end
#     end
#   end
# end


articles = [
  {
    id: 1,
    kind: 'system',
    system_type: 'about',
    published: false,
    published_at: Time.now,
    image: 'about.jpg',
    title: '我們對司法有一個夢',
    content: '<blockquote>
          <p>期待有一天<br>
守法的人不孤單，違法的人心有畏懼，每一個人皆能待到心中的正義，</p>
          <p>期待有一天<br>司法能成為我們共同的許諾，許諾一個公平的審判，一個平等的文化，一個體現正義的社會。</p>
          <footer>民間司法改革基金會</footer>
        </blockquote>
        <h2>簡介</h2>
        <p>民間司法改革基金會從1995年11月成立至今20年，因為深愛這塊土地與人民，我們不僅專注於制度面的法案推動及司法品質個案監督，也致力於從文化及教育面，推廣法律公平的真意。我們深知改革的力量必須由下而上，只有經由民間的推力，才能讓改革的夢想成為真實，最終建立一個人民信賴的司法。</p>
        <h2>緣起</h2>
        <p>基於對這片土地的認同與關懷，期待司法成為正義的捍衛者，民間法改革基金會誕生了。</p>
        <p>一九九四年秋天，一群承襲一九八九年律師文聯團以來的改革派律師，在官方成立司法改革委員會之後，深切體認到司法改革的力量正如同其他任何一種改革一樣，必須是由下而上，勢必要經由民間的推力，才足以使得改革的夢想成為真實。於是，這群懷抱法律是實現正義理想的律師們立即成軍，正式集結為民間司法改革基金會的前身。</p>
        <p>一九九五年十一月，民間司法改革基金會籌備處正式成立，在一九九七年五月初正式完成財團法人登記的兩年間，參與成員有錢出錢有力出力，辦公室寄住在律師們的事務所中，以節省包括水電、影印、紙張等等所有日常性開銷，所有參與者不論大小事一律包辦，大家全力衝刺，一切都只為了成立一個以司法改革為宗旨的長期性團體。兩年後，我們不但募足了成立財團法人必需的一千萬基金，更重要的，我們凝聚了一批對司法改革有熱誠的各界同志，包括了律師、學界、民意代表，結合了行動與知識，終於邁開司法改革的步伐。</p>
        <p>我們的工作分為立法研究、監督評鑑、教育推廣、個案追蹤四大類，其下分別設置數個工作小組，以不同的面向及角度，同時邁向一致的目標　司法改革。我們深信，司法改革的工作必須是全民的、行動的、持續的，有一天才能建立一個值得人民信賴的司法，才能達到司法能夠實現正義的理想，因此，在我們正式成立後的今天，向對這片土地還有愛的您發出邀請，期待您加入我們的行列！</p>
        <h2>組織成員</h2>
        <table class="table table-striped">
        <thead>
        <tr>
        <th>職稱</th>
        <th>成員姓名</th>
        </tr>
        </thead>
        <tbody>
        <tr>
        <td>董事長</td>
        <td>林永頌</td>
        </tr>
        <tr>
        <td>常務董事</td>
        <td>林永頌、黃旭田、瞿海源、羅秉成、顧立雄</td>
        </tr>
        <tr>
        <td>董事</td>
        <td>尤伯祥、朱麗容、李念祖、李茂生 林志剛、陳玲玉、陳傳岳、黃瑞明、詹森林、潘維大、<br>
劉志鵬、顏厥安</td>
        </tr>
        <tr>
        <td>監察人</td>
        <td>林佳範、林峯正、吳志光、高涌誠、謝銘洋</td>
        </tr>
        <tr>
        <td>執行委員</td>
        <td>尤伯祥、王龍寬、李艾倫、李榮耕、周宇修、林永頌、林俊宏、林峯正、林裕順、徐偉群、<br>
高涌誠、張喬婷、陳惠敏、陳傳岳、黃旭田、黃國昌、黃瑞明、鄭文龍、鄭凱鴻、瞿海源、<br>
羅士翔、羅秉成、顅立雄</td>
        </tr>
        <tr>
        <td>諮詢委員</td>
        <td>吳志光、李岳霖、林佳範、林孟皇、洪鼎堯、馬在勤、張世興、黃虹霞、黃達元、楊芳婉、<br>
葉建廷、詹順貴、劉志鵬、錢建榮</td>
        </tr>
        <tr>
        <td>工作委員</td>
        <td>
        王智昱、白禮維、朱琬琳、江榮祥、吳佾宸、吳怡德、吳欣陽、吳景欽、宋一心、李亦庭、<br>
        李典穎、李宣毅、李晏榕、李聖鐸、沈元楷、沈巧元、周漢威、林廷翰、林明賢、林昶燁、<br>
        林楊鎰、林鴻文、邱顯智、侯慶辰、施泓成、段可芳、洪旻郁、范志誠、倪映驊、唐玉盈、<br>
        孫　斌、徐崧博、涂偉俊、張　靜、張世潔、張宸浩、張靜如、梁家贏、莊植焜、許仁豪、<br>
        郭怡青、陳怡君、陳承勤、陳建宏、陳為祥、陳重安、陳紹倫、陳學驊、曾威凱、曾昭牟、<br>
        馮俊堯、黃仕翰、黃威如、黃致豪、黃朗倩、黃耀正、楊時綱、楊淑玲、詹義豪、趙乃怡、<br>
        趙書郁、劉有志、劉志賢、劉佩瑋、劉冠廷、劉家榮、劉硯田、劉懿嫻、蔡欣渝、蔡桓文、<br>
        蔡晴羽、繆籃蘋、謝良駿、謝佳穎、顏　榕、魏潮宗、羅承宗、嚴心吟、蘇孝倫、蔡旻穎、<br>
        顏華歆</td>
        </tr>
        <tr>
        <td>執行長</td>
        <td>高榮志</td>
        </tr>
        <tr>
        <td>副執行長</td>
        <td>陳雨凡</td>
        </tr>
        <tr>
        <td>秘書處</td>
        <td>執行祕書11名</td>
        </tr>
        </tbody>
        </table>'
  }, {
    id: 2,
    kind: 'system',
    system_type: 'donate',
    published: false,
    published_at: Time.now,
    image: 'donate.jpg',
    title: '每一個 你，都是點亮司法黑暗的一盞燭光',
    content: '<div class="alert alert-info" role="alert">
  <p style="font-size:15px">親愛的朋友，感謝你的慷慨捐款，讓我們有更多的力量投入於監督法官、檢察官，為弱勢民眾提供司法人權的保障。</p>
  <ul style="font-size:15px">
    <li><a href="https://jrf.neticrm.tw/civicrm/contribute/transact?reset=1&id=11" target="_blank">小額定期捐款</a></li>
    <li><a href="https://jrf.neticrm.tw/civicrm/contribute/transact?reset=1&id=12" target="_blank">單筆捐款</a></li>
    <li>下載捐款單，填寫後回傳：<a href="http://www.jrf.org.tw/newjrf/attach01/2014_donation.doc" target="_blank">DOC</a>│<a href="http://www.jrf.org.tw/newjrf/attach01/2014_donation.pdf" target="_blank">PDF</a></li>
  </ul>
</div>
<P>親愛的朋友：</P>
<P>很多朋友問，為何從事司法改革工作？這個問題難，也不難。</P>
<p>不難，因為這是很有意義的一份工作。或許政治變革更根本，或許經濟革新應優先。但不能否認的是，司法改革很重要。在台灣，對司法的控訴，不曾停止，被咬一口：輕則斷送大好前程，重則抑鬱而終。而最令人難以接受的是這竟是21世紀的司法。台灣值得更好的。</p>
<p>而這個問題也難，難在千絲萬縷，不知從何下手。幸而19年來的摸索，我們理出了一些頭緒和脈絡：</p>
<ul class="nav nav-tabs" role="tablist">
  <li class="active col-md-2">
    <a href="#htab1" role="tab" data-toggle="tab"><img width="100%" src="http://www.jrf.org.tw/newjrf/img/2014-d-1.png">
      <h4 class="text-center">個案救援</h4>
    </a>
  </li>
  <li class="col-md-2">
    <a href="#htab2" role="tab" data-toggle="tab"><img width="100%" src="http://www.jrf.org.tw/newjrf/img/2014-d-2.png">
      <h4 class="text-center">律師平台</h4>
    </a>
  </li>
  <li class="col-md-2">
    <a href="#htab3" role="tab" data-toggle="tab"><img width="100%" src="http://www.jrf.org.tw/newjrf/img/2014-d-3.png">
      <h4 class="text-center">數位出版</h4>
    </a>
  </li>
  <li class="col-md-2">
    <a href="#htab4" role="tab" data-toggle="tab"><img width="100%" src="http://www.jrf.org.tw/newjrf/img/2014-d-4.png">
      <h4 class="text-center">志工發展</h4>
    </a>
  </li>
  <li class="col-md-2">
    <a href="#htab5" role="tab" data-toggle="tab"><img width="100%" src="http://www.jrf.org.tw/newjrf/img/2014-d-5.png">
      <h4 class="text-center">法案工作</h4>
    </a>
  </li>
</ul>
<!-- Tab panes -->
<div class="tab-content col-md-10 row">
  <div class="tab-pane fade in active" id="htab1">
    <h1 class="text-center">冤案救援，申訴法官、檢察官</h1>
    <div class="space-bottom"></div>
    <div class="row">
      <p>司法裡受委曲的何其多，一輩子奉公守法，也難保永遠不會遇上冤屈。就算無罪，纏訟數年，早已賠上一生。申訴，可以追究責任、帶來壓力、形成改變。不幸冤案，介入救援，更是直接的幫忙。</p>
    </div>
  </div>
  <div class="tab-pane fade" id="htab2">
    <h1 class="text-center">法案工作</h1>
    <div class="space-bottom"></div>
    <div class="row">
      <p>人權法案的變革，深深影響社會的進步，我們推動、監督、把關。例如，催生《法律扶助法》，降低受法律保護的門檻。通過《法官法》，讓不適任的法官、檢察官，可以逐漸被淘汰。</p>
    </div>
  </div>
  <div class="tab-pane fade" id="htab3">
    <h1 class="text-center">志工發展</h1>
    <div class="space-bottom"></div>
    <div class="row">
      <p>我們的經費有限，但是活力無窮，所依靠的，就是一群無怨無悔、盡心盡力投入付出的志工。他們是學生、律師、各方的專業人士，是司改會的發電機。沒有志工，就沒有司改會！</p>
    </div>
  </div>
  <div class="tab-pane fade" id="htab4">
    <h1 class="text-center">義務律師平台</h1>
    <div class="space-bottom"></div>
    <div class="row">
      <p>司改會的最大特色，是幾百名支持我們的義務律師，不管是協助活動，或是義務辯護。在追尋正義的道路上，這群律師，永遠是全民最強大的後盾！</p>
    </div>
  </div>
  <div class="tab-pane fade" id="htab5">
    <h1 class="text-center">數位化與出版串連</h1>
    <div class="space-bottom"></div>
    <div class="row">
      <p>網路時代來臨，資訊數位化與多元的社群連繫，早已成為組織不可或缺的一環。由網路串連的社會運動，在世界各地掀起波波變革，格外值得注目！</p>
    </div>
  </div>
</div>
<!-- tabs end -->
<div class="row section">
  <p>司法改革的工作雖然繁重，卻是我們最甜蜜的負荷。在司法改革的這條路上，我們非常需要您的支持，懇請慷慨捐助司改會！或許，我們無法確保一切改革盡如人意；但是，我們能拍胸脯保證，每一分您的捐輸，都是花在刀口上，並發揮他最大的效用！謝謝您！</p>
  <p>　　　　敬祝　平安、順心</p>
  <p align="right">財團法人民間司法改革基金會
    <br /> 董事長
    <img src="http://www.jrf.org.tw/newjrf/img/20140905-3.png" width="150" />
    <br /> 執行長
    <img src="http://www.jrf.org.tw/newjrf/img/20140905-4.png" width="150" />
    <br /> 暨秘書處全體同仁 敬上 </p>
</div>
<!-- 若有FAQ，以下放ＦＡＱ,則此處內文結束；若無下方註解處才結束內文 -->
<h2>捐款FAQ</h2>
<!-- FAQ start -->
<div class="panel-group" id="accordion-faq">
  <div class="panel panel-default">
    <div class="panel-heading">
      <h4 class="panel-title"> <a data-toggle="collapse" data-parent="#accordion-faq" href="#collapseOne" class="collapsed"> <i class="fa fa-question-circle pr-10"></i> 我的捐款，在個人報稅時，可以申報列舉抵免嗎？</a> </h4>
    </div>
    <div id="collapseOne" class="panel-collapse collapse">
      <div class="panel-body">
        <p>可以。捐款給本會，您可以拿到正式捐款收據和捐款證明。在申報個人所得稅的時候，只要您選擇「列舉」方式，這份捐款收據和捐款證明可以列入申報扣除額。捐款收據和捐款證明都可以做為納稅抵免的證明，納稅時請擇一使用。</p>
      </div>
    </div>
  </div>
  <div class="panel panel-default">
    <div class="panel-heading">
      <h4 class="panel-title"> <a data-toggle="collapse" data-parent="#accordion-faq" href="#collapseTwo" class="collapsed"> <i class="fa fa-question-circle pr-10"></i> 請問捐款後，何時會收到捐款收據和捐款證明？</a> </h4>
    </div>
    <div id="collapseTwo" class="panel-collapse collapse">
      <div class="panel-body">
        <ol>
          <li>如果您是單筆捐款，我們會在​捐款後​一個月內寄出捐款收據給您。</li>
          <li>如果您是定期捐款，為了節省作業程序，您不會收到每個月的捐款收據。我們都會在隔年​​​年初，寄出一整年的捐款證明給您。</li>
        </ol>
      </div>
    </div>
  </div>
  <div class="panel panel-default">
    <div class="panel-heading">
      <h4 class="panel-title"> <a data-toggle="collapse" data-parent="#accordion-faq" href="#collapseFour" class="collapsed"> <i class="fa fa-question-circle pr-10"></i> 請問司改會會將捐贈資料上傳至「扣除額單位電子資料交換系統」嗎？</a> </h4>
    </div>
    <div id="collapseFour" class="panel-collapse collapse">
      <div class="panel-body">
        <p>本會與北區國稅局連繫了解需要上傳的內容後，考量每位捐款人的狀況與想法不同​，不宜直接將捐款人的個人資料上傳​至國稅局，所以請捐款人報稅時自行列舉。</p>
      </div>
    </div>
  </div>
  <div class="panel panel-default">
    <div class="panel-heading">
      <h4 class="panel-title"> <a data-toggle="collapse" data-parent="#accordion-faq" href="#collapseFive" class="collapsed"> <i class="fa fa-question-circle pr-10"></i> 除了網路線上捐款，有沒有紙本捐款單可以下載？</a> </h4>
    </div>
    <div id="collapseFive" class="panel-collapse collapse">
      <div class="panel-body">
        <p>​請點選連結，下載紙本捐款單。（<a href="http://www.jrf.org.tw/newjrf/attach01/2014_donation.doc" target="_blank">DOC</a>│<a href="http://www.jrf.org.tw/newjrf/attach01/2014_donation.pdf" target="_blank">PDF</a>）</p>
      </div>
    </div>
  </div>
  <div class="panel panel-default">
    <div class="panel-heading">
      <h4 class="panel-title"> <a data-toggle="collapse" data-parent="#accordion-faq" href="#collapseSix" class="collapsed"> <i class="fa fa-question-circle pr-10"></i> 我可以使用轉帳方式捐款嗎？流程為何？</a> </h4>
    </div>
    <div id="collapseSix" class="panel-collapse collapse">
      <div class="panel-body">
        <p>有下列兩種轉帳方式：</p>
        <ol>
          <li>郵局郵政劃撥
            <div class="bg-danger">帳號：19042635
              <br> 戶名：財團法人民間司法改革基金會
            </div>
          </li>
          <li>銀行匯款／ATM轉帳
            <div class="bg-danger"> 銀行名稱：聯邦銀行（南京東路分行，代號：803）
              <br> 帳號：005108000055
              <br> 戶名：財團法人民間司法改革基金會 </div>
          </li>
        </ol>
      </div>
    </div>
  </div>
</div>'
  }
]

articles.each do |a|
  article = Article.new(a)
  article.id = a[:id]
  File.open(Rails.root.join('db', 'fixtures', a[:image])) do |f|
    article.image = f
  end
  article.save
end

ApplicationRecord.connection.tables.each do |t|
  ApplicationRecord.connection.reset_pk_sequence!(t)
end