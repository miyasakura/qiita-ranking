class CreateQiitaUsers < ActiveRecord::Migration
  def change
    create_table :qiita_users do |t|
      t.string :name, null: false
      t.integer :followers, null: false
      t.integer :follows, null: false
      t.integer :items, null: false
      t.integer :followings, null: false
      t.integer :contributions, null: false
      t.integer :contribution_rank, null: false

      t.timestamps null: false
    end

    add_index :qiita_users, :name, :unique => true
    add_index :qiita_users, :contribution_rank, :unique => false
  end
end
