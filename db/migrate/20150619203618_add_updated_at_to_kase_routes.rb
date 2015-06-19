class AddUpdatedAtToKaseRoutes < ActiveRecord::Migration
  def change
    add_column :kase_routes, :updated_at, :datetime
  end
end
