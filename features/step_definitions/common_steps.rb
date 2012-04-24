Given /^I am logged in as an? (.*)$/ do |user_type|
  @current_user = FactoryGirl.create(user_type.split(" ").join("_"))
  visit '/users/sign_in'
  fill_in 'user_email', :with => @current_user.email
  fill_in 'user_password', :with => 'password 1'
  click_button 'Sign in'
  page.should have_content('Signed in successfully.')
end

Given /^my name is "([^"]+)"$/ do |name|
  first_name, last_name = name.strip.split(/\W+/)
  @current_user.first_name = first_name
  @current_user.last_name = last_name
  @current_user.save!
  @current_user.reload
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

Then /^I should see a confirmation message$/ do
  page.should have_content(@confirmation_message)
end

Then /^I should see the error message "(.*)"$/ do |error_message|
  page.should have_content(error_message)
end

Then /^show me the page$/ do
  save_and_open_page
end

Then /^I should be on the (.*) page$/ do |page_name|
  object = instance_variable_get("@#{page_name.gsub(' ','_')}")
  page.current_path.should == send("#{page_name.downcase.gsub(' ','_')}_path", object)
  page.status_code.should == 200
end

Then /^I should be redirected to the (.*) page$/ do |page_name|
  page.driver.request.env['HTTP_REFERER'].should_not be_nil
  page.driver.request.env['HTTP_REFERER'].should_not == page.current_url
  step %Q(I should be on the #{page_name} page)
end

Then /^I should be denied access to the page with an error code of ([0-9]+) and an error message of "(.*)"$/ do |error_code, error_message|
  page.status_code.should == error_code.to_i
  page.should have_content(error_message)
end

def check_simple_table_data (table_id, table)
  within("table#%s" % table_id) do
    header_map = []
    within("thead tr:first") do
      columns = all("th").collect{ |column| column.text.downcase.strip }
      columns.size.should >= table.headers.size
      
      table.headers.each_with_index do |header, index|
        column = columns.index(header.downcase.strip)
        column.should_not be_nil
        header_map << column
      end        
    end
  
    within("tbody" % table_id) do
      all("tr").size.should == table.rows.size
      
      xpath_base = './/tr[%i]/td[%i]';
      table.hashes.each_with_index do |row, index|
        row.values.each_with_index do |value, column|
          find(:xpath, xpath_base % [index + 1, header_map[column] + 1]).should have_content(value)
        end
      end
    end
  end
end