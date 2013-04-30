class AddCategoryToKases < ActiveRecord::Migration
  def change
    add_column :kases, :category, :string
  end
end
