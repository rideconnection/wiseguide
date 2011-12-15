Given /^I am logged in as "(.*)"$/ do |email|
  @user = User.find_by_email(email)
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

When /^I click "New Customer"$/ do
  click_link 'New Customer'
end

When /^I fill in customer Alex Trebek$/ do
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
end

Then /^I should see "([^"]*)"$/ do |arg1|
  page.should have_content(arg1)
end

Then /^show me the page$/ do
  save_and_open_page
end
