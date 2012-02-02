class CoachingKase < Kase
  validates :case_manager_notification_date, :allow_blank => true, :date => { 
    :before_or_equal_to => Proc.new { Date.current } 
  }
  validates :case_manager, :presence => true
  validates :assessment_language, :presence => true
  validates :assessment_date, :date => { 
    :before_or_equal_to => Proc.new { Date.current } 
  }
end
