When /^I click on the link to create a new referral document$/ do
  find("#referral_documents a[href='/referral_documents/new?kase_id=#{@kase.id}']").click
end

Then /^I should be able to complete the referral document form$/ do
  select @resource.name, from: "Add resource"
  fill_in "Resource note", with: "Overnumerousness"
  click_button "Save"
  
  # Get the newly generated ID so we can find the record later
  @referral_document = ReferralDocument.last
  @confirmation_message = 'Referral document was successfully created.'
  step %Q(I should see a confirmation message)
end

Then /^I should( not)? see the referral document under the Referral Documents section of the case profile$/ do |negation|
  selector_assertion = negation ? :have_no_selector : :have_selector
  content_assertion = negation ? :have_no_content : :have_content
  find("#referral_documents").should send(content_assertion, @referral_document.created_at.strftime("%Y-%m-%d"))
  find("#referral_documents").should send(selector_assertion, "a[href='/referral_documents/#{@referral_document.id}/edit']")
end

Given /^a referral document exists for the existing case$/ do
  @referral_document = FactoryGirl.create(:referral_document, kase: @kase)
end

When /^I click on the link to edit the referral document$/ do
  find("#referral_documents a[href='/referral_documents/#{@referral_document.id}/edit']").click
end

Then /^I should be able to add a new resource to the referral document form$/ do  
  click_link "Add Resource"
  within(all("fieldset p.fields").last) do
    select @resource.name, from: "Add resource"
    fill_in "Resource note", with: "Tnetennba"
  end
  click_button "Save"
  @confirmation_message = 'Referral document was successfully updated.'
  step %Q(I should see a confirmation message)
end

Then /^I should see the new resource listed when I click on the referral document details link$/ do
  first("#referral_documents a[href='/referral_documents/#{@referral_document.id}']").click
  page.all('#main ol li').count.should eq(2)
  page.should have_content("Sweet Resource")
  page.should have_content("Tnetennba")
end

Then /^I should not see the new resource listed when I click on the referral document details link$/ do
  first("#referral_documents a[href='/referral_documents/#{@referral_document.id}']").click
  page.all('#main ol li').count.should eq(1)
  page.should_not have_content("Sweet Resource")
end

Given /^the resource is assigned to the referral document as a second resource$/ do
  @referral_document.referral_document_resources.create(resource: @resource)
end

Then /^I should be able to delete the second resource$/ do
  within(all("fieldset p.fields").last) do
    click_link "Remove resource"
  end
  click_button "Save"
  @confirmation_message = 'Referral document was successfully updated.'
  step %Q(I should see a confirmation message)
end

Then /^I should( not)? see a button to delete the referral document$/ do |negation|
 assertion = negation ? :should_not : :should
 selector = "#referral_documents a.delete[href='/referral_documents/#{@referral_document.id}'][data-method=delete]"
 page.send(assertion, have_selector(selector))
 if !negation
   find(selector)['data-confirm'].should eql("Are you sure you want to delete this referral document?")
 end
end

Then /^I should be prompted to confirm the deletion when I click the referral document(?:'s) delete button$/ do
  button = find("#referral_documents a.delete[href='/referral_documents/#{@referral_document.id}'][data-method=delete]")
  button['data-confirm'].should eql("Are you sure you want to delete this referral document?")
  button.click
  page.driver.browser.switch_to.alert.accept
  @confirmation_message = 'Referral document was successfully deleted.'
  # Don't confirm just yet because we may want to test if it failed (due to permissions)
end

Then /^I should see an error message because I don't have permission to delete the referral document$/ do
  # page.driver.status_code.should be 403
  page.should have_content("You are not allowed to take the action you requested.")
end

Then /^I should( not)? see the referral document listed when I return to the case(?:'s)? profile$/ do |negation|
  assertion = negation ? :should_not : :should
  visit "/cases/#{@referral_document.kase.id}"
  selector = "#referral_documents a[href='/referral_documents/#{@referral_document.id}']"
  page.send(assertion, have_selector(selector))
end
