class AddAssigneeIdToAssessmentRequests < ActiveRecord::Migration
  def change
    add_column :assessment_requests, :assignee_id, :integer
  end
end