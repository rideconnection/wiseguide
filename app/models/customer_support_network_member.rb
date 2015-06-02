class CustomerSupportNetworkMember < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :customer
end
