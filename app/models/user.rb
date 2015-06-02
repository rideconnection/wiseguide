class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  # attr_accessible :first_name, :last_name, :phone_number,
  #   :email, :password, :password_confirmation, :remember_me,
  #   :organization_id

  # Include default devise modules. Others available are:
  # :registerable, :rememberable, :confirmable, :lockable, :timeoutable and
  # :omniauthable
  devise :database_authenticatable, :recoverable, :trackable, :validatable

  has_paper_trail :ignore => [:sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip], :skip => [:reset_password_token]
  
  belongs_to :organization

  has_many :kases, :dependent => :nullify
  has_many :contacts, :dependent => :nullify
  has_many :events, :dependent => :nullify
  has_many :assessment_requests, :foreign_key => :submitter_id, :dependent => :nullify
  has_many :referred_kases, :through => :assessment_requests, :source => :kase

  before_save :clean_level

  validates_presence_of   :first_name
  validates_presence_of   :last_name
  validates_uniqueness_of :email
  validates_presence_of   :organization_id  
  validates_format_of     :password, :if => :password_required?,
                          :with => /^(?=.*[0-9])(?=.*[\W_&&[^\s] ])([\w\W&&[^\s] ]+)$/i, # Let Devise handle the length requirement. Regexp tested at http://www.rubular.com/r/7peotZQNui
                          :message => "must have at least one number and at least one non-alphanumeric character"
  
  default_scope order(:first_name, :last_name)
  scope :active, where("users.level >= 0")
  scope :inside_or_selected, lambda{|user_id| where('id IN (?)', ([user_id] + Organization.all.reject(&:is_outside_org?).collect{|o| o.users.active.collect(&:id)}).flatten.compact.reject(&:blank?))}
  scope :outside_or_selected, lambda{|user_id| where('id IN (?)', ([user_id] + Organization.all.reject{|o| !o.is_outside_org?}.collect{|o| o.users.active.collect(&:id)}).flatten.compact.reject(&:blank?))}
  scope :cmo_or_selected, lambda{|user_id| where('id IN (?)', ([user_id] + Organization.all.reject{|o| !o.is_cmo?}.collect{|o| o.users.active.collect(&:id)}).flatten.compact.reject(&:blank?))}

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
  
  # Generates a random password in accordance with the validation filter above
  def self.random_password
    specials = ((32..47).to_a + (58..64).to_a + (91..96).to_a + (123..126).to_a).pack('U*').chars.to_a
    numbers  = (1..9).to_a
    alpha    = ('a'..'z').to_a + ('A'..'Z').to_a
    %w{i I l L 1 O o}.each{ |ambiguous_character| 
      alpha.delete ambiguous_character 
    }
    characters = (alpha + specials + numbers)
    password = Random.new.rand(8..18).times.map{characters.sample}
    password << specials.sample unless password.join =~ Regexp.new(Regexp.escape(specials.join))
    password << numbers.sample  unless password.join =~ Regexp.new(Regexp.escape(numbers.join))
    password.shuffle.join
  end
  
  # Override Devise::Models::DatabaseAuthenticatabl::valid_password?
  # Some user accounts were previously disabled by blanking or "x"ing out the
  # encrypted password field, which causes an invalid hash error.
  def valid_password?(*args)
    begin
      super
    rescue BCrypt::Errors::InvalidHash
      false
    end
  end

  private

  def clean_level
    return if level == -1
    # Force outside users to level 25 on save
    if is_outside_user? then
      self.level = 25
    elsif self.level == 25
      # Make formerly outside users viewers by default
      self.level = 0
    end
  end
 
end
