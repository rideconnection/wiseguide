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

Then /^I should see a confirmation message$/ do
  page.should have_content(@confirmation_message)
end

Then /^show me the page$/ do
  save_and_open_page
end

Then /^I should be on the (.*) page$/ do |page_name|
  object = instance_variable_get("@#{page_name}")
  page.current_path.should == send("#{page_name.downcase.gsub(' ','_')}_path", object)
  page.status_code.should == 200
end

Then /^I should be redirected to the (.*) page$/ do |page_name|
  page.driver.request.env['HTTP_REFERER'].should_not be_nil
  page.driver.request.env['HTTP_REFERER'].should_not == page.current_url
  step %Q(I should be on the #{page_name} page)
end

