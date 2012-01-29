class CreateAssessmentRequests < ActiveRecord::Migration
  def self.up
    create_table :assessment_requests do |t|
      t.string :customer_first_name
      t.string :customer_last_name
      t.string :customer_phone
      t.date :customer_birth_date
      t.text :notes
      t.integer :submitter_id

      t.timestamps
    end
  end

  def self.down
    drop_table :assessment_requests
  end
end
