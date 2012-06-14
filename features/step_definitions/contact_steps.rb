Then /^I should see a contacts list with (\d+) rows?$/ do |row_count|  
  page.should have_selector("#contacts")
  within("#contacts") do
    step %Q(I should see a main section titled "Contacts")
    all("table tbody tr").count.should == row_count.to_i
  end
end

Then /^I should see "([^"]*)" in row (\d+) of the contacts list$/ do |value, row|
  within("#contacts table tbody") do
    find(:xpath, ".//tr[#{row.to_i}]").should have_content(value)
  end
end

When /^I should not see a link to add a contact event$/ do
  within("#contacts") do
    page.should_not have_selector("a.add")
  end
end

When /^I click on the link to add a contact event$/ do
  find("#contacts a.add").click
end

def fill_common_contact_event_attributes
  fill_in "Date", :with => Time.current
  select 'Phone', :from => "Method"
  fill_in "Description", :with => "My Contact"
  click_button 'Save'
  # Get the newly generated contact ID so we can find the record later
  @contact_event = Contact.last
  @confirmation_message = 'Contact was successfully created.'
end

Then /^I should be able to complete the case\-less contact event form$/ do
  fill_common_contact_event_attributes
end

Then /^I should be able to complete the contact event form$/ do
  fill_common_contact_event_attributes
  @contact_with_kase = @contact_event
end

Then /^the contact method should be "([^"]*)"$/ do |method|
  @contact.method.should == method
end

Then /^the contact user_id should be my user ID$/ do
  @contact.user_id.should == @current_user.id
end

Then /^the contact date should be now$/ do
  current = DateTime.current
  @contact.date_time.strftime("%Y%m%d%H%M%S") =~ /^#{Regexp.quote(current.strftime("%Y%m%d%H"))}(#{Regexp.quote(current.strftime("%M"))}|#{Regexp.quote((current - 1.minute).strftime("%M"))})/
end

Then /^the contact description should be "([^"]*)"$/ do |description|
   @contact.description.should == description
end

Then /^the contact notes should be blank$/ do
  @contact.notes.should be_nil
end