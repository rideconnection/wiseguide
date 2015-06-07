
class Resource < ActiveRecord::Base
  has_many :referral_document_resources
  has_many :referral_documents, :through => :referral_document_resources
  
  validates_presence_of :name

  HUMAN_ATTRIBUTE_NAMES = {
    :address => "Street address",
    :url => "URL",
  }
  
  scope :active, -> { where(:active => true) }

  def self.human_attribute_name(attr, options={})
    HUMAN_ATTRIBUTE_NAMES[attr.to_sym] || super
  end
end
