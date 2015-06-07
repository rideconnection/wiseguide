class AssessmentRequest < ActiveRecord::Base
  belongs_to :submitter, :class_name => "User", :foreign_key => :submitter_id
  belongs_to :assignee, :class_name => "User", :foreign_key => :assignee_id
  belongs_to :customer
  belongs_to :kase
  
  has_one :referring_organization, :through => :submitter, :source => :organization
  has_many :contacts, :as => :contactable, :dependent => :destroy

  has_attached_file :attachment,
    :path => ":rails_root/uploads/:attachment/:id/:basename.:extension",
    :url  => "/assessment_requests/:id/download_attachment"

  validates_attachment_content_type :attachment, :content_type => ['application/pdf']

  validates_presence_of  :customer_first_name
  validates_presence_of  :customer_last_name
  validates_presence_of  :customer_phone
  validates_presence_of  :submitter
  validates_inclusion_of :reason_not_completed, :in => ["Could not reach", "Duplicate request", "Out-of-service area", "Request withdrawn"], :allow_blank => true
  validates              :customer_middle_initial, :length => { :maximum => 1 }

  scope :assigned_to,      lambda { |users| where(:assignee_id => Array(users).collect(&:id)) }
  scope :belonging_to,     lambda { |organizations| joins(:referring_organization).where("organizations.id IN (?)", Array(organizations).collect(&:id)) }
  scope :submitted_by,     lambda { |users| where(:submitter_id => Array(users).collect(&:id)) }
  scope :created_in_range, lambda { |date_range| where("created_at >= ? AND created_at < ?", date_range.begin, date_range.end) }

  # "Pending" (reason_not_completed is blank and no associated TC case)
  scope :pending, -> { where("(reason_not_completed IS NULL OR reason_not_completed = '') AND (kase_id IS NULL OR kase_id <= 0)") }
  
  # "Not completed" (reason_not_completed is not blank)
  scope :not_completed, -> { where("reason_not_completed > ''") }
  
  # "Completed" (kase_id foreign key is not blank)
  scope :completed, -> { where("kase_id > 0") }

  def display_name
    return customer_last_name + ", " + customer_first_name
  end
  
  def organization
    return submitter.organization
  end
  
  def status
    # "Pending" (reason_not_completed is blank and no associated TC case)
    # "Not completed" (reason_not_completed is not blank)
    # "Completed" (kase_id foreign key is not blank)
    if !kase_id.blank?
      "Completed"
    elsif !reason_not_completed.blank?
      "Not completed (#{reason_not_completed})"
    else
      "Pending"
    end
  end
end
