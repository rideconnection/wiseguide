class AddUpdatedAtToCustomerImpairments < ActiveRecord::Migration
  def change
    add_column :customer_impairments, :updated_at, :datetime
  end
end
