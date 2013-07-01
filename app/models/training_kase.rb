class TrainingKase < Kase
  include DevelopmentKaseBehavior

  REFERRAL_MECHANISM_OPTIONS = [
    "Email", 
    "Facsimile", 
    "Online Referral System", 
    "Telephone", 
    "Request from Existing Customer", 
    "Other"
  ]

  validates :funding_source_id, 
    :presence => true

  validates :county, 
    :inclusion => {:in => VALID_COUNTIES.values}

  validates :referral_source, 
    :presence => true

  validates :referral_mechanism, 
    :inclusion => {:in => REFERRAL_MECHANISM_OPTIONS, :allow_nil => false}

  validates :referral_mechanism_explanation, 
    :presence => {
      :if       => :other_mechanism?, 
      :message  => 'must be present if the referral mechanism is "Other"'
    } 

  private

  def other_mechanism?
    referral_mechanism == "Other"
  end
end
