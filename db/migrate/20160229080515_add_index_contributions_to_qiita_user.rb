class AddIndexContributionsToQiitaUser < ActiveRecord::Migration
  def change
    add_index :qiita_users, :contributions
  end
end
