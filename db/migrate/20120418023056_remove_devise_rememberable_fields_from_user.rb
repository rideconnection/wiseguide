class RemoveDeviseRememberableFieldsFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :remember_token
    remove_column :users, :remember_created_at
  end

  def self.down
    add_column :users, :remember_created_at, :datetime
    add_column :users, :remember_token, :string
  end
end
