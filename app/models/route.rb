class Route < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
end
