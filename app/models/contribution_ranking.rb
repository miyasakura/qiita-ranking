class ContributionRanking < ActiveRecord::Base
  def self.update_all
    version = ContributionRankingVersion.order("id desc").first
    version_id = version ? version.id : 1

    current_contribution = -1
    current_rank = 0
    users_in_rank = []

    QiitaUser.order("contributions desc").find_each_with_order do |qiita_user|
      if current_contribution == qiita_user.contributions
        users_in_rank << qiita_user
      else
        register_ranking(version_id, current_rank, users_in_rank)

        current_contribution = qiita_user.contributions
        users_in_rank = [qiita_user]
        current_rank += 1
      end
    end
  end

  def self.register_ranking(version_id, rank, qiita_users)
    return if qiita_users.size == 0

    ranking = []

    qiita_users.each do |qiita_user|
      ranking << new(
          contribution_ranking_version_id: version_id,
          qiita_user_id: qiita_user.id,
          name: qiita_user.name,
          contributions: qiita_user.contributions,
          rank: rank,
      )
    end

    # activerecord-import (bulk insert)
    import ranking

  end

end
