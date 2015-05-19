class ReferralType < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  stampable :creator_attribute => :created_by_id, :updater_attribute => :updated_by_id
  belongs_to :created_by, :foreign_key => :created_by_id, :class_name=>'User'
  belongs_to :updated_by, :foreign_key => :updated_by_id, :class_name=>'User'

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
