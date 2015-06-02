class TripReason < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  has_many :outcomes, :dependent => :restrict
end
