# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160909182548) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "fuzzystrmatch"

  create_table "ada_service_eligibility_statuses", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "agencies", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "answers", force: :cascade do |t|
    t.integer  "question_id"
    t.text     "text"
    t.text     "short_text"
    t.text     "help_text"
    t.integer  "weight"
    t.string   "response_class",         limit: 255
    t.string   "reference_identifier",   limit: 255
    t.string   "data_export_identifier", limit: 255
    t.string   "common_namespace",       limit: 255
    t.string   "common_identifier",      limit: 255
    t.integer  "display_order"
    t.boolean  "is_exclusive"
    t.integer  "display_length"
    t.string   "custom_class",           limit: 255
    t.string   "custom_renderer",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "default_value",          limit: 255
    t.string   "api_id",                 limit: 255
    t.string   "display_type",           limit: 255
    t.boolean  "hide_label"
    t.string   "input_mask",             limit: 255
    t.string   "input_mask_placeholder", limit: 255
  end

  add_index "answers", ["api_id"], name: "uq_answers_api_id", unique: true, using: :btree

  create_table "assessment_requests", force: :cascade do |t|
    t.string   "customer_first_name",     limit: 255
    t.string   "customer_last_name",      limit: 255
    t.string   "customer_phone",          limit: 255
    t.date     "customer_birth_date"
    t.text     "notes"
    t.integer  "submitter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kase_id"
    t.integer  "customer_id"
    t.string   "attachment_file_name",    limit: 255
    t.string   "attachment_content_type", limit: 255
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string   "reason_not_completed",    limit: 255
    t.integer  "assignee_id"
    t.string   "customer_middle_initial", limit: 255
    t.string   "customer_identifier"
  end

  create_table "contacts", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "date_time"
    t.string   "method",           limit: 255
    t.string   "description",      limit: 255
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                 default: 0
    t.boolean  "show_full_notes"
    t.string   "contactable_type", limit: 255
    t.integer  "contactable_id"
  end

  add_index "contacts", ["contactable_type", "contactable_id"], name: "index_contacts_on_contactable_type_and_contactable_id", using: :btree

  create_table "counties", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_impairments", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "impairment_id"
    t.datetime "created_at"
    t.string   "notes",         limit: 255
    t.datetime "updated_at"
  end

  create_table "customer_support_network_members", force: :cascade do |t|
    t.integer  "customer_id"
    t.string   "name",         limit: 255
    t.string   "title",        limit: 255
    t.string   "organization", limit: 255
    t.string   "phone_number", limit: 255
    t.string   "email",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",             default: 0
  end

  create_table "customers", force: :cascade do |t|
    t.string   "first_name",                        limit: 255
    t.string   "last_name",                         limit: 255
    t.date     "birth_date"
    t.string   "gender",                            limit: 255
    t.string   "phone_number_1",                    limit: 255
    t.string   "phone_number_2",                    limit: 255
    t.string   "email",                             limit: 255
    t.string   "address",                           limit: 255
    t.string   "city",                              limit: 255
    t.string   "state",                             limit: 255, default: "OR"
    t.string   "zip",                               limit: 255
    t.integer  "ethnicity_id"
    t.text     "notes"
    t.string   "portrait_file_name",                limit: 255
    t.string   "portrait_content_type",             limit: 255
    t.integer  "portrait_file_size"
    t.datetime "portrait_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                                  default: 0
    t.string   "phone_number_3",                    limit: 255
    t.string   "phone_number_4",                    limit: 255
    t.string   "county",                            limit: 25
    t.boolean  "veteran_status"
    t.boolean  "spouse_of_veteran_status"
    t.boolean  "honored_citizen_cardholder"
    t.string   "primary_language",                  limit: 255
    t.integer  "ada_service_eligibility_status_id"
    t.string   "middle_initial",                    limit: 1
    t.boolean  "phone_number_1_allow_voicemail"
    t.boolean  "phone_number_2_allow_voicemail"
    t.boolean  "phone_number_3_allow_voicemail"
    t.boolean  "phone_number_4_allow_voicemail"
    t.string   "identifier"
  end

  create_table "dependencies", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "question_group_id"
    t.string   "rule",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dependency_conditions", force: :cascade do |t|
    t.integer  "dependency_id"
    t.string   "rule_key",       limit: 255
    t.integer  "question_id"
    t.string   "operator",       limit: 255
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit",           limit: 255
    t.text     "text_value"
    t.string   "string_value",   limit: 255
    t.string   "response_other", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dispositions", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",             default: 0
    t.string   "type",         limit: 255
  end

  add_index "dispositions", ["name", "type"], name: "index_dispositions_on_name_and_type", unique: true, using: :btree
  add_index "dispositions", ["type"], name: "index_dispositions_on_type", using: :btree

  create_table "ethnicities", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",             default: 0
  end

  create_table "event_types", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",              default: 0
    t.boolean  "require_notes",             default: false
  end

  create_table "events", force: :cascade do |t|
    t.integer  "kase_id"
    t.integer  "user_id"
    t.date     "date"
    t.integer  "event_type_id"
    t.integer  "funding_source_id"
    t.decimal  "duration_in_hours", precision: 5, scale: 2
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                              default: 0
    t.time     "start_time"
    t.time     "end_time"
    t.boolean  "show_full_notes",                           default: false
  end

  create_table "funding_sources", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",             default: 0
  end

  create_table "impairments", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",             default: 0
  end

  create_table "kase_routes", force: :cascade do |t|
    t.integer  "kase_id"
    t.integer  "route_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kases", force: :cascade do |t|
    t.integer  "customer_id"
    t.date     "open_date"
    t.date     "close_date"
    t.string   "referral_source",                     limit: 255
    t.integer  "referral_type_id"
    t.integer  "user_id"
    t.integer  "funding_source_id"
    t.integer  "disposition_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                                    default: 0
    t.string   "county",                              limit: 1
    t.string   "type",                                limit: 255
    t.date     "assessment_date"
    t.string   "assessment_language",                 limit: 255
    t.date     "case_manager_notification_date"
    t.integer  "case_manager_id"
    t.integer  "assessment_request_id"
    t.integer  "household_size"
    t.integer  "household_income"
    t.string   "household_size_alternate_response",   limit: 255
    t.string   "household_income_alternate_response", limit: 255
    t.boolean  "medicaid_eligible"
    t.boolean  "scheduling_system_entry_required"
    t.integer  "adult_ticket_count"
    t.integer  "honored_ticket_count"
    t.boolean  "eligible_for_ticket_disbursement"
    t.string   "access_transit_partner_referred_to",  limit: 255
    t.string   "category",                            limit: 255
    t.integer  "agency_id"
    t.string   "referral_mechanism",                  limit: 255
    t.string   "referral_mechanism_explanation",      limit: 255
  end

  add_index "kases", ["scheduling_system_entry_required"], name: "index_kases_on_scheduling_system_entry_required", using: :btree
  add_index "kases", ["type"], name: "index_kases_on_type", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.integer  "parent_id",                     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "organization_type", limit: 255
  end

  create_table "outcomes", force: :cascade do |t|
    t.integer  "kase_id"
    t.integer  "trip_reason_id"
    t.integer  "exit_trip_count"
    t.integer  "exit_vehicle_miles_reduced"
    t.integer  "three_month_trip_count"
    t.integer  "three_month_vehicle_miles_reduced"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                      default: 0
    t.integer  "six_month_trip_count"
    t.integer  "six_month_vehicle_miles_reduced"
    t.boolean  "six_month_unreachable"
    t.boolean  "three_month_unreachable"
  end

  create_table "question_groups", force: :cascade do |t|
    t.text     "text"
    t.text     "help_text"
    t.string   "reference_identifier",   limit: 255
    t.string   "data_export_identifier", limit: 255
    t.string   "common_namespace",       limit: 255
    t.string   "common_identifier",      limit: 255
    t.string   "display_type",           limit: 255
    t.string   "custom_class",           limit: 255
    t.string   "custom_renderer",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_id",                 limit: 255
  end

  add_index "question_groups", ["api_id"], name: "uq_question_groups_api_id", unique: true, using: :btree

  create_table "questions", force: :cascade do |t|
    t.integer  "survey_section_id"
    t.integer  "question_group_id"
    t.text     "text"
    t.text     "short_text"
    t.text     "help_text"
    t.string   "pick",                   limit: 255
    t.string   "reference_identifier",   limit: 255
    t.string   "data_export_identifier", limit: 255
    t.string   "common_namespace",       limit: 255
    t.string   "common_identifier",      limit: 255
    t.integer  "display_order"
    t.string   "display_type",           limit: 255
    t.boolean  "is_mandatory"
    t.integer  "display_width"
    t.string   "custom_class",           limit: 255
    t.string   "custom_renderer",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "correct_answer_id"
    t.string   "api_id",                 limit: 255
  end

  add_index "questions", ["api_id"], name: "uq_questions_api_id", unique: true, using: :btree

  create_table "referral_document_resources", force: :cascade do |t|
    t.integer  "resource_id"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "referral_document_id"
  end

  add_index "referral_document_resources", ["referral_document_id", "resource_id"], name: "idx_refdoc_resources_refdoc_id_resource_id", unique: true, using: :btree
  add_index "referral_document_resources", ["referral_document_id"], name: "index_referral_document_resources_on_referral_document_id", using: :btree

  create_table "referral_documents", force: :cascade do |t|
    t.datetime "last_printed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kase_id"
  end

  add_index "referral_documents", ["kase_id"], name: "index_referral_documents_on_kase_id", using: :btree

  create_table "referral_types", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",             default: 0
  end

  create_table "resources", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "phone_number", limit: 255
    t.string   "email",        limit: 255
    t.string   "url",          limit: 255
    t.text     "address"
    t.text     "hours"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
  end

  create_table "response_sets", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "survey_id"
    t.string   "access_code",  limit: 255
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kase_id"
    t.string   "api_id",       limit: 255
  end

  add_index "response_sets", ["access_code"], name: "response_sets_ac_idx", unique: true, using: :btree
  add_index "response_sets", ["api_id"], name: "uq_response_sets_api_id", unique: true, using: :btree

  create_table "responses", force: :cascade do |t|
    t.integer  "response_set_id"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit",              limit: 255
    t.text     "text_value"
    t.string   "string_value",      limit: 255
    t.string   "response_other",    limit: 255
    t.string   "response_group",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "survey_section_id"
    t.string   "api_id",            limit: 255
  end

  add_index "responses", ["api_id"], name: "uq_responses_api_id", unique: true, using: :btree
  add_index "responses", ["survey_section_id"], name: "index_responses_on_survey_section_id", using: :btree

  create_table "routes", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",             default: 0
  end

  create_table "survey_sections", force: :cascade do |t|
    t.integer  "survey_id"
    t.string   "title",                  limit: 255
    t.text     "description"
    t.string   "reference_identifier",   limit: 255
    t.string   "data_export_identifier", limit: 255
    t.string   "common_namespace",       limit: 255
    t.string   "common_identifier",      limit: 255
    t.integer  "display_order"
    t.string   "custom_class",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "survey_translations", force: :cascade do |t|
    t.integer  "survey_id"
    t.string   "locale",      limit: 255
    t.text     "translation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surveys", force: :cascade do |t|
    t.string   "title",                  limit: 255
    t.text     "description"
    t.string   "access_code",            limit: 255
    t.string   "reference_identifier",   limit: 255
    t.string   "data_export_identifier", limit: 255
    t.string   "common_namespace",       limit: 255
    t.string   "common_identifier",      limit: 255
    t.datetime "active_at"
    t.datetime "inactive_at"
    t.string   "css_url",                limit: 255
    t.string   "custom_class",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "display_order"
    t.string   "api_id",                 limit: 255
    t.integer  "survey_version",                     default: 0
  end

  add_index "surveys", ["access_code", "survey_version"], name: "surveys_access_code_version_idx", unique: true, using: :btree
  add_index "surveys", ["api_id"], name: "uq_surveys_api_id", unique: true, using: :btree

  create_table "trip_authorizations", force: :cascade do |t|
    t.integer  "allowed_trips_per_month"
    t.date     "end_date"
    t.datetime "disposition_date"
    t.integer  "disposition_user_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "kase_id"
    t.date     "start_date"
    t.text     "special_instructions"
  end

  add_index "trip_authorizations", ["disposition_user_id"], name: "index_trip_authorizations_on_disposition_user_id", using: :btree
  add_index "trip_authorizations", ["kase_id"], name: "index_trip_authorizations_on_kase_id", using: :btree

  create_table "trip_reasons", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.boolean  "work_related"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",             default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 128, default: "", null: false
    t.string   "password_salt",          limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "phone_number",           limit: 255
    t.integer  "organization_id"
    t.datetime "reset_password_sent_at"
  end

  create_table "validation_conditions", force: :cascade do |t|
    t.integer  "validation_id"
    t.string   "rule_key",       limit: 255
    t.string   "operator",       limit: 255
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit",           limit: 255
    t.text     "text_value"
    t.string   "string_value",   limit: 255
    t.string   "response_other", limit: 255
    t.string   "regexp",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "validations", force: :cascade do |t|
    t.integer  "answer_id"
    t.string   "rule",       limit: 255
    t.string   "message",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  limit: 255, null: false
    t.integer  "item_id",                null: false
    t.string   "event",      limit: 255, null: false
    t.string   "whodunnit",  limit: 255
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
