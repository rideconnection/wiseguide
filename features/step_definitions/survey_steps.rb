Then /^I should be able to paste JSON\-formatted data to create a new survey$/ do
  json_data = JSON.parse(File.read(Rails.root.join("features", "support", "survey_example.json")))
  title = "Survey #{Time.now.to_f.to_s}" # Make it unique so we can find it after
  json_data["title"] = title
  fill_in 'survey', :with => json_data.to_json
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