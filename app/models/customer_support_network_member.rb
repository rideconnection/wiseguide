class CustomerSupportNetworkMember < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  has_paper_trail
  
  belongs_to :customer
end
