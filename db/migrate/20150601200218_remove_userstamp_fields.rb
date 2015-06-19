class RemoveUserstampFields < ActiveRecord::Migration
  def up
    remove_column "ada_service_eligibility_statuses", "created_by_id"
    remove_column "ada_service_eligibility_statuses", "updated_by_id"
    remove_column "contacts", "created_by_id"
    remove_column "contacts", "updated_by_id"
    remove_column "customer_impairments", "created_by_id"
    remove_column "customer_support_network_members", "created_by_id"
    remove_column "customer_support_network_members", "updated_by_id"
    remove_column "customers", "created_by_id"
    remove_column "customers", "updated_by_id"
    remove_column "dispositions", "created_by_id"
    remove_column "dispositions", "updated_by_id"
    remove_column "ethnicities", "created_by_id"
    remove_column "ethnicities", "updated_by_id"
    remove_column "event_types", "created_by_id"
    remove_column "event_types", "updated_by_id"
    remove_column "events", "created_by_id"
    remove_column "events", "updated_by_id"
    remove_column "funding_sources", "created_by_id"
    remove_column "funding_sources", "updated_by_id"
    remove_column "impairments", "created_by_id"
    remove_column "impairments", "updated_by_id"
    remove_column "kase_routes", "created_by_id"
    remove_column "kases", "created_by_id"
    remove_column "kases", "updated_by_id"
    remove_column "outcomes", "created_by_id"
    remove_column "outcomes", "updated_by_id"
    remove_column "referral_document_resources", "created_by_id"
    remove_column "referral_document_resources", "updated_by_id"
    remove_column "referral_documents", "created_by_id"
    remove_column "referral_documents", "updated_by_id"
    remove_column "referral_types", "created_by_id"
    remove_column "referral_types", "updated_by_id"
    remove_column "response_sets", "created_by_id"
    remove_column "response_sets", "updated_by_id"
    remove_column "routes", "created_by_id"
    remove_column "routes", "updated_by_id"
    remove_column "trip_authorizations", "created_by_id"
    remove_column "trip_authorizations", "updated_by_id"
    remove_column "trip_reasons", "created_by_id"
    remove_column "trip_reasons", "updated_by_id"
    remove_column "users", "created_by_id"
    remove_column "users", "updated_by_id"
  end

  def down
    add_column "ada_service_eligibility_statuses", "created_by_id", :integer
    add_column "ada_service_eligibility_statuses", "updated_by_id", :integer
    add_column "contacts", "created_by_id", :integer
    add_column "contacts", "updated_by_id", :integer
    add_column "customer_impairments", "created_by_id", :integer
    add_column "customer_support_network_members", "created_by_id", :integer
    add_column "customer_support_network_members", "updated_by_id", :integer
    add_column "customers", "created_by_id", :integer
    add_column "customers", "updated_by_id", :integer
    add_column "dispositions", "created_by_id", :integer
    add_column "dispositions", "updated_by_id", :integer
    add_column "ethnicities", "created_by_id", :integer
    add_column "ethnicities", "updated_by_id", :integer
    add_column "event_types", "created_by_id", :integer
    add_column "event_types", "updated_by_id", :integer
    add_column "events", "created_by_id", :integer
    add_column "events", "updated_by_id", :integer
    add_column "funding_sources", "created_by_id", :integer
    add_column "funding_sources", "updated_by_id", :integer
    add_column "impairments", "created_by_id", :integer
    add_column "impairments", "updated_by_id", :integer
    add_column "kase_routes", "created_by_id", :integer
    add_column "kases", "created_by_id", :integer
    add_column "kases", "updated_by_id", :integer
    add_column "outcomes", "created_by_id", :integer
    add_column "outcomes", "updated_by_id", :integer
    add_column "referral_document_resources", "created_by_id", :integer
    add_column "referral_document_resources", "updated_by_id", :integer
    add_column "referral_documents", "created_by_id", :integer
    add_column "referral_documents", "updated_by_id", :integer
    add_column "referral_types", "created_by_id", :integer
    add_column "referral_types", "updated_by_id", :integer
    add_column "response_sets", "created_by_id", :integer
    add_column "response_sets", "updated_by_id", :integer
    add_column "routes", "created_by_id", :integer
    add_column "routes", "updated_by_id", :integer
    add_column "trip_authorizations", "created_by_id", :integer
    add_column "trip_authorizations", "updated_by_id", :integer
    add_column "trip_reasons", "created_by_id", :integer
    add_column "trip_reasons", "updated_by_id", :integer
    add_column "users", "created_by_id", :integer
    add_column "users", "updated_by_id", :integer
  end
end
