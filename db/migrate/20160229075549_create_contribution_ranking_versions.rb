class CreateContributionRankingVersions < ActiveRecord::Migration
  def change
    create_table :contribution_ranking_versions do |t|

      t.timestamps null: false
    end
  end
end
