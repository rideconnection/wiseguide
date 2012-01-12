When /^I click the link to add a case$/ do
  find("#kases a[href='/cases/new?customer_id=#{@customer.id}']").click
end

Then /^I should be able to create a new open, unassigned case for the customer$/ do
  # Use 'Yesterday' for the open date so that we can close it 'Today' in other tests
  fill_in "Opened", :with => Date.yesterday.strftime('%Y-%m-%d')
  fill_in "Referral source", :with => "Source"
  select @referral_type.name, :from => "Referral Source Type"
  select @funding_source.name, :from => "Default Funding Source"
  select "Unassigned", :from => "Assigned to"
  select "In Progress", :from => "Disposition"
  select Kase::VALID_COUNTIES.keys.first, :from => "County of Service"
  click_button "Save"
  # Get the newly generated ID so we can find the record later
  @kase = Kase.find_by_open_date(Date.yesterday.strftime('%Y-%m-%d'))
  @confirmation_message = 'Case was successfully created.'
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

Then /^I should( not)? see the case listed in the "([^"]*)" section of the Cases page$/ do |negation, section|
  assertion = negation ? :should_not : :should
  section.downcase!; section.strip!; section.gsub!(/\s+/, '_')
  visit "/cases"
  selector = "a[href='/cases/#{@kase.id}']"
  page.send(assertion, have_selector("##{section} #{selector}"))
  if !negation
    find("##{section} #{selector}").send(assertion, have_content("#{@kase.customer.last_name}, #{@kase.customer.first_name}"))
  end
end

Given /^an unassigned open case exists$/ do
  @kase = Factory(:open_kase, :assigned_to => nil)
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

Then /^I should( not)? see the case listed in the "([^"]*)" sub\-section of the "([^"]*)" section of the Cases page$/ do |negation, sub_section, section|
  assertion = negation ? :should_not : :should
  section.downcase!; section.strip!; section.gsub!(/\s+/, '_')
  sub_section.downcase!; sub_section.strip!; sub_section.gsub!(/\s+/, '_')
  visit "/cases"
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

Then /^the other trainer should( not)? be listed as the case assignee$/ do |negation|
  # This step refers to the Cases page and the "Other Cases" list
  assertion = negation ? :should_not : :should
  visit "/cases"
  selector = "a[href='/cases/#{@kase.id}']"
  find(selector).find(:xpath,".//..").send(assertion, have_content("(#{@other_trainer.email})"))
end

Given /^an open case exists and is assigned to me$/ do
  @kase = Factory(:open_kase, :assigned_to => @current_user)
  @customer = @kase.customer
end

Then /^I should be able to close the case$/ do
  # Close date can't be later than today but must be later than (and not equal to) the open date
  fill_in "Closed", :with => Date.today.strftime('%Y-%m-%d')
  select "Successful", :from => "Disposition"
  click_button "Save"
  @confirmation_message = 'Case was successfully updated.'
  step %Q(I should see a confirmation message)  
end

Then /^I should( not)? see the case listed on the Cases page$/ do |negation|
  assertion = negation ? :should_not : :should
  visit "/cases"
  selector = "a[href='/cases/#{@kase.id}']"
  page.send(assertion, have_selector(selector))
  if !negation
    find(selector).send(assertion, have_content("#{@kase.customer.last_name}, #{@kase.customer.first_name}"))
  end
end

Then /^I should( not)? see the case listed as "([^"]*)" on the case(?:'s) customer(?:'s) profile$/ do |negation, disposition|
  assertion = negation ? :should_not : :should
  visit "/customers/#{@kase.customer.id}"
  selector = "a[href='/cases/#{@kase.id}']"
  find("#kases #{selector}").find(:xpath,".//..//..//td[2]").send(assertion, have_content(disposition))
end

Given /^an open case exists and is assigned to the other trainer$/ do
  @kase = Factory(:open_kase, :assigned_to => @other_trainer)
  @customer = @kase.customer
end

Given /^an open case exists$/ do
  @kase = Factory(:open_kase)
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
