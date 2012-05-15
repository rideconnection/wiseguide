class AddMiddleInitialToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :middle_initial, :string, :limit => 1
  end
end