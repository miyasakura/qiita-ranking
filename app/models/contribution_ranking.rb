class ContributionRanking < ActiveRecord::Base
  def self.update_all
    version = ContributionRankingVersion.create!

    current_contribution = -1
    current_rank = 0
    users_in_rank = []

    QiitaUser.order("contributions desc").find_each_with_order do |qiita_user|
      if current_contribution == qiita_user.contributions
        users_in_rank << qiita_user
      else
        register_ranking(version.id, current_rank, users_in_rank)

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
      create!(
          contribution_ranking_version_id: version_id,
          qiita_user_id: qiita_user.id,
          name: qiita_user.name,
          contributions: qiita_user.contributions,
          rank: rank,
      )
    end

  end

  def self.calculate_ranking(qiita_user, version_id)
    # contributionからそれっぽいランキングを出す
    contributions = qiita_user.contributions

    ranking_upper = ContributionRanking.find_by_sql(
        [
            "select * from contribution_rankings where contribution_ranking_version_id = ? and contributions >= ? order by contributions desc limit 1",
            version_id,
            contributions,
        ]
    )

    if ranking_upper.count == 0
      return 1
    elsif ranking_upper.first.contributions == contributions
      return ranking_upper.first.rank
    else
      return ranking_upper.first.rank + 1
    end
  end

end
