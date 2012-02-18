class CreateReferralDocuments < ActiveRecord::Migration
  def self.up
    create_table :referral_documents do |t|
      t.integer :created_by_id
      t.integer :updated_by_id
      t.datetime :last_printed_at

      t.timestamps
    end
  end

  def self.down
    drop_table :referral_documents
  end
end
