class ConvertContactAssociations < ActiveRecord::Migration
  def up
    add_column :contacts, :contactable_type, :string
    add_column :contacts, :contactable_id, :integer
    add_index  :contacts, [:contactable_type, :contactable_id]
    
    # Convert existing contacts
    Contact.all.each do |contact|
      if !contact.kase_id.blank?
        contact.contactable_type = "Kase"
        contact.contactable_id   = contact.kase_id
      else
        contact.contactable_type = "Customer"
        contact.contactable_id   = contact.customer_id
      end
      contact.save(:validate => false)
    end
    
    remove_column :contacts, :kase_id
    remove_column :contacts, :customer_id
  end

  def down
    add_column :contacts, :kase_id, :integer
    add_column :contacts, :customer_id, :integer
    
    # Convert existing contacts
    Contact.all.each do |contact|
      if contact.contactable_type == "Kase"
        contact.kase_id     = contact.contactable_id
        kase = Kase.find_by_id(contact.contactable_id)
        contact.customer_id = kase.blank? ? 0 : kase.customer.id
      else
        # Note this will catch any newly created AR-type contacts, too.
        contact.customer_id = contact.contactable_id
      end
      contact.save(:validate => false)
    end
    
    remove_column :contacts, :contactable_type
    remove_column :contacts, :contactable_id
    # remove_index  :contacts, [:contactable_type, :contactable_id]
  end
end
