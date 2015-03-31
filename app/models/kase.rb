# This base Kase class should define behavior common to all Kase subclasses,
# or methods that are used to report on attribute values. Functionality 
# specific to a single subclass should be defined within that subclass. 
# Functionality specific to a subset of subclasses should be defined in a 
# module and then included in subclasses as necessary.
class Kase < ActiveRecord::Base
  belongs_to :customer
  belongs_to :disposition
  belongs_to :assigned_to, :foreign_key=>:user_id, :class_name=>"User"
  belongs_to :referral_type
  belongs_to :funding_source

  belongs_to :created_by, :foreign_key => :created_by_id, :class_name=>'User'
  belongs_to :updated_by, :foreign_key => :updated_by_id, :class_name=>'User'

  has_one  :assessment_request, :dependent => :nullify

  has_many :events, :dependent => :destroy
  has_many :response_sets, :dependent => :destroy
  has_many :outcomes, :dependent => :destroy
  has_many :referral_documents, :dependent => :destroy
  has_many :trip_authorizations, :dependent => :destroy
  has_many :contacts, :as => :contactable, :dependent => :destroy
  has_many :kase_routes, :dependent => :destroy 
  has_many :routes, :through => :kase_routes

  stampable :creator_attribute => :created_by_id, :updater_attribute => :updated_by_id

  VALID_COUNTIES = {'Clackamas' => 'C', 'Multnomah' => 'M', 'Washington' => 'W'}

  validates_presence_of  :customer_id
  validates              :open_date, :timeliness => { :on_or_before => lambda { Date.current }, :type => :date }
  validates_presence_of  :disposition_id
  validates_presence_of  :close_date, :if => Proc.new {|kase| kase.disposition && kase.disposition.name != "In Progress" }
  validate do |kase|
    kase.errors[:disposition_id] << "cannot be 'In Progress' if case is closed" if kase.close_date.present? && kase.disposition && kase.disposition.name == 'In Progress'
    kase.errors[:type] << "must be a valid subclass of Kase" unless Kase.descendants.map{|klass| klass.original_model_name}.include?(kase.type)
  end
    
  HUMAN_ATTRIBUTE_NAMES = {
    :medicaid_eligible => "Are you on Medicaid or the OHP Plan PLUS?",
    :scheduling_system_entry_required => "Entry into scheduling system required",
    :adult_ticket_count => "Adult tickets disbursed",
    :honored_ticket_count => "Honored tickets disbursed"
  }
  
  def self.human_attribute_name(attr, options={})
    HUMAN_ATTRIBUTE_NAMES[attr.to_sym] || super
  end
  
  scope :assigned_to, lambda {|user| where(:user_id => user.id) }
  scope :not_assigned_to, lambda {|user| where('user_id <> ?',user.id)}
  scope :unassigned, where(:user_id => nil)
  scope :open, where(:close_date => nil)
  scope :opened_in_range, lambda{|date_range| where(:open_date => date_range)}
  scope :open_in_range, lambda{|date_range| where("NOT (COALESCE(kases.close_date,?) < ? OR kases.open_date > ?)", date_range.begin, date_range.begin, date_range.end)}
  scope :closed, where('close_date IS NOT NULL')
  scope :closed_in_range, lambda{|date_range| where(:close_date => date_range)}
  scope :successful, lambda{where("disposition_id IN (?)", Disposition.successful.collect(&:id))}
  scope :has_three_month_follow_ups_due, lambda{successful.where('kases.close_date < ? AND NOT EXISTS (SELECT id FROM outcomes WHERE kase_id=kases.id AND (three_month_unreachable = ? OR three_month_trip_count IS NOT NULL))', 3.months.ago + 1.week, true)}
  scope :has_six_month_follow_ups_due, lambda{successful.where('kases.close_date < ? AND NOT EXISTS (SELECT id FROM outcomes WHERE kase_id = kases.id AND (six_month_unreachable = ? OR six_month_trip_count IS NOT NULL))', 6.months.ago + 1.week, true)}
  scope :scheduling_system_entry_required, where(:scheduling_system_entry_required => true, :type => 'CoachingKase')

  # Make sure our STI children are routed through the parent routes
  def self.inherited(child)
    child.instance_eval do      
      alias :original_model_name :model_name
            
      def model_name
        Kase.model_name
      end
      
      def human_name
        self.original_model_name.underscore.humanize.titlecase
      end
      
      def humanized_name
        human_name.sub(/\bKase\b/, 'Case')
      end
    end
    super
  end

  def medicaid_eligible_description
    if medicaid_eligible.nil?
      "Not asked"
    else 
      medicaid_eligible ? "Yes" : "No"
    end
  end

  def household_income_description
    household_income.blank? ? household_income_alternate_response : household_income
  end

  def household_size_description
    household_size.blank? ? household_size_alternate_response : household_size
  end

  def eligible_for_ticket_disbursement_description
    if eligible_for_ticket_disbursement.nil?
      "Undetermined"
    else 
      eligible_for_ticket_disbursement ? "Yes" : "No"
    end
  end
end
