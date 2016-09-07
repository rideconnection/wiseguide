class AddCustomerIdentifierToCustomers < ActiveRecord::Migration
  def change
    change_table :customers do |t|
      t.string :identifier
      t.index  :identifier, unique: true
    end
  end
end
