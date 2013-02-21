class AddFareAssistanceFieldsToKases < ActiveRecord::Migration
  def change
    add_column :kases, :adult_ticket_count, :integer
    add_column :kases, :honored_ticket_count, :integer
    add_column :kases, :eligible_for_ticket_disbursement, :boolean
    add_column :kases, :access_transit_partner_referred_to, :string
  end
end
