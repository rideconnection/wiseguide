# TODO Could this just be a simple HABTM?

class KaseRoute < ActiveRecord::Base
  belongs_to :route
  belongs_to :kase
end
