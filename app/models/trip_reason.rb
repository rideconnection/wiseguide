class TripReason < ActiveRecord::Base
  has_paper_trail
  
  has_many :outcomes, :dependent => :restrict_with_exception
end
