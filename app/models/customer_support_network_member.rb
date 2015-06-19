class CustomerSupportNetworkMember < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :customer
end
