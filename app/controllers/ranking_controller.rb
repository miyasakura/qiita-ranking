class RankingController < ApplicationController
  def index
    name = params[:id]

    @qiita_user = QiitaUser.find_by_name(name)

    unless @qiita_user
      @qiita_user = Crawler.new.register_if_valid_user(name)
      unless @qiita_user
        render :file => "ranking/user_not_found"
      end
    end

    @version = ContributionRankingVersion.order("id desc").limit(1).first
    ranking = ContributionRanking.find_by(qiita_user_id: @qiita_user.id, contribution_ranking_version_id: @version.id)
    if ranking
      @rank = ranking.rank
    else
      @rank = ContributionRanking.calculate_ranking(@qiita_user, @version.id)
    end
  end
end
