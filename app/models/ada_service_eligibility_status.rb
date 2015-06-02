class AdaServiceEligibilityStatus < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  
  has_paper_trail

  validates_presence_of :name
end
