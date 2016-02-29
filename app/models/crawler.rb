# MechanizeによるScapingを扱う
# 最低限 get の後は sleep を 0.5秒 して負荷をかけ過ぎないように
class Crawler
  QIITA_DOMAIN = 'https://qiita.com'
  USER_LIST_PAGE = QIITA_DOMAIN + '/users'

  def initialize
    @agent = Mechanize.new
  end

  def register_all_users
    (1..100000).each do |i|
      names = get_user_names_in_page(i)
      if names.size > 0
        register_new_users(names)
      else
        break
      end
    end
  end

  def get_user_names_in_page(page)
    url = USER_LIST_PAGE + "?page=#{page}"
    page = @agent.get(url)
    sleep 0.5
    page.css(".list-unstyled > li > a").map{|a| a.inner_html}
  end

  def register_new_users(names)
    names.each do |name|
      QiitaUser.find_or_create_by(name: name)
    end
  end

  def update_data(qiita_user)
    url = USER_LIST_PAGE + "/#{qiita_user.name}"
    page = @agent.get(url)
    sleep 0.5
    elements =  page.css(".userActivityChart_statCount")
    if elements.count != 3
      return
    end
    qiita_user.contributions = page.css(".userActivityChart_statCount")[0].inner_html.to_i
    qiita_user.followers = page.css(".userActivityChart_statCount")[1].inner_html.to_i
    qiita_user.items = page.css(".userActivityChart_statCount")[2].inner_html.to_i
    qiita_user.save!
  end

end
