class AddIdentifierToAssessmentRequest < ActiveRecord::Migration
  def change
    change_table :assessment_requests do |t|
      t.string :customer_identifier
    end
  end
end
