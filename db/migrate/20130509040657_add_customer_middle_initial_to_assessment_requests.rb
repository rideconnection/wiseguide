class AddCustomerMiddleInitialToAssessmentRequests < ActiveRecord::Migration
  def change
    add_column :assessment_requests, :customer_middle_initial, :string
  end
end
