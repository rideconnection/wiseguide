Given /^I am logged in as a (.*)$/ do |user_type|
  @user = User.find_by_email("#{user_type}@rideconnection.org")
  visit '/users/sign_in'
  fill_in 'user_email', :with => @user.email
  fill_in 'user_password', :with => 'password'
  click_button 'Sign in'
  page.should have_content('Signed in successfully.')
end

When /^I go to the homepage$/ do
  visit('/')
end

When /^I go to the Customers page$/ do
  click_link 'Customers'
end

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
  page.should have_content('Customer was successfully created.')
end

When /^I should be able to edit the customer profile for "(\w+) (\w+)"$/ do |first_name, last_name|
  click_link "#{last_name}, #{first_name}"
  fill_in 'customer[address]', :with => '123 Hopefully The Factory Isn\'t Using This Address Too Blvd'
  click_button 'Save'
  page.should have_content('Customer was successfully updated.')
  page.has_field?('customer[address]', :with => '123 Hopefully The Factory Isn\'t Using This Address Too Blvd')
end

Then /^show me the page$/ do
  save_and_open_page
end
