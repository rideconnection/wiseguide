require 'survey_creator'

Then /^I should be able to paste JSON\-formatted data to create a new survey$/ do
  json_data = JSON.parse(File.read(Rails.root.join("features", "support", "survey_example.json")))
  title = "Survey #{Time.current.to_f.to_s}" # Make it unique so we can find it after
  json_data["title"] = title
  fill_in 'survey', with: json_data.to_json
  click_button 'Create'
  # Get the newly generated ID so we can find the record later
  @survey = Survey.find_by_title(title)
  @confirmation_message = 'Survey was successfully created.'
  step %Q(I should see a confirmation message)
end

Then /^I should( not)? see the survey listed when I return to the surveys list$/ do |negation|
  assertion = negation ? :should_not : :should
  visit '/surveys'
  page.send(assertion, have_content("#{@survey.title}"))
end

Given /^a simple survey exists$/ do
  json_data = JSON.parse(File.read(Rails.root.join("features", "support", "survey_example.json")))
  @survey = SurveyCreator.create_survey(json_data)
end

When /^I click the link to add an assessment$/ do
  find("#surveys").click_link("Add")
end

Then /^I click the button for the open survey$/ do
  find("form[action='/kases/#{@kase.id}/surveys/#{@survey.access_code}']").click_button("Assess")
end

Then /^I should be able to complete the survey form$/ do
  # None of these fields are required but we may as well excercise the form
  # builder while we are at it.
  within_fieldset("1) Responses Given By") do
    check "Individual"
  end
  within_fieldset("2) Emergency Contacts") do
    fill_in 'Name', with: 'Bob'
    fill_in 'Relationship', with: 'Uncle'
    fill_in 'Phone', with: '555-555-5555'
  end
  within_fieldset("3) Do you keep a piece of identification listing your address and phone number with you at all times?") do
    choose "Yes"
  end
  within_fieldset("4) Background Information") do
    within_fieldset("Have you ridden the bus or MAX before?") do
      choose "Yes"
    end
    # Skip nameless text areas
  end
  # Skip section 5 since it would be too difficult to target the radio buttons
  # in the table.
  click_button "Click here to finish"
  @confirmation_message = 'Completed survey'
  step %Q(I should see a confirmation message)
end

Then /^I should( not)? see the survey listed when I return to the case page$/ do |negation|
  assertion = negation ? :should_not : :should
  visit "/cases/#{@kase.id}"
  page.send(assertion, have_content("#{@survey.title}"))
end
