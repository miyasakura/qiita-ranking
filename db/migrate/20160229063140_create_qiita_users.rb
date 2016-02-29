class CreateQiitaUsers < ActiveRecord::Migration
  def change
    create_table :qiita_users do |t|
      t.string :name, null: false
      t.integer :followers
      t.integer :items
      t.integer :contributions

      t.timestamps null: false
    end

    add_index :qiita_users, :name, :unique => true
  end
end
