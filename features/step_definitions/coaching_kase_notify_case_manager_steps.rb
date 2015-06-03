Then /^I should see today's date in the Case Manager Notification Date field$/ do
  within(:xpath, '//label[@for="kase_case_manager_notification_date"]/..') do
    page.should have_content(Date.current.strftime("%v"))
  end
end

Then /^I should see "Not notified yet" in the Case Manager Notification Date field$/ do
  within(:xpath, '//label[@for="kase_case_manager_notification_date"]/..') do
    page.should have_content("Not notified yet")
  end
end

When /^they should see a link to the case URL in the email body$/ do
  kase_url = kase_url(:id=>@kase.id)
  open_last_email_for(last_email_address)
  current_email.should have_body_text("Case URL: <a href=\"#{kase_url}\">#{kase_url}</a>")
end

When /^I change the Case Manager to "([^"]*)"$/ do |email|
  select email, :from => "Case Manager"
end

Then /^I should see a javascript confirmation dialog asking "([^"]*)"$/ do |message|
  page.driver.browser.switch_to.alert.text.should include(message)
end

When /^I accept the confirmation dialog$/ do
  page.driver.browser.switch_to.alert.accept
end

When /^I cancel the confirmation dialog$/ do
  page.driver.browser.switch_to.alert.dismiss
end

Then /^the Case Manager should be set to "([^"]*)"$/ do |option|
  page.has_select?('Case Manager', :selected => option)
end
