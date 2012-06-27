When /^I click (?:on|through to) the organization(?:'s)? (?:profile|link)$/ do
  find("a[href='/organizations/#{@organization.id}']").click
end

Then /^I should( not)? see a button to delete the organization(?:'s)? profile$/ do |negation|
  assertion = negation ? :should_not : :should
  page.should have_content("#{@organization.name}")
  page.send(assertion, have_selector("a[href=\"/organizations/#{@organization.id}\"][data-method=\"delete\"]"))
end


Then /^I should be prompted to confirm the deletion when I click the organization(?:'s)? delete button$/ do
  button = find("a[href=\"/organizations/#{@organization.id}\"][data-method=\"delete\"]")
  button['data-confirm'].should eql("Are you sure?")
  button.click
  popup.confirm
  @confirmation_message = 'Organization was successfully deleted.'
end

Then /^I should( not)?(?: still)? see a link to the organization(?:'s)? profile when I return to the organizations list$/ do |negation|
  assertion = negation ? :should_not : :should
  visit '/organizations'
  page.send(assertion, have_selector("a[href='/organizations/#{@organization.id}']"))
  page.send(assertion, have_content("#{@organization.name}"))
end

Given /^a user exists who belongs to the organization$/ do
  @user = FactoryGirl.create(:user, :organization => @organization)
end
