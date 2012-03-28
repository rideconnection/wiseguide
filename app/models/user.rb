class User < ActiveRecord::Base
  model_stamper
  stampable :creator_attribute => :created_by_id, :updater_attribute => :updated_by_id

  belongs_to :created_by, :foreign_key => :created_by_id, :class_name=>'User'
  belongs_to :updated_by, :foreign_key => :updated_by_id, :class_name=>'User'
  belongs_to :organization

  has_many :kases, :dependent => :nullify
  has_many :contacts, :dependent => :nullify
  has_many :events, :dependent => :nullify
  has_many :assessment_requests, :foreign_key => :submitter_id, :dependent => :nullify
  has_many :referred_kases, :through => :assessment_requests, :source => :kase

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :organization_id

  before_save :clean_level

  validates_confirmation_of :password
  validates_uniqueness_of :email
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :phone_number
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :organization_id

  default_scope order(:email)
  scope :active, where("users.level >= 0")
  scope :inside_or_selected, lambda{|user_id| where('id IN (?)', ([user_id] + Organization.all.reject(&:is_outside_org?).collect{|o| o.users.active.collect(&:id)}).flatten.compact.reject(&:blank?))}
  scope :outside_or_selected, lambda{|user_id| where('id IN (?)', ([user_id] + Organization.all.reject{|o| !o.is_outside_org?}.collect{|o| o.users.active.collect(&:id)}).flatten.compact.reject(&:blank?))}

  def display_name
    if first_name.blank? then
      if last_name.blank? then
        return 'Unnamed User'
      else
        return last_name
      end
    else
      return first_name + (last_name.blank? ? '' : ' ' + last_name)
    end
  end

  def role_name
    case level
    when -1 
      return "Deleted"
    when 0
      return "Viewer"
    when 25
      return "Outside"
    when 50
      return "Editor"
    when 100
      return "Admin"
    end
  end

  def is_admin
    return level == 100
  end

  def is_outside_user?
    return organization.is_outside_org?
  end

  def update_password(params)
    unless params[:password].blank?
      self.update_with_password(params)
    else
      self.errors.add('password', :blank)
      false
    end
  end

  private

  def clean_level
    # Force outside users to level 25 on save
    if is_outside_user? then
      self.level = 25
    elsif self.level == 25
      # Make formerly outside users viewers by default
      self.level = 0
    end
  end
 
end
