# TODO Verify Strong Parameters after upgrading Surveyor to v1.5

class ResponseSet < ActiveRecord::Base
  include Surveyor::Models::ResponseSetMethods

  belongs_to :kase
  has_one    :customer, through: :kase
  belongs_to :user
end
