class CreateReferralDocumentResources < ActiveRecord::Migration
  def self.up
    create_table :referral_document_resources do |t|
      t.integer :resource_id
      t.text :note
      t.integer :created_by_id
      t.integer :updated_by_id

      t.timestamps
    end
    
    add_index :referral_document_resources, :resource_id
  end

  def self.down
    remove_index :referral_document_resources, :resource_id
    drop_table :referral_document_resources
  end
end
