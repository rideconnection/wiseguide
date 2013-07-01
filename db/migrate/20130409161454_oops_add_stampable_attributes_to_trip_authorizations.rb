class OopsAddStampableAttributesToTripAuthorizations < ActiveRecord::Migration
  def up
    change_table :trip_authorizations do |t|
      t.integer :created_by_id
      t.integer :updated_by_id
      t.remove  :user_id
    end
  end

  def down
    change_table :trip_authorizations do |t|
      t.remove :created_by_id
      t.remove :updated_by_id
      t.references :user
    end
    add_index :trip_authorizations, :user_id
  end
end
