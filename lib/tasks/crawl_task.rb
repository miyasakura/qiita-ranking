class Tasks::CrawlTask
  def self.execute
    crawler = Crawler.new

    # 全登録
    crawler.register_all_users

    # データのアップデート
    QiitaUser.find_each do |qiita_user|
      crawler.update_data qiita_user
    end

    # ランキング計算
    ContributionRanking.update_all
  end
end
