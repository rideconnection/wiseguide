class ReferralDocumentResource < ActiveRecord::Base  
  include ActiveModel::ForbiddenAttributesProtection

  has_paper_trail
  
  belongs_to :referral_document
  belongs_to :resource
  
  validates_uniqueness_of :resource_id, :scope => :referral_document_id
  validates_presence_of :resource
  validates_associated :resource
end
