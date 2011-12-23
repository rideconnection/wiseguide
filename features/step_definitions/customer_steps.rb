When /^I should be able to create a new customer$/ do
  click_link 'New Customer'
  fill_in 'customer[first_name]', :with => 'Alex'
  fill_in 'customer[last_name]', :with => 'Trebek'
  fill_in 'customer[birth_date]', :with => '1962-04-01'
  select 'Male', :from => 'customer[gender]'
  select 'Caucasian', :from => 'customer[ethnicity_id]'
  fill_in 'customer[phone_number_1]', :with => '610-123-4567'
  fill_in 'customer[address]', :with => '42 Post Rd'
  fill_in 'customer[city]', :with => 'Hollywood'
  fill_in 'customer[state]', :with => 'CA'
  fill_in 'customer[zip]', :with => '90210'
  select 'Multnomah', :from => 'customer[county]'
  click_button 'Save'
  page.should have_text('Customer was successfully created.')
end

When /^I should be able to edit the customer profile for "(\w+) (\w+)"$/ do |first_name, last_name|
  click_link "#{last_name}, #{first_name}"
  fill_in 'customer[address]', :with => '123 Hopefully The Factory Isn\'t Using This Address Too Blvd'
  click_button 'Save'
  page.should have_text('Customer was successfully updated.')
  page.has_field?('customer[address]', :with => '123 Hopefully The Factory Isn\'t Using This Address Too Blvd')
end

# We need to be able to specify the email address so that we can 
# lookup the customer record by a unique value in order to get the 
# customer ID in order to find the correct form within the customer
# list table. Complicated, I know, but better than hacking up the 
# table HTML with superfluous identifiers just for this test.
When /^I should not be able to delete the customer profile for "(\w+) (\w+)" with email "(.*)"$/ do |first_name, last_name, email|
  customer = Customer.find_by_email(email)
  find("a[href='/customers/#{customer.id}']").should have_content("#{last_name}, #{first_name}")
  page.should have_no_selector("form[action='/customers/#{customer.id}'] input[type=submit][value=Delete]")
end

When /^I should be able to delete the customer profile for "(\w+) (\w+)" with email "(.*)"$/ do |first_name, last_name, email|
  pending
end
