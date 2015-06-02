# TODO Could this just be a simple HABTM?

class KaseRoute < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :route
  belongs_to :kase
end
