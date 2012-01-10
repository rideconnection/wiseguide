Given /^I am logged in as an? (trainer|admin)$/ do |user_type|
  @current_user = Factory(user_type)
  visit '/users/sign_in'
  fill_in 'user_email', :with => @current_user.email
  fill_in 'user_password', :with => 'password'
  click_button 'Sign in'
  page.should have_content('Signed in successfully.')
end

Given /^I (?:go to|visit|am on) the homepage$/ do
  visit('/')
end

Given /^I (?:go to|visit|am on) the (.*) page$/ do |route|
  visit("/#{route}")
end

When /^I click on the "([^"]+)" link$/ do |link|
  click_link link
end

When /^I click (?:on|through to) the customer(?:'s)? (?:profile|link)$/ do
  find("a[href='/customers/#{@customer.id}']").click
end

Then /^I should see a confirmation message$/ do
  page.should have_content(@confirmation_message)
end

Then /^show me the page$/ do
  save_and_open_page
end
