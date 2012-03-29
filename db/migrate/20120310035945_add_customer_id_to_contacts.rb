class AddCustomerIdToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :customer_id, :integer
    add_index :contacts, :customer_id
    add_index :contacts, :kase_id
    
    Contact.all.each do |contact|
      if contact.kase.nil?
        puts "Contact #{contact.id} has no valid kase. SKIPPED!"
        next
      end
      contact.customer_id = contact.kase.customer.id
      # Unfortunately this save fails when the customer is invalid
      # (missing birth date, for example), so validation is off.
      contact.save!(:validate => false)
    end
  end

  def self.down
    remove_index :contacts, :kase_id
    remove_index :contacts, :customer_id
    remove_column :contacts, :customer_id
  end
end
