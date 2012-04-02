class Kase < ActiveRecord::Base
  belongs_to :customer
  belongs_to :referral_type
  belongs_to :funding_source
  belongs_to :disposition
  belongs_to :assigned_to, :foreign_key=>:user_id, :class_name=>"User"

  stampable :creator_attribute => :created_by_id, :updater_attribute => :updated_by_id
  belongs_to :created_by, :foreign_key => :created_by_id, :class_name=>'User'
  belongs_to :updated_by, :foreign_key => :updated_by_id, :class_name=>'User'

  has_one  :assessment_request, :dependent => :nullify
  has_many :contacts, :dependent => :nullify
  has_many :events, :dependent => :destroy
  has_many :response_sets, :dependent => :destroy
  has_many :kase_routes, :dependent => :destroy
  has_many :routes, :through => :kase_routes
  has_many :outcomes, :dependent => :destroy
  has_many :referral_documents, :dependent => :destroy

  VALID_COUNTIES = {'Clackamas' => 'C', 'Multnomah' => 'M', 'Washington' => 'W'}

  validates_presence_of  :customer_id
  validates              :open_date, :date => { :before_or_equal_to => Proc.new { Date.current } }
  validates_presence_of  :referral_source
  validates_presence_of  :referral_type_id
  validates_presence_of  :disposition
  validates_presence_of  :close_date, :if => Proc.new {|kase| kase.disposition && kase.disposition.name != "In Progress" }
  validate do |kase|
    kase.errors[:disposition_id] << "cannot be 'In Progress' if case is closed" if kase.close_date.present? && kase.disposition && kase.disposition.name == 'In Progress'
    kase.errors[:type] << "must be a valid subclass of Kase" unless Kase.descendants.map{|klass| klass.original_model_name}.include?(kase.type)
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
  scope :for_funding_source_id, lambda {|funding_source_id| funding_source_id.present? ? where(:funding_source_id => funding_source_id) : where(true) }

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

  # Perform any post-survey logic
  def assessment_complete
  end

end
