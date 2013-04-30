class CustomerServiceKase < Kase
  CATEGORY = [
    "commendations", 
    "comments",
    "incidents", 
    "policy complaints", 
    "service complaints", 
  ]
  COMPLAINT_CATEGORIES = ["policy complaints", "service complaints"]
  COMPLAINT_ONLY_DISPOSITIONS = ["Substantiated", "Unsubstantiated", "Indeterminable"]
  NON_COMPLAINT_DISPOSITIONS  = ["Completed"]
  
  belongs_to :agency
  
  validates_inclusion_of :category, :in => CATEGORY
  validates_presence_of :agency_id
  validate do |kase|
    if kase.disposition.present? 
      if COMPLAINT_CATEGORIES.include? kase.category
        kase.errors[:disposition_id] << "is not valid for category '#{kase.category}'" unless (["In Progress"] + COMPLAINT_ONLY_DISPOSITIONS).include? kase.disposition.name
      else
        kase.errors[:disposition_id] << "is not valid for category '#{kase.category}'" unless (["In Progress"] + NON_COMPLAINT_DISPOSITIONS).include? kase.disposition.name
      end
    end
  end
  
  def self.dispositions_for_select(dispositions)
    complaints_only = []
    non_complaints_only = []
    other = []
    dispositions.collect do |disposition|
      if COMPLAINT_ONLY_DISPOSITIONS.include? disposition.name
        complaints_only << [disposition.name, disposition.id]
      elsif NON_COMPLAINT_DISPOSITIONS.include? disposition.name
        non_complaints_only << [disposition.name, disposition.id]
      else
        other << [disposition.name, disposition.id]
      end
    end
    {
      'Any Category' => other.sort,
      'Complaint Categories' => complaints_only.sort,
      'Non Complaint Categories' => non_complaints_only.sort,
    }
  end
  
  after_save :send_notification_after_reassignment

private

  def send_notification_after_reassignment
    CustomerServiceKaseAssignmentMailer.reassignment_email(assigned_to, self).deliver if assigned_to.present? && user_id_changed?
  end
end