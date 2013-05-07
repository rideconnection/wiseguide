Given /^there are no assessment requests$/ do
  AssessmentRequest.destroy_all
end

Then /^I should see the following data in the "Assessment Requests" table:$/ do |table|
  check_simple_table_data "#assessment-requests", table
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

When /^I check the "([^"]*)" option in the current status filter form$/ do |option|
  within("#current-status-filters") do
    choose option
  end
end

When /^I check the "([^"]*)" option in the user type filter form$/ do |option|
  within("#user-type-filters") do
    choose option
  end
end

When /^I check the "([^"]*)" option in the assignee filter form$/ do |option|
  within("#assignee-filters") do
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

Then /^I should see a form to filter by assignee$/ do
  page.should have_selector("h2", :text => "Filter Requests")
  page.should have_selector("#assessment-request-filter")
  form = find("#assessment-request-filter")
  page.should have_selector("ul#assignee-filters")
  within("ul#assignee-filters") do
    page.should have_selector("input[type=radio][name=assignee_filter][value=all]")
    page.should have_selector("input[type=radio][name=assignee_filter][value=me]")
  end
end

Then /^I should see an AJAXified form to filter by (.*)$/ do |form|
  step "I should see a form to filter by #{form}"
  within("#assessment-request-filter") do
    page.should have_no_selector("input[type=submit][value=Filter]", :visible => true)
  end
end

When /^I click the request from (.*)$/ do |name|
  tr = find(:xpath, "//td[contains(., \"#{name}\")]/..")
  link = tr.find(:xpath, ".//a")
  link.click
end

When /^I click the customer change link$/ do
  link = find(:xpath, "//a[contains(@href, \"change_customer\")]")
  link.click
end

Then /^I should see an empty list of similar customers$/ do
  page.should have_content("No similar customers found")
end

Then /^I should see an empty list of potential coaching cases$/ do
  page.should have_content("No existing coaching cases found")
end

When /^I click Continue to create a new (?:customer|coaching case)$/ do
  find(:xpath, "//input[@value=\"Continue\"]").click()
end

Then /^I should see the (first|last) name set to (.*)$/ do |kind, name|
  input = find(:xpath, "//input[@id=\"customer_#{kind}_name\"]")
  input[:value].should == name
end

When /^I populate the customer details$/ do
  fill_in('Birth date', :with => '1950-04-01')
  select('Male', :from => 'Gender')
  select('Caucasian', :from => 'Ethnicity')
  fill_in('Address', :with => '72 NPR Way')
  fill_in('City', :with => 'Chicago')
  fill_in('ZIP code', :with => '91234')
  select('Multnomah', :from => 'County')
  click_button('Save')
end

Then /^I should see the request associated with (.*), (.*)$/ do |last, first|
  link = find(:xpath, "//ol[@id=\"customer\"]//a[contains(@href, \"customers\")]")
  link.should have_content("#{last}, #{first}")
end

When /^I populate the coaching case details$/ do
  fill_in('Opened', :with => '2012-05-13')
  fill_in('Referral source', :with => 'daughter')
  select('Friends & Family', :from => 'Referral Source Type')
  fill_in('Household size', :with => '1')
  fill_in('Household income', :with => '1')
  click_button('Save')
  # Get the newly generated ID so we can find the record later
  @kase = CoachingKase.order("id DESC").limit(1).first
end

Then /^I should see a link to the case$/ do
  page.should have_selector("a[href='/cases/#{@kase.id}']", :text => "View Case ##{@kase.id}")
end

Then /^the "([^"]*)" option in the (?:.+) filter form should be selected$/ do |label|
  within("#assessment-request-filter") do
    step %Q(the "#{label}" radio button should be checked)
  end    
end
