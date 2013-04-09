class AddCoachingKaseIdToTripAuthorizations < ActiveRecord::Migration
  def change
    add_column :trip_authorizations, :coaching_kase_id, :integer
    add_index :trip_authorizations, :coaching_kase_id
  end
end
