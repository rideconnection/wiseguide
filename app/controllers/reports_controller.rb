require 'csv'
class ReportsController < ApplicationController

  def index
    @funding_sources = [FundingSource.new(name: "<All>")] + FundingSource.all
    @governmental_bodies = [Organization.new(name: "<All>")] + Organization.government
    @routes = Route.all
  end

  def data_entry_needed
    @kases = Kase.scheduling_system_entry_required.order(:close_date,:open_date)
  end

  def basic_report
    @start_date = Date.parse(params[:start_date])
    @end_date = Date.parse(params[:end_date])
    @exited_count = 0
    @vmr = 0
    @work_related_tpw = 0
    @non_work_related_tpw = 0
    @total_exited = TrainingKase.closed_in_range(@start_date..@end_date).for_funding_source_id(params[:funding_source_id]).count
    @exited_count = {}
    TrainingKaseDisposition.order(:name).each do |disposition|
      @exited_count[disposition.name] = TrainingKase.closed_in_range(@start_date..@end_date).for_funding_source_id(params[:funding_source_id]).where(disposition_id: disposition.id).count
    end
    if params[:funding_source_id].present?
      @funding_source = "Funding Source: #{FundingSource.find(params[:funding_source_id]).name}"
    else
      @funding_source = "All Funding Sources"
    end

    kases = TrainingKase.successful.closed_in_range(@start_date..@end_date).for_funding_source_id(params[:funding_source_id]).includes(outcomes: :trip_reason)

    for kase in kases
      for outcome in kase.outcomes
        vmr = outcome.exit_vehicle_miles_reduced
        tpw = outcome.exit_trip_count
        if outcome.three_month_vehicle_miles_reduced && outcome.three_month_trip_count
          vmr = outcome.three_month_vehicle_miles_reduced
          tpw = outcome.three_month_trip_count
        end
        if outcome.six_month_vehicle_miles_reduced && outcome.six_month_trip_count
          vmr = outcome.six_month_vehicle_miles_reduced
          tpw = outcome.six_month_trip_count
        end

        @vmr += vmr
        if outcome.trip_reason.work_related
          @work_related_tpw += tpw
        else
          @non_work_related_tpw += tpw
        end
      end
    end
  end

  def age_and_ethnicity
    @start_date = Date.parse(params[:start_date])
    @end_date = @start_date + 1.month - 1.day
    fy_start_date = Date.new(@start_date.year - (@start_date.month < 7 ? 1 : 0), 7, 1)

    @this_month_unknown_age = {}
    @this_month_sixty_plus = {}
    @this_month_less_than_sixty = {}
    @this_year_unknown_age = {}
    @this_year_sixty_plus = {}
    @this_year_less_than_sixty = {}
    @counts_by_ethnicity = {}

    Kase::VALID_COUNTIES.each do |county, county_code|
      month_customers = Customer.with_new_successful_exit_in_range_for_county(@start_date,@end_date,county_code).includes(:ethnicity).uniq
      year_customers = Customer.with_successful_exit_in_range_for_county(fy_start_date,@end_date,county_code).includes(:ethnicity).uniq

      @this_month_unknown_age[county] = 0
      @this_month_sixty_plus[county] = 0
      @this_month_less_than_sixty[county] = 0
      @this_year_unknown_age[county] = 0
      @this_year_sixty_plus[county] = 0
      @this_year_less_than_sixty[county] = 0
      @counts_by_ethnicity[county] = {}

      #first, handle the customers from this month
      for customer in month_customers
        age = customer.age_in_years
        if age.nil?
          @this_month_unknown_age[county] += 1
        elsif age > 60
          @this_month_sixty_plus[county] += 1
        else
          @this_month_less_than_sixty[county] += 1
        end

        if ! @counts_by_ethnicity[county].member? customer.ethnicity
          @counts_by_ethnicity[county][customer.ethnicity] = {'month' => 0, 'year' => 0}
        end
        @counts_by_ethnicity[county][customer.ethnicity]['month'] += 1
      end

      #now all customers for the year
      for customer in year_customers
        age = customer.age_in_years
        if age.nil?
          @this_year_unknown_age[county] += 1
        elsif age > 60
          @this_year_sixty_plus[county] += 1
        else
          @this_year_less_than_sixty[county] += 1
        end

        if ! @counts_by_ethnicity[county].member? customer.ethnicity
          @counts_by_ethnicity[county][customer.ethnicity] = {'month' => 0, 'year' => 0}
        end
        @counts_by_ethnicity[county][customer.ethnicity]['year'] += 1
      end
    end
  end

  def trainer
    #Trainer Report: Listing of training activities (Initial
    #interviews, scouts, trainings, shadows), with dates, durations.
    #Grouped by trainer with grand and by-trainer totals.

    @start_date = Date.parse(params[:start_date])
    @end_date = Date.parse(params[:end_date])

    events = Event.accessible_by(current_ability).in_range(@start_date..@end_date).includes(:event_type,:user,{kase: [:customer,:disposition]})
    events_by_trainer = {}
    hours_by_trainer = {'{total}' => 0}
    customers_by_trainer = {'{total}' => Set.new}
    for event in events
      user = event.user
      if ! events_by_trainer.member? user
        events_by_trainer[user] = []
      end
      events_by_trainer[user].push(event)
      if ! hours_by_trainer.member? user
        hours_by_trainer[user] = 0
      end
      hours_by_trainer[user] += event.duration_in_hours
      hours_by_trainer['{total}'] += event.duration_in_hours
      if ! customers_by_trainer.member? user
        customers_by_trainer[user] = Set.new
      end
      customers_by_trainer[user].add event.kase.customer
      customers_by_trainer['{total}'].add event.kase.customer
    end

    @trainers = events_by_trainer.keys.sort_by{|x| x.email}
    @events_by_trainer = events_by_trainer
    @hours_by_trainer = hours_by_trainer
    @customers_by_trainer = customers_by_trainer
    @events = events
  end

  def trainee

    @start_date = Date.parse(params[:start_date])
    @end_date = Date.parse(params[:end_date])

    events = Event.accessible_by(current_ability).in_range(@start_date..@end_date).includes(:event_type,:user,{kase: [:customer,:disposition]})
    kases = Kase.closed_in_range(@start_date..@end_date).includes(:disposition)
    events_by_customer = {}
    hours_by_customer = {}
    dispositions = {}
    events_by_type = {}
    for event in events
      customer = event.kase.customer

      if ! events_by_customer.member? customer
        events_by_customer[customer] = []
      end
      events_by_customer[customer].push(event)

      if ! hours_by_customer.member? customer
        hours_by_customer[customer] = 0
      end
      hours_by_customer[customer] += event.duration_in_hours

      if !events_by_type.member? event.event_type
        events_by_type[event.event_type] = 0
      end
      events_by_type[event.event_type] += 1
    end

    dispositions = kases.group_by(&:disposition)

    @customers = events_by_customer.keys.sort_by{|x| x.name_reversed}
    @events_by_customer = events_by_customer
    @hours_by_customer = hours_by_customer
    @dispositions = dispositions
    @events_by_type = events_by_type
    @events = events
  end

  def route

    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    @route = Route.find(params[:route_id])
    authorize! :read, @route
    @customers = Customer.accessible_by(current_ability).where("kase_routes.route_id = ? and (kases.open_date between ? and ? or kases.close_date between ? and ? or (kases.close_date is null and kases.open_date < ?))", params[:route_id], start_date, end_date, start_date, end_date, end_date).joins(kases: :kase_routes).includes(kases: :outcomes)
  end

  def outcomes
    #csv, one record per outcome
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    kases = Kase.successful.closed_in_range(start_date..end_date).includes({outcomes: :trip_reason},{customer: :ethnicity},:disposition,:assigned_to,:referral_type)

    csv = ""
    CSV.generate(csv) do |csv|
      csv << %w(Name DOB Ethnicity Gender Open\ Date Assigned\ To Referral\ Source Referral\ Type Close\ Date Trip\ Reason Exit\ Trip\ Count Exit\ VMR 3\ Month\ Unreachable 3\ Month\ Trip\ Count 3\ Month\ VMR 6\ Month\ Unreachable 6\ Month\ Trip\ Count 6\ Month\ VMR)
      for kase in kases
        customer = kase.customer
        if kase.outcomes.present?
          kase.outcomes.each{|outcome| csv << outcomes_row(customer, kase, outcome)}
        else
          csv << outcomes_row(customer, kase, nil)
        end
      end
    end

    send_data csv, type: "text/csv", filename: "outcomes #{start_date.to_s} to #{end_date.to_s}.csv", disposition: 'attachment'
  end

  def opened_cases
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    kases = Kase.opened_in_range(start_date..end_date)

    send_data kases_csv(kases), type: "text/csv", filename: "Opened Cases #{start_date.to_s} to #{end_date.to_s}.csv", disposition: 'attachment'
  end

  def closed_cases
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    kases = Kase.closed_in_range(start_date..end_date)

    send_data kases_csv(kases), type: "text/csv", filename: "Closed Cases #{start_date.to_s} to #{end_date.to_s}.csv", disposition: 'attachment'
  end

  def events
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    events = Event.accessible_by(current_ability).includes({kase: [:disposition,{customer: :ethnicity}]},:user,:funding_source,:event_type).where(date: start_date..end_date)

    csv = ""
    CSV.generate(csv) do |csv|
      csv << ['First Name',
              'Last Name',
              'DOB',
              'Ethnicity',
              'Gender',
              'Phone Number 1',
              'Phone Number 2',
              'Email',
              'Address',
              'City',
              'State',
              'Zip',
              'Notes',
              'Open Date',
              'Close Date',
              'Disposition',
              'Event Type',
              'Event Date',
              'Author',
              'Funding Source',
              'Hours']

      for event in events
        kase = event.kase
        customer = kase.customer
        csv << [customer.first_name,
                customer.last_name,
                customer.birth_date.to_s,
                customer.ethnicity.name,
                customer.gender,
                customer.phone_number_1,
                customer.phone_number_2,
                customer.email,
                customer.address,
                customer.city,
                customer.state,
                customer.zip,
                customer.notes,
                kase.open_date,
                kase.close_date,
                kase.disposition.name,
                event.event_type.name,
                event.date,
                event.user.try(:display_name),
                event.funding_source.name,
                event.duration_in_hours]
      end
    end
    send_data csv, type: "text/csv", filename: "events #{start_date.to_s} to #{end_date.to_s}.csv", disposition: 'attachment'
  end

  def monthly_transportation
    # Create “Monthly Transportation Report” under Reports tab with year and
    # month selectors, producing a table of the customers assessed during the
    # month and columns:
    # * Customer name
    # * Date referred
    # * Date of first customer contact by RideConnection
    # * Date of the assessment
    # * Date the CMO was notified of assessment completion

    @start_date = Date.parse(params[:start_date])
    @end_date = Date.parse(params[:end_date])
    @records = []
    kases = Kase.where(assessment_date: @start_date..@end_date).joins(:customer).select("kases.*, customers.first_name, customers.last_name").order('assessment_date ASC, last_name ASC, first_name ASC')
    kases.each do |kase|
      first_contact_date = ""
      if !kase.contacts.empty?
        first_contact_date = kase.contacts.order(:date_time).first.date_time.strftime('%Y-%m-%d')
      end
      referral_date = ""
      if !kase.assessment_request.nil?
        referral_date = kase.assessment_request.created_at.strftime('%Y-%m-%d')
      end
      @records << {
        kase_id: kase.id,
        customer_id: kase.customer.id,
        customer_name: kase.customer.name_reversed,
        referral_date: referral_date,
        first_contact_date: first_contact_date,
        assessment_date: kase.assessment_date.to_s,
        cmo_notified_date: kase.case_manager_notification_date.to_s
      }
    end
  end

  def customer_referral
    @start_date = Date.parse(params[:start_date])
    @end_date = Date.parse(params[:end_date])

    # a calculation of the number of coaching cases that have an assessment
    # date within the specified date range
    @assessments_performed = Kase.where("assessment_date BETWEEN ? AND ?", @start_date, @end_date).count

    # A list of CMOs whose case managers have created assessment requests that
    # are linked to cases with an assessment date within the date range
    # specified, and the number of unique customers assessed via those cases
    @referral_sources = Organization.joins(:users, "inner join assessment_requests on users.id = assessment_requests.submitter_id", "inner join kases on assessment_requests.kase_id = kases.id", "inner join customers on kases.customer_id = customers.id").select("COUNT(DISTINCT(customers.id)) as customers_assessed, organizations.id AS organization_id, organizations.name as organization_name").group("organizations.id, organizations.name").order("organizations.name").where("kases.assessment_date BETWEEN ? AND ?", @start_date, @end_date)

    # A list of services (aka resources) that are linked via referral
    # documents to cases that have an assessment date within the specified
    # date range and the number of customers who were referred to each service
    # through the following relationship:
    # customer -> kase -> referral_document -> referral_document_resource -> resource
    @services_referred = Resource.joins(:referral_documents, "inner join kases on referral_documents.kase_id = kases.id", "inner join customers on kases.customer_id = customers.id").select("COUNT(DISTINCT(customers.id)) as customers_referred, resources.id as resource_id, resources.name as resource_name").group("resources.id, resources.name").order("resources.name").where("kases.assessment_date BETWEEN ? AND ?", @start_date, @end_date)
  end

  def assessment_requests
    start_date = Time.parse(params[:start_date])
    end_date = Time.parse(params[:end_date]) + 1.day

    assessment_requests = AssessmentRequest.accessible_by(current_ability).created_in_range(start_date..end_date).order(:created_at).includes(:submitter,:assignee)

    csv = ""
    CSV.generate(csv) do |csv|
      csv << ['Created At',
              'Customer Name',
              'Customer Phone',
              'Customer Birth Date',
              'Request Notes',
              'Submitter',
              'Assigned To',
              'Status']
      assessment_requests.each do |assessment_request|
        csv << [assessment_request.created_at,
                assessment_request.display_name,
                assessment_request.customer_phone,
                assessment_request.customer_birth_date,
                assessment_request.notes,
                assessment_request.submitter.try(:display_name),
                assessment_request.assignee.try(:display_name),
                assessment_request.status]
      end
    end
    send_data csv, type: "text/csv", filename: "Assessment Requests #{start_date.to_s(:file_name)} to #{(end_date - 1.day).to_s(:file_name)}.csv", disposition: 'attachment'
  end

  def county_assessments
    start_date = Time.parse(params[:start_date])
    end_date = Time.parse(params[:end_date]) + 1.day

    assessments = ResponseSet.accessible_by(current_ability).
      distinct.
      joins(kase: {assessment_request: :referring_organization}).
      includes(:customer, kase: {assessment_request: [:submitter, :assignee, :referring_organization]}).
      where('response_sets.completed_at >= ? AND response_sets.completed_at < ?', start_date, end_date).
      where('kases.type = ?','CoachingKase').
      order(:completed_at)

    if params[:governmental_body].present?
      assessments = assessments.where('organizations.parent_id = ?', params[:governmental_body].to_i)
      filename_prefix = Organization.find(params[:governmental_body].to_i).name + ' '
    else
      filename_prefix = ''
    end

    csv = ""
    line_number = 1
    CSV.generate(csv) do |csv|
      csv << [
        'LineNumber',
        'AssessmentRequestID',
        'AssessmentRequestDate',
        'AssessmentDate',
        'PrimeNumber',
        'LastName',
        'FirstName',
        'MiddleInitial',
        'DistrictCenter',
        'AssessmentStatus'
      ]
      assessments.each do |a|
        line_number += 1
        csv << [
          line_number,
          a.kase.assessment_request.id,
          a.kase.assessment_request.created_at.to_date,
          a.completed_at.to_date,
          a.kase.customer.identifier,
          a.kase.customer.last_name,
          a.kase.customer.first_name,
          a.kase.customer.middle_initial,
          a.kase.assessment_request.submitter.organization.name,
          'Completed'
        ]
      end
    end
    send_data csv, type: "text/csv", filename: filename_prefix + "Assessments #{start_date.to_s(:mdy)} to #{(end_date - 1.day).to_s(:mdy)}.csv", disposition: 'attachment'
  end

  def county_authorizations
    start_date = Time.parse(params[:start_date])
    end_date = Time.parse(params[:end_date]) + 1.day

    authorizations = TripAuthorization.accessible_by(current_ability).created_in_range(start_date..end_date).order(:created_at).
      includes(:customer, { assessment_request: :referring_organization })
    if params[:governmental_body].present?
      authorizations = authorizations.for_parent_org(params[:governmental_body].to_i)
      filename_prefix = Organization.find(params[:governmental_body].to_i).name + ' '
    else
      filename_prefix = ''
    end

    csv = ""
    line_number = 1
    CSV.generate(csv) do |csv|
      csv << ['LineNumber',
              'AuthorizationCreatedAt',
              'PrimeNumber',
              'LastName',
              'FirstName',
              'MiddleInitial',
              'AuthorizedTrips',
              'StartDate',
              'EndDate',
              'SpecialInstructions',
              'DistrictCenter']
      authorizations.each do |authorization|
        line_number += 1
        csv << [line_number,
                authorization.created_at,
                authorization.customer.try(:identifier),
                authorization.customer.try(:last_name),
                authorization.customer.try(:first_name),
                authorization.customer.try(:middle_initial),
                authorization.allowed_trips_per_month,
                authorization.start_date,
                authorization.end_date,
                authorization.special_instructions,
                authorization.try(:assessment_request).try(:referring_organization).try(:name)]
      end
    end
    send_data csv, type: "text/csv", filename: filename_prefix + "Authorizations #{start_date.to_s(:mdy)} to #{(end_date - 1.day).to_s(:mdy)}.csv", disposition: 'attachment'
  end

  def current_authorizations
    authorizations = TripAuthorization.distinct.accessible_by(current_ability).active_now.most_recent_in_kase.belongs_to_most_recent_kase_for_customer.
      includes(:customer, { assessment_request: :referring_organization })
    if params[:governmental_body].present?
      authorizations = authorizations.for_parent_org(params[:governmental_body].to_i)
      filename_prefix = Organization.find(params[:governmental_body].to_i).name + ' '
    else
      filename_prefix = ''
    end

    csv = ""
    CSV.generate(csv) do |csv|
      csv << [
        'LastName',
        'FirstName',
        'PrimeNumber',
        'StartDate',
        'EndDate',
        'Agency',
        'AuthorizedTrips'
      ]
      authorizations.sort_by{|x| [x.customer.try(:last_name), x.customer.try(:first_name)]}.each do |authorization|
        csv << [
          authorization.customer.try(:last_name),
          authorization.customer.try(:first_name),
          authorization.customer.try(:identifier),
          authorization.start_date,
          authorization.end_date,
          authorization.try(:assessment_request).try(:referring_organization).try(:name),
          authorization.allowed_trips_per_month
        ]
      end
    end
    send_data csv, type: "text/csv", filename: filename_prefix + "Current Authorizations.csv", disposition: 'attachment'
  end

  private

  def outcomes_row(customer,kase,outcome)
    [customer.name,
    customer.birth_date.try(:to_s),
    customer.ethnicity.try(:name),
    customer.gender,
    kase.open_date,
    kase.assigned_to.try(:display_name),
    kase.referral_source,
    kase.referral_type.try(:name),
    kase.close_date,
    outcome.try(:trip_reason).try(:name),
    outcome.try(:exit_trip_count),
    outcome.try(:exit_vehicle_miles_reduced),
    outcome.try(:three_month_unreachable),
    outcome.try(:three_month_trip_count),
    outcome.try(:three_month_vehicle_miles_reduced),
    outcome.try(:six_month_unreachable),
    outcome.try(:six_month_trip_count),
    outcome.try(:six_month_vehicle_miles_reduced)]
  end

  def kases_csv(kases)
    #csv, one record per case with events in the period
    kases = kases.accessible_by(current_ability).includes({customer: :ethnicity},:assigned_to,:disposition,:referral_type)

    csv = ""
    CSV.generate(csv) do |csv|
      csv << ['First Name',
              'Last Name',
              'Case Type',
              'Open Date',
              'Referral Source',
              'Referral Type',
              'DOB',
              'Ethnicity',
              'Gender',
              'Phone Number 1',
              'Phone Number 2',
              'Email',
              'Address',
              'City',
              'State',
              'Zip',
              'Customer Notes',
              'TriMet Lift Eligibity Status',
              'Household Size',
              'Household Size Alternate Response',
              'Household Income',
              'Household Income Alternate Response',
              'Medicaid Eligible',
              'Assigned To',
              'Close Date',
              'Disposition',
              'Eligible for Ticket Disbursement',
              'Adult Tickets Disbursed',
              'Honored Tickets Disbursed',
              'Access Transit Partner Referred To'
              ]
      for kase in kases
        customer = kase.customer
        csv << [customer.first_name,
                customer.last_name,
                kase.class.humanized_name,
                kase.open_date,
                kase.referral_source,
                kase.referral_type.try(:name),
                customer.birth_date.to_s,
                customer.ethnicity.name,
                customer.gender,
                customer.phone_number_1,
                customer.phone_number_2,
                customer.email,
                customer.address,
                customer.city,
                customer.state,
                customer.zip,
                customer.notes,
                customer.ada_service_eligibility_status.try(:name),
                kase.household_size,
                kase.household_size_alternate_response,
                kase.household_income,
                kase.household_income_alternate_response,
                kase.medicaid_eligible,
                kase.assigned_to.try(:display_name),
                kase.close_date,
                kase.disposition.try(:name),
                (kase.eligible_for_ticket_disbursement ? 'Yes' : 'No'),
                kase.adult_ticket_count,
                kase.honored_ticket_count,
                kase.access_transit_partner_referred_to
                ]
      end
    end
  end
end
