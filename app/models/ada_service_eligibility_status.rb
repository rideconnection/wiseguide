class AdaServiceEligibilityStatus < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  validates_presence_of :name
end
