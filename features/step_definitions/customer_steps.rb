Then /^I should be able to create a new customer$/ do
  fill_in 'customer[first_name]', with: 'Alex'
  fill_in 'customer[middle_initial]', with: 'A'
  fill_in 'customer[last_name]', with: 'Trebek'
  fill_in 'customer[birth_date]', with: '1962-04-01'
  select 'Male', from: 'customer[gender]'
  select 'Caucasian', from: 'customer[ethnicity_id]'
  fill_in 'customer[phone_number_1]', with: '610-123-4567'
  fill_in 'customer[address]', with: '42 Post Rd'
  fill_in 'customer[city]', with: 'Hollywood'
  fill_in 'customer[state]', with: 'CA'
  fill_in 'customer[zip]', with: '90210'
  select 'Multnomah', from: 'customer[county]'
  click_button 'Save'
  # Get the newly generated customer ID so we can find the record later
  @customer = Customer.find_by_id(find("form.edit_customer")["action"].match(/^\/customers\/(?<id>\d+)$/i)[:id].to_i)
  @confirmation_message = 'Customer was successfully created.'
  step %Q(I should see a confirmation message)
end

Then /^I should be able to modify the customer(?:'s)? profile$/ do 
  fill_in 'customer[address]', with: '123 Hopefully The Factory Isn\'t Using This Address Too Blvd'
  click_button 'Save'
  @confirmation_message = 'Customer was successfully updated.'
  step %Q(I should see a confirmation message)
  page.should have_field('customer[address]', with: '123 Hopefully The Factory Isn\'t Using This Address Too Blvd')
end

Then /^I should( not)? see a button to delete the customer(?:'s)? profile$/ do |negation|
  assertion = negation ? :should_not : :should
  find("a[href='/customers/#{@customer.id}']").should have_content("#{@customer.last_name}, #{@customer.first_name}")
  page.send(assertion, have_selector("form[action='/customers/#{@customer.id}'] input[type=submit][value=Delete]"))
end

Then /^I should be prompted to confirm the deletion when I click the customer(?:'s)? delete button$/ do
  button = find("form[action='/customers/#{@customer.id}'] input[type=submit][value=Delete]")
  button['data-confirm'].should eql("Are you sure you want to delete this user?")
  button.click
  page.driver.browser.switch_to.alert.accept
  @confirmation_message = 'Customer was successfully deleted.'
  step %Q(I should see a confirmation message)
end

Then /^I should( not)? see a link to the customer(?:'s)? profile when I return to the customers list$/ do |negation|
  assertion = negation ? :should_not : :should
  visit '/customers'
  page.send(assertion, have_selector("a[href='/customers/#{@customer.id}']"))
  page.send(assertion, have_content("#{@customer.last_name}, #{@customer.first_name}"))
end

When /^I click (?:on|through to) the customer(?:'s)? (?:profile|link)$/ do
  find("a[href='/customers/#{@customer.id}']").click
end