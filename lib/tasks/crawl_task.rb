class Tasks::CrawlTask
  def self.execute
    crawler = Crawler.new

    # 全登録
    puts "register_all_users"
    crawler.register_all_users

    # データのアップデート
    puts "update_data"
    QiitaUser.where(contributions: nil, error: false).find_each do |qiita_user|
      puts "update_data #{qiita_user.name} #{qiita_user.contributions}"
      crawler.update_data qiita_user
    end

    # ランキング計算
    puts "ranking: update all"
    ContributionRanking.update_all
  end
end

