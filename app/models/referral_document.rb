class ReferralDocument < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  has_paper_trail
  
  belongs_to :kase
  has_many :referral_document_resources
  has_many :resources, :through => :referral_document_resources
  
  accepts_nested_attributes_for :referral_document_resources, :allow_destroy => true, :reject_if => lambda { |a| a[:resource_id].blank? }
  
  validates_associated :referral_document_resources
  
  validate do |document|
    document.errors[:base] << "Referral document must have at least one resource" if document.referral_document_resources.blank?
  end
  
  def customer
    return kase.customer
  end
end
