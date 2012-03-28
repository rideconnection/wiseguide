class AddDemographicFieldsToCustomers < ActiveRecord::Migration
  def self.up
    add_column :customers, :veteran_status, :boolean
    add_column :customers, :spouse_of_veteran_status, :boolean
    add_column :customers, :honored_citizen_cardholder, :boolean
    add_column :customers, :primary_language, :string
    add_column :customers, :ada_service_eligibility_status_id, :integer
  end

  def self.down
    remove_column :customers, :ada_service_eligibility_status_id
    remove_column :customers, :primary_language
    remove_column :customers, :honored_citizen_cardholder
    remove_column :customers, :spouse_of_veteran_status
    remove_column :customers, :veteran_status
  end
end