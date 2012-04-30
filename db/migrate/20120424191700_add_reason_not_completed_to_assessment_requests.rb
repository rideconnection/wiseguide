class AddReasonNotCompletedToAssessmentRequests < ActiveRecord::Migration
  def self.up
    add_column :assessment_requests, :reason_not_completed, :string
  end

  def self.down
    remove_column :assessment_requests, :reason_not_completed
  end
end