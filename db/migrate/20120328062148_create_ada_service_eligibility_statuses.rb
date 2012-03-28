class CreateAdaServiceEligibilityStatuses < ActiveRecord::Migration
  def self.up
    create_table :ada_service_eligibility_statuses do |t|
      t.string :name
      t.integer :created_by_id
      t.integer :updated_by_id

      t.timestamps
    end
  end

  def self.down
    drop_table :ada_service_eligibility_statuses
  end
end
