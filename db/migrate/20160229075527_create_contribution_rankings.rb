class CreateContributionRankings < ActiveRecord::Migration
  def change
    create_table :contribution_rankings do |t|
      t.integer :contribution_ranking_version_id
      t.integer :qiita_user_id
      t.string :name
      t.integer :contributions
      t.integer :rank

      t.timestamps null: false
    end

    add_index :contribution_rankings, [:rank, :contribution_ranking_version_id], :name => :rank_version_index
    add_index :contribution_rankings, [:name, :contribution_ranking_version_id], :name => :name_version_index
  end
end
