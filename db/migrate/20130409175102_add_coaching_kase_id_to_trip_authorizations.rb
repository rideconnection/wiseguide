class AddCoachingKaseIdToTripAuthorizations < ActiveRecord::Migration
  def change
    add_column :trip_authorizations, :kase_id, :integer
    add_index :trip_authorizations, :kase_id
  end
end
