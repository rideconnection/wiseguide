class Disposition < ActiveRecord::Base
  stampable :creator_attribute => :created_by_id, :updater_attribute => :updated_by_id
  belongs_to :created_by, :foreign_key => :created_by_id, :class_name=>'User'
  belongs_to :updated_by, :foreign_key => :updated_by_id, :class_name=>'User'
  
  validates :name, :uniqueness => {:scope => :type}
  validate do |disposition|
    disposition.errors[:type] << "must be a valid subclass of Disposition" unless Disposition.descendants.map{|disposition| disposition.original_model_name}.include?(disposition.type)
  end

  def self.successful
    self.where(:name => 'Successful')
  end
  
  # Make sure our STI children are routed through the parent routes
  def self.inherited(child)
    child.instance_eval do
      alias :original_model_name :model_name
      def model_name
        Disposition.model_name
      end
    end
    super
  end
end
