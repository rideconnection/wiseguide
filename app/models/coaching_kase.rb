class CoachingKase < Kase
  include DevelopmentKaseBehavior
  
  belongs_to :case_manager, :foreign_key => :case_manager_id, :class_name=>'User'
  
  validates :case_manager, :associated => true, :allow_blank => true
  validates :case_manager_notification_date, :allow_blank => true, :timeliness => { 
    :on_or_before => lambda { Date.current }, :type => :date 
  }
  validates :assessment_date, :allow_blank => true, :timeliness => { 
    :on_or_before => lambda { Date.current }, :type => :date
  }
end
