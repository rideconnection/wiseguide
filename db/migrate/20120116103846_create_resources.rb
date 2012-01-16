class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.string :name
      t.string :phone_number
      t.string :email
      t.string :url
      t.text :address
      t.text :hours
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end
