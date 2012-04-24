class CoachingKase < Kase
  belongs_to :case_manager, :foreign_key => :case_manager_id, :class_name=>'User'
  
  validates :case_manager, :associated => true, :allow_blank => true
  validates :case_manager_notification_date, :allow_blank => true, :date => { 
    :before_or_equal_to => Proc.new { Date.current } 
  }
  validates :assessment_date, :allow_blank => true, :date => { 
    :before_or_equal_to => Proc.new { Date.current } 
  }

  # Notify case manager and update timestamp
  def assessment_complete
    self.assessment_date = Date.current
    unless self.case_manager.blank?
      AssessmentMailer.customer_assessed_email(self.case_manager, self).deliver
      self.case_manager_notification_date = Date.current
    end
    save!
  end
end
