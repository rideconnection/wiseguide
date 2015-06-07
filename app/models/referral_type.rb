class ReferralType < ActiveRecord::Base
  has_paper_trail
  
  scope :for_kase, ( lambda do |kase| 
    if kase.is_a?(CoachingKase)
      where("name LIKE 'CC%'")
    elsif kase.is_a?(TrainingKase)
      where("name LIKE 'TC%'")
    end
  end )

  validates_format_of :name, 
    :with => /\A(CC|TC).*\Z/, 
    :message => 'must begin with either "CC" or "TC"'
end
