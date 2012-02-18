class ReferralDocumentResource < ActiveRecord::Base
  attr_protected :last_printed_at
  
  stampable :creator_attribute => :created_by_id, :updater_attribute => :updated_by_id
  belongs_to :created_by, :foreign_key => :created_by_id, :class_name=>'User'
  belongs_to :updated_by, :foreign_key => :updated_by_id, :class_name=>'User'

  belongs_to :referral_document
  belongs_to :resource
  
  validates_presence_of :resource
  validates_associated :resource
end
