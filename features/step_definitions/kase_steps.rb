When /^I click the link to add a ([^ ]+) case$/ do |type|
  find("#kases a[href='/cases/new?customer_id=#{@customer.id}&kase[type]=#{type.titlecase}Kase']").click
end

def fill_common_kase_attributes
  # Use 'Yesterday' for the open date so that we can close it 'Today' in other tests
  fill_in "Opened", :with => Date.yesterday.strftime('%Y-%m-%d')
  fill_in "Referral source", :with => "Source"
  select @referral_type.name, :from => "Referral Source Type"
end

def fill_common_open_unassigned_kase_attributes  
  fill_common_kase_attributes
  select "Unassigned", :from => "Assigned to"
  select "In Progress", :from => "Disposition"  
end

Then /^I should be able to create a new open, unassigned coaching case for the customer$/ do
  fill_common_open_unassigned_kase_attributes
  select @case_manager.email, :from => "Case Manager"
  fill_in "Assessment Language", :with => "Pirate"
  fill_in "Assessment Date", :with => Date.yesterday.strftime('%Y-%m-%d')
  click_button "Save"
  # Get the newly generated ID so we can find the record later
  @kase = Kase.find_by_open_date(Date.yesterday.strftime('%Y-%m-%d'))
  @confirmation_message = 'Coaching Case was successfully created.'
  step %Q(I should see a confirmation message)
end

Then /^I should be able to create a new open, unassigned training case for the customer$/ do
  fill_common_open_unassigned_kase_attributes
  select @funding_source.name, :from => "Default Funding Source"
  select Kase::VALID_COUNTIES.keys.first, :from => "County of Service"
  click_button "Save"
  # Get the newly generated ID so we can find the record later
  @kase = Kase.find_by_open_date(Date.yesterday.strftime('%Y-%m-%d'))
  @confirmation_message = 'Training Case was successfully created.'
  step %Q(I should see a confirmation message)
end

Then /^I should( not)? see the case listed when I return to the customer(?:'s) profile$/ do |negation|
  assertion = negation ? :should_not : :should
  visit "/customers/#{@customer.id}"
  selector = "a[href='/cases/#{@kase.id}']"
  page.send(assertion, have_selector("#kases #{selector}"))
  if !negation
    find("#kases #{selector}").should have_content("Details")
    find("#kases").should have_content("#{@kase.open_date}")
  end
end

Then /^I should( not)? see the case listed in the "([^"]*)" section of the (Coaching|Training) Cases page$/ do |negation, section, type|
  assertion = negation ? :should_not : :should
  section.downcase!; section.strip!; section.gsub!(/\s+/, '_')
  visit "/cases/#{type.downcase}"
  selector = "a[href='/cases/#{@kase.id}']"
  page.send(assertion, have_selector("##{section} #{selector}"))
  if !negation
    find("##{section} #{selector}").send(assertion, have_content("#{@kase.customer.last_name}, #{@kase.customer.first_name}"))
  end
end

Given /^an unassigned open training case exists$/ do
  @kase = Factory(:open_training_kase, :assigned_to => nil)
  @customer = @kase.customer
end

When /^I click through to the case details$/ do
  find("a[href='/cases/#{@kase.id}']").click
end

Then /^I should be able to assign the case to myself$/ do
  select @current_user.email, :from => "Assigned to"
  click_button "Save"
  @confirmation_message = 'Case was successfully updated.'
  step %Q(I should see a confirmation message)
end

Then /^I should( not)? see the case listed in the "([^"]*)" sub\-section of the "([^"]*)" section of the (Coaching|Training) Cases page$/ do |negation, sub_section, section, type|
  assertion = negation ? :should_not : :should
  section.downcase!; section.strip!; section.gsub!(/\s+/, '_')
  sub_section.downcase!; sub_section.strip!; sub_section.gsub!(/\s+/, '_')
  visit "/cases/#{type.downcase}"
  selector = "a[href='/cases/#{@kase.id}']"
  page.send(assertion, have_selector("##{section} .#{sub_section} #{selector}"))
  if !negation
    find("##{section} .#{sub_section} #{selector}").send(assertion, have_content("#{@kase.customer.last_name}, #{@kase.customer.first_name}"))
  end
end

Given /^another trainer exists$/ do
  @other_trainer = Factory(:trainer)
end

Then /^I should be able to assign the case to the other trainer$/ do
  select @other_trainer.email, :from => "Assigned to"
  click_button "Save"
  @confirmation_message = 'Case was successfully updated.'
  step %Q(I should see a confirmation message)  
end

Then /^the other trainer should( not)? be listed as the case assignee on the (Coaching|Training) Cases page$/ do |negation, type|
  # This step refers to the Cases page and the "Other Cases" list
  assertion = negation ? :should_not : :should
  visit "/cases/#{type.downcase}"
  selector = "a[href='/cases/#{@kase.id}']"
  find(selector).find(:xpath,".//..").send(assertion, have_content("(#{@other_trainer.email})"))
end

Given /^an open training case exists and is assigned to me$/ do
  @kase = Factory(:open_training_kase, :assigned_to => @current_user)
  @customer = @kase.customer
end

Then /^I should be able to close the case$/ do
  # Close date can't be later than today but must be later than (and not equal to) the open date
  fill_in "Closed", :with => Date.current.strftime('%Y-%m-%d')
  select "Successful", :from => "Disposition"
  click_button "Save"
  @confirmation_message = 'Case was successfully updated.'
  step %Q(I should see a confirmation message)  
end

Then /^I should( not)? see the case listed on the (Coaching|Training) Cases page$/ do |negation, type|
  assertion = negation ? :should_not : :should
  url = "/cases/#{type.downcase}"
  visit url
  selector = "a[href='/cases/#{@kase.id}']"
  page.send(assertion, have_selector(selector))
  if !negation
    find(selector).send(assertion, have_content("#{@kase.customer.last_name}, #{@kase.customer.first_name}"))
  end
end

Then /^I should( not)? see the case listed as "([^"]*)" on the customer(?:'s) profile$/ do |negation, disposition|
  assertion = negation ? :should_not : :should
  visit "/customers/#{@kase.customer.id}"
  selector = "a[href='/cases/#{@kase.id}']"
  find("#kases #{selector}").find(:xpath,".//..//..//td[3]").send(assertion, have_content(disposition))
end

Given /^an open training case exists and is assigned to the other trainer$/ do
  @kase = Factory(:open_training_kase, :assigned_to => @other_trainer)
  @customer = @kase.customer
end

Given /^there is an open training case$/ do
  @kase = Factory(:open_training_kase)
  @customer = @kase.customer
end

Given /^there is an open coaching case$/ do
  @kase = Factory(:open_coaching_kase)
  @customer = @kase.customer
end

Then /^I should( not)? see a button to delete the case$/ do |negation|
  assertion = negation ? :should_not : :should
  selector = "a.delete.kase[href='/cases/#{@kase.id}'][data-method=delete]"
  page.send(assertion, have_selector(selector))
  if !negation
    find(selector)['data-confirm'].should eql("Are you sure you want to delete this case?")
  end
end

Then /^I should be prompted to confirm the deletion when I click the case(?:'s)? delete button$/ do
  button = find("a.delete.kase[href='/cases/#{@kase.id}'][data-method=delete]")
  button['data-confirm'].should eql("Are you sure you want to delete this case?")
  button.click
  page.driver.browser.switch_to.alert.accept
  @confirmation_message = 'Case was successfully deleted.'
  # Don't confirm just yet because we may want to test if it failed (due to permissions)
end

Then /^I should see an error message because I don't have permission to delete the case$/ do
  # page.driver.status_code.should be 403
  page.should have_content("You are not allowed to take the action you requested.")
end

Then /^I should not see any coaching case fields$/ do
  page.should_not have_selector("#kase_case_manager_id")
  page.should_not have_selector("#kase_case_manager_notification_date")
  page.should_not have_selector("#kase_assessment_language")
  page.should_not have_selector("#kase_assessment_date")
  page.should_not have_selector("#kase_medicaid_eligible")
end

Then /^I should not see any training case fields$/ do
  page.should_not have_selector("#kase_county")
  page.should_not have_selector("#kase_funding_source_id")
end
