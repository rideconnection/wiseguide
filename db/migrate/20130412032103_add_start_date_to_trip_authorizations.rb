class AddStartDateToTripAuthorizations < ActiveRecord::Migration
  def change
    add_column :trip_authorizations, :start_date, :date
  end
end
