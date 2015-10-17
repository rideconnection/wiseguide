class AddSpecialInstructionsToTripAuthorizations < ActiveRecord::Migration
  def change
    add_column :trip_authorizations, :special_instructions, :text
  end
end
