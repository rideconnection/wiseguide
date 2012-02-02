class CoachingKase < Kase
  belongs_to :case_manager, :foreign_key => :case_manager_id, :class_name=>'User'
  
  validates :case_manager, :presence => true, :associated => true
  validates :case_manager_notification_date, :allow_blank => true, :date => { 
    :before_or_equal_to => Proc.new { Date.current } 
  }
  validates :assessment_language, :presence => true
  validates :assessment_date, :date => { 
    :before_or_equal_to => Proc.new { Date.current } 
  }
end
