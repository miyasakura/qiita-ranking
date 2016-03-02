class AddColumnErrorToQiitaUser < ActiveRecord::Migration
  def change
    add_column :qiita_users, :error, :bool, default: false
  end
end
