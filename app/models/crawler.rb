# MechanizeによるScapingを扱う
# 最低限 get の後は sleep を 0.5秒 して負荷をかけ過ぎないように
class Crawler
  QIITA_DOMAIN = 'https://qiita.com'
  USER_LIST_PAGE = QIITA_DOMAIN + '/users'
  ERROR_TEMPORARY = 1
  ERROR_PERMANENTLY = 2

  def initialize
    @agent = Mechanize.new
  end

  def register_all_users
    page_from = 1
    page_to = Rails.env.development? ? 10 : 100000
    (page_from..page_to).each do |page|
      names = get_user_names_in_page(page)
      if names.count == QiitaUser.where(name: names).count
        break
      end

      register_new_users(names)
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
    data = _get_user_data(qiita_user.name)
    if data[:error]
      if data[:error] == ERROR_PERMANENTLY
        qiita_user.error = true
        qiita_user.save!
      end

      return
    end

    qiita_user.contributions = data[:contributions]
    qiita_user.followers = data[:followers]
    qiita_user.items = data[:items]
    qiita_user.save!
  end

  def register_if_valid_user(name)
    data = _get_user_data(name)
    unless data
      return
    end

    qiita_user = QiitaUser.find_or_create_by(name: name)
    qiita_user.contributions = data[:contributions]
    qiita_user.followers = data[:followers]
    qiita_user.items = data[:items]
    qiita_user.save!

    return qiita_user
  end

  def _get_user_data(name)
    url = USER_LIST_PAGE + "/#{name}"
    page = @agent.get(url)
    sleep 0.5
    elements =  page.css(".userActivityChart_statCount")
    if elements.count != 3
      puts "elements not found"
      return { :error => ERROR_PERMANENTLY }
    end

    return {
        contributions: page.css(".userActivityChart_statCount")[0].inner_html.to_i,
        followers: page.css(".userActivityChart_statCount")[1].inner_html.to_i,
        items: page.css(".userActivityChart_statCount")[2].inner_html.to_i,
    }

  rescue Mechanize::RedirectLimitReachedError => e
    puts e.message
    return { :error => ERROR_PERMANENTLY }

  rescue Mechanize::ResponseCodeError => e
    puts e.message
    if e.response_code == 404
      return { :error => ERROR_PERMANENTLY }
    else
      return { :error => ERROR_TEMPORARY }
    end
  end

end
