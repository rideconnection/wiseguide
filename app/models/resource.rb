class Resource < ActiveRecord::Base
  validates_presence_of :name

  HUMAN_ATTRIBUTE_NAMES = {
    :address => "Street address",
    :url => "URL",
  }
  
  scope :active, where(:active => true)

  def self.human_attribute_name(attr, options={})
    HUMAN_ATTRIBUTE_NAMES[attr.to_sym] || super
  end
end
