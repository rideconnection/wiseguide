class AddHouseholdStatsToKases < ActiveRecord::Migration
  def self.up
    add_column :kases, :household_size, :integer
    add_column :kases, :household_size_declined, :boolean
    add_column :kases, :household_income, :integer
    add_column :kases, :household_income_declined, :boolean
  end

  def self.down
    remove_column :kases, :household_income_declined
    remove_column :kases, :household_income
    remove_column :kases, :household_size_declined
    remove_column :kases, :household_size
  end
end