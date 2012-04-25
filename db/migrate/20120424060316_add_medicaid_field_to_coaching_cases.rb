class AddMedicaidFieldToCoachingCases < ActiveRecord::Migration
  def self.up
    add_column :kases, :medicaid_eligible, :boolean
  end

  def self.down
    remove_column :kases, :medicaid_eligible
  end
end