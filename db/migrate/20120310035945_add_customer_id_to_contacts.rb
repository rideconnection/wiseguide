class AddCustomerIdToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :customer_id, :integer
    add_index :contacts, :customer_id
    add_index :contacts, :kase_id
    
    Contact.all.each do |contact|
      contact.customer_id = contact.kase.customer.id
      contact.save!
    end
  end

  def self.down
    remove_index :contacts, :kase_id
    remove_index :contacts, :customer_id
    remove_column :contacts, :customer_id
  end
end