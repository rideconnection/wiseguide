Given /^there are no assessment requests$/ do
  AssessmentRequest.destroy_all
end

Then /^I should see the following data in the "Assessment Requests" table:$/ do |table|
  check_simple_table_data "assessment-requests", table
end

Given /^the following assessment requests exist that belong to me:$/ do |table|
  table.map_headers! { |header| header.downcase.to_sym }
  table.hashes.each do |row, index|
    FactoryGirl.create(:assessment_request, row.merge({:submitter => @current_user}))
  end
end

Then /^I should see a form to filter by user type$/ do
  page.should have_selector("h2", :text => "Filter Requests")
  page.should have_selector("#assessment-request-filter")
  form = find("#assessment-request-filter")
  page.should have_selector("ul#user-type-filters")
  within("ul#user-type-filters") do
    page.should have_selector("input[type=radio][name=user_type_filter][value=all]")
    page.should have_selector("input[type=radio][name=user_type_filter][value=mine]")
    page.should have_selector("input[type=radio][name=user_type_filter][value=my_organization]")
    page.should have_selector("input[type=radio][name=user_type_filter][value=outside_users]")
  end
end

When /^I check the "([^"]*)" option in the (?:.+) filter form$/ do |option|
  within("#assessment-request-filter") do
    choose option
  end    
end

When /^I click the "Filter" button to apply filter$/ do
  within("#assessment-request-filter") do
    click_button "Filter"
  end
end

When /^the filter should apply and the table data should refresh without having to click the "Filter" button$/ do
  # no-op
end

Then /^I should see a form to filter by current status$/ do
  page.should have_selector("h2", :text => "Filter Requests")
  page.should have_selector("#assessment-request-filter")
  form = find("#assessment-request-filter")
  page.should have_selector("ul#current-status-filters")
  within("ul#current-status-filters") do
    page.should have_selector("input[type=radio][name=current_status_filter][value=all]")
    page.should have_selector("input[type=radio][name=current_status_filter][value=pending]")
    page.should have_selector("input[type=radio][name=current_status_filter][value=not_completed]")
    page.should have_selector("input[type=radio][name=current_status_filter][value=completed]")
  end
end

Then /^I should see an AJAXified form to filter by (.*)$/ do |form|
  step "I should see a form to filter by #{form}"
  within("#assessment-request-filter") do
    page.should have_no_selector("input[type=submit][value=Filter]", :visible => true)
  end
end
