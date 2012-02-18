class AddKaseIdToReferralDocuments < ActiveRecord::Migration
  def self.up
    add_column :referral_documents, :kase_id, :integer
    add_index :referral_documents, :kase_id
  end

  def self.down
    remove_index :referral_documents, :kase_id
    remove_column :referral_documents, :kase_id
  end
end