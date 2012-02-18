class AddReferralDocumentIdToReferralDocumentResources < ActiveRecord::Migration
  def self.up
    add_column :referral_document_resources, :referral_document_id, :integer
    add_index :referral_document_resources, :referral_document_id
    remove_index :referral_document_resources, :resource_id
    add_index :referral_document_resources, [:referral_document_id, :resource_id], :unique => true, :name => "idx_referral_document_resources_referral_document_id_resource_id"
  end

  def self.down
    remove_index :referral_document_resources, :column => [:referral_document_id, :resource_id], :name => "idx_referral_document_resources_referral_document_id_resource_id"
    add_index :referral_document_resources, :resource_id
    remove_index :referral_document_resources, :referral_document_id
    remove_column :referral_document_resources, :referral_document_id
  end
end