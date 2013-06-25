class AddReferralMechanismToKases < ActiveRecord::Migration
  def change
    add_column :kases, :referral_mechanism, :string
    add_column :kases, :referral_mechanism_explanation, :string

    # Directly update all records without instantiating models.
    TrainingKase.update_all(
      "referral_mechanism = 'Other', " +
      "referral_mechanism_explanation = 'Not Specified'"
    )
  end
end
