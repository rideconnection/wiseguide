Given /^the customer has a case\-less contact event$/ do
  @contact_event = FactoryGirl.create(:contact, :customer => @customer)
end

Given /^the customer has a contact event associated with an open training case$/ do
  @contact_with_kase = FactoryGirl.create(:contact_with_open_training_kase, :customer => @customer)
  @kase = @contact_with_kase.kase
end

Then /^I should( not)? see the case\-less contact event$/ do |negation|
  assertion = negation ? :should_not : :should
  find('#contacts').send(assertion, have_selector("a.details[href='#{edit_contact_path(@contact_event)}']"))
end

Then /^I should( not)? see the read\-only case\-less contact event$/ do |negation|
  assertion = negation ? :should_not : :should
  find('#contacts').send(assertion, have_selector("a.details[href='#{contact_path(@contact_event)}']"))
end

Then /^I should( not)? see the contact event associated with the case$/ do |negation|
  assertion = negation ? :should_not : :should
  find('#contacts').send(assertion, have_selector("a.details[href='#{edit_contact_path(@contact_with_kase)}']"))
end

Then /^I should( not)? see the read\-only contact event associated with the case$/ do |negation|
  assertion = negation ? :should_not : :should
  find('#contacts').send(assertion, have_selector("a.details[href='#{contact_path(@contact_with_kase)}']"))
end

When /^I click on the link to add a case\-less contact event$/ do
  find("#contacts a.add[href='#{new_contact_path(:customer_id => @customer.id)}']").click
end

When /^I click on the link to add a contact event$/ do
  find("#contacts a.add[href='#{new_contact_path(:kase_id => @kase.id)}']").click
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