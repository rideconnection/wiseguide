Then /^I should see the following users listed:$/ do |table|
  # Convert all headers to lower case symbol
  table.map_headers! {|header| header.downcase.to_sym }

  within('table#user_management tbody') do 
    table.hashes.each do |row|    
      find('tr', :text => row[:email]).should have_content(row[:name])  
      find('tr', :text => row[:email]).should have_content(row[:role])
    end
  end
end

Then /^I should see a change password link for myself$/ do
  find('tr', :text => @current_user.email).should have_content("Change Password")  
end

Then /^I should not see a change password link for anyone else$/ do
  find('tr', :text => @case_manager.email).should_not have_content("Change Password")
  find('tr', :text => @viewer.email).should_not have_content("Change Password")
  find('tr', :text => @trainer.email).should_not have_content("Change Password")
  find('tr', :text => @admin.email).should_not have_content("Change Password")
end

Then /^my change password link should take me to the change password form$/ do
  find('td', :text => "Change Password").should have_selector("a.change-password[href='#{show_change_password_path}']")
end

Then /^I should( not)? see a "New User" link$/ do |negation|
  assertion = negation ? :should_not : :should
  page.send(assertion, have_selector("a.new-user[href='#{new_user_path}']"))
end

Then /^manually going to the new user page should show me an error$/ do
  visit("#{new_user_path}")
  step %Q(I should be denied access to the page with an error code of 403 and an error message of "You are not allowed to take the action you requested.") 
end

Then /^I should not see a form to change my role$/ do
  find('tr', :text => @current_user.email).should_not have_selector("form.edit_user[action=\"#{update_user_path(:id => @current_user.id)}\"]")
end

Then /^I should not see see a form to change the role of anyone else$/ do
  find('tr', :text => @case_manager.email).should_not have_selector("form.edit_user[action=\"#{update_user_path(:id => @case_manager.id)}\"]")
  find('tr', :text => @viewer.email).should_not have_selector("form.edit_user[action=\"#{update_user_path(:id => @viewer.id)}\"]")
  find('tr', :text => @trainer.email).should_not have_selector("form.edit_user[action=\"#{update_user_path(:id => @trainer.id)}\"]")
  find('tr', :text => @admin.email).should_not have_selector("form.edit_user[action=\"#{update_user_path(:id => @admin.id)}\"]")
end

Then /^the "([^"]*)" link should take me to the new user form$/ do |arg1|
  click_link("New User")
  step %Q(I should be redirected to the new user page)
end

Then /^I should be able to complete the New User form using the following data:$/ do |table|
  table.map_headers! {|header| header.downcase.to_sym }

  row = table.hashes.first
  within('form#new_user') do
    fill_in 'user[first_name]', :with => row[:first_name]
    fill_in 'user[last_name]', :with => row[:last_name]
    fill_in 'user[email]', :with => row[:email]
    select row[:organization], :from => 'user[organization_id]'
    click_button 'Create User'
  end

  # Get the newly generated user ID so we can find the record later
  @user = User.find_by_email(row[:email])
  @confirmation_message = "#{@user.email} has been added and a password has been emailed"
  step %Q(I should see a confirmation message)
end

Then /^"([^"]+)" should receive a welcome email with a link to the application$/ do |email_address|
  unread_emails_for(email_address).size.should == 1

  # this call will store the email and you can access it with current_email
  open_email(email_address)
  current_email.should have_subject("Welcome to Wiseguide")
  current_email.should have_body_text("Hi, #{email_address}")
  current_email.should have_body_text("You can visit the site at<br/> http://www.example.com/")
end

Then /^I should see the new user on the Users index page$/ do
  visit(users_path)
  find('tr', :text => @user.email).should have_content(@user.display_name)  
  # TODO
  # find('tr', :text => @user.email).should have_content(@user.role)
end

Then /^I should see a form to change the admin user's role$/ do
  find('tr', :text => @admin.email).should have_selector("form.edit_user[action=\"#{update_user_path(:id => @admin.id)}\"]")
end

Then /^I should be able to change the admin user's role to "Viewer"$/ do
  within("form.edit_user[action=\"#{update_user_path(:id => @admin.id)}\"]") do
    select "Viewer", :from => "user[level]"
    click_button 'Change role'
  end
  
  @confirmation_message = "#{@admin.email}'s role has been changed"
  step %Q(I should see a confirmation message)
end

Then /^I should see the admin user role listed as "([^"]+)" on the Users index page$/ do |role|
  find('tr', :text => @admin.email).should have_content(@admin.display_name)  
  find('tr', :text => @admin.email).should have_content(role)
end

Then /^I should see a button to mark the admin user as deleted$/ do
  page.should have_selector("form.button_to[action=\"#{user_path(:id => @admin.id)}\"][method=post] input.delete")
end

Then /^I should be able to click the button to delete the admin user$/ do
  within("form.button_to[action=\"#{user_path(:id => @admin.id)}\"][method=post]") do
    button = find("input.delete")
    button['data-confirm'].should eql("Are you sure you want to mark this user as deleted?")
    button['value'].should eql("Delete")
    button.click
  end
  
  @confirmation_message = "User #{@admin.email} successfully marked deleted."
  page.driver.browser.switch_to.alert.accept
  step %Q(I should see a confirmation message)
end

Then /^I should be prompted to confirm the deletion of the admin user$/ do
  # no-op - for documentation purposes only
end
