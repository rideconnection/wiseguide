Given /^I am logged in as a (.*)$/ do |user_type|
  @user = User.find_by_email("#{user_type}@rideconnection.org")
  visit '/logout'
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

Then /^show me the page$/ do
  save_and_open_page
end
