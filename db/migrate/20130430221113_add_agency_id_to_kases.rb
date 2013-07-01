class AddAgencyIdToKases < ActiveRecord::Migration
  def change
    add_column :kases, :agency_id, :integer
  end
end
