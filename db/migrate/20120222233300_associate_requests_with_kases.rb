class AssociateRequestsWithKases < ActiveRecord::Migration
  def self.up
    add_column :kases, :assessment_request_id, :integer
    add_column :assessment_requests, :kase_id, :integer
    add_column :assessment_requests, :customer_id, :integer
  end

  def self.down
    remove_column :kases, :assessment_request_id
    remove_column :assessment_requests, :kase_id
    remove_column :assessment_requests, :customer_id
  end
end
