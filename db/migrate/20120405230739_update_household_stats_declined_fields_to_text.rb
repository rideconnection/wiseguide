class UpdateHouseholdStatsDeclinedFieldsToText < ActiveRecord::Migration
  def self.up
    add_column :kases, :household_size_alternate_response, :string
    add_column :kases, :household_income_alternate_response, :string
    Kase.where(:household_size_declined => true).update_all(:household_size_alternate_response => "Refused")
    Kase.where(:household_income_declined => true).update_all(:household_income_alternate_response => "Refused")
    remove_column :kases, :household_size_declined
    remove_column :kases, :household_income_declined
  end

  def self.down
    add_column :kases, :household_income_declined, :boolean
    add_column :kases, :household_size_declined, :boolean
    Kase.where(:household_income_alternate_response => "Refused").update_all(:household_income_declined => true)
    Kase.where(:household_size_alternate_response => "Refused").update_all(:household_size_declined => true)
    remove_column :kases, :household_income_alternate_response
    remove_column :kases, :household_size_alternate_response
  end
end
