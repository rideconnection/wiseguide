def login_user(user)
  visit '/users/sign_in'
  fill_in 'user_email', :with => user.email
  fill_in 'user_password', :with => 'password 1'
  click_button 'Sign in'
  page.should have_content('Signed in successfully.')
end

Given /^I am logged in as an? (.*)$/ do |user_type|
  @current_user = FactoryGirl.create(user_type.split(" ").join("_"))
  login_user(@current_user)
end

Given /^I am logged in as the following (.*):$/ do |user_type, table|
  @current_user = FactoryGirl.create(user_type.split(" ").join("_"), table.hashes.first)
  login_user(@current_user)
end

Given /^I belong to organization ([0-9]+)$/ do |organization_id|
  @current_user.organization_id = organization_id
  @current_user.save!
  @current_user.reload
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

Then /^I should( not)? see a confirmation message$/ do |negation|
  step %Q(I should#{negation ? " not" : ""} see the notice "#{@confirmation_message}")
end

Then /^I should( not)? see the notice "([^"]*)"$/ do |negation, message|
  assertion = negation ? :should_not : :should
  page.send(assertion, have_selector("#flash .info", :text => message))
end

Then /^I should( not)? see the confirmation message "([^"]*)"$/ do |negation, confirmation_message|
  step %Q(I should#{negation ? " not" : ""} see the notice "#{confirmation_message}")
end

Then /^I should( not)? see the error message "([^"]*)"$/ do |negation, error_message|
  step %Q(I should#{negation ? " not" : ""} see the notice "#{error_message}")
end

Then /^show me the page$/ do
  save_and_open_page
end

When /^I reload the page$/ do
  visit(current_path)
end

Then /^I should be redirected to the (.*) page$/ do |page_name|
  page.driver.request.env['HTTP_REFERER'].should_not be_nil
  page.driver.request.env['HTTP_REFERER'].should_not == page.current_url
  object = instance_variable_get("@#{page_name.gsub(' ','_')}")
  path = send("#{page_name.downcase.gsub(' ','_')}_path", object)
  step %Q(I should be redirected to "#{path[1, path.length]}")
end

Then /^I should be redirected to "([^"]*)"$/ do |route|
  page.status_code.should == 200
  page.driver.request.env['HTTP_REFERER'].should_not be_nil
  page.driver.request.env['HTTP_REFERER'].should_not == page.current_url
  page.current_path.should == "/#{route}"
end

Then /^I should be denied access to the page with an error code of ([0-9]+) and an error message of "(.*)"$/ do |error_code, error_message|
  page.status_code.should == error_code.to_i
  page.should have_content(error_message)
end

def check_simple_table_data(table_selector, table_data, options = {})
  options.reverse_merge!(:headers => true)
    
  page.should have_selector(table_selector)
  within(table_selector) do
    if !options[:headers]
      header_map = (0...table_data.rows.first.length).to_a
      row_count = table_data.raw.length
      table_rows = table_data.raw
    else
      header_map = []
      row_count = table_data.raw.length - 1
      within("thead tr:first") do
        columns = all("th").collect{ |column| column.text.downcase.strip }
        columns.size.should >= table_data.headers.size
      
        table_data.headers.each_with_index do |header, index|
          column = columns.index(header.downcase.strip)
          column.should_not be_nil
          header_map << column
        end        
      end
      table_rows = table_data.raw[1...table_data.raw.length]
    end
  
    within("tbody") do
      all("tr").size.should == row_count
      
      xpath_base = './/tr[%i]/td[%i]';
      table_rows.each_with_index do |row, index|
        row.each_with_index do |value, column|
          find(:xpath, xpath_base % [index + 1, header_map[column] + 1]).should have_content(value)
        end
      end
    end
  end
end

Then /^I should see a(?:n)? "([^"]*)" checkbox$/ do |label|
  page.should have_field(label, :type => "checkbox")
end

Then /^I should( not)? see a(?:n)? "([^"]*)" button$/ do |negation, label|
  assertion = negation ? :should_not : :should
  page.send(assertion, have_button(label))
end

When /^I (un)?check the "([^"]*)" checkbox$/ do |checked_state, label|
  checked_state = (checked_state) ? "uncheck" : "check"
  page.send(checked_state, label)
end

Then /^the "([^"]*)" (?:checkbox|radio button) should be (un)?checked$/ do |label, checked_state|
  checked_state = (checked_state) ? "has_unchecked_field?" : "has_checked_field?"
  page.send(checked_state, label)
end

When /^I click the "([^"]*)" button$/ do |label|
  click_button label
end

When /^I save the form$/ do
  click_button "Save"
end

Then /^I should( not)? see a main section titled "([^"]*)"$/ do |negation, title|
  assertion = negation ? :should_not : :should
  page.send(assertion, have_selector("h1", :text => title))
end

Then /^I should( not)? see a secondary section titled "([^"]*)"$/ do |negation, title|
  assertion = negation ? :should_not : :should
  page.send(assertion, have_selector("h2", :text => title))
end

Then /^I should( not)? see "([^"]*)"$/ do |negation, content|
  assertion = (negation) ? :should_not : :should
  page.send(assertion, have_content(content))
end

Then /^start the debugger$/ do
  debugger
end
