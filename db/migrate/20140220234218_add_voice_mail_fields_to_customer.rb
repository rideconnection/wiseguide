class AddVoiceMailFieldsToCustomer < ActiveRecord::Migration
  def change
    change_table :customers do |t|
      t.boolean :phone_number_1_allow_voicemail
      t.boolean :phone_number_2_allow_voicemail
      t.boolean :phone_number_3_allow_voicemail
      t.boolean :phone_number_4_allow_voicemail
    end
  end
end
