class CreateTripAuthorizations < ActiveRecord::Migration
  def change
    create_table :trip_authorizations do |t|
      t.integer :allowed_trips_per_month
      t.date :end_date
      t.references :user
      t.datetime :disposition_date
      t.references :disposition_user

      t.timestamps
    end
    add_index :trip_authorizations, :user_id
    add_index :trip_authorizations, :disposition_user_id
  end
end
