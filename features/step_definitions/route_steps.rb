When /^I click the link to add a trained route$/ do
  find("#trained_routes a[href='/cases/add_route?kase_id=#{@kase.id}']").click
end

Then /^I should be able to add a trained route using the AJAX form$/ do
  page.should have_selector("#new_route_form", visible: true)
  within("#new_route_form") do
    select @route.name, from: "kase_route_route_id"
    click_button "Add route"
  end
  find("#routes").has_content?(@route.name)
  # No confirmation message is displayed by this action
end

Then /^I should( not)? see the trained route under the Routes Trained section of the case profile$/ do |negation|
  selector_assertion = negation ? :have_no_selector : :have_selector
  content_assertion = negation ? :have_no_content : :have_content
  within "#routes", visible: !negation do
    should send(content_assertion, @route.name)
    should send(selector_assertion, "a[href='/cases/delete_route?kase_id=#{@kase.id}&route_id=#{@route.id}']")
  end
end

Given /^a trained route exists for the existing case$/ do
  @route = FactoryGirl.create(:route)
  @kase.routes << @route
end

Then /^I should see a button to delete the trained route$/ do
  button = find("#routes a[href='/cases/delete_route?kase_id=#{@kase.id}&route_id=#{@route.id}']")
  button['data-method'].should eql("post")
  button['data-remote'].should eql("true")
  button['data-confirm'].should eql("Are you sure?")
end

Then /^I should be prompted to confirm the deletion when I click the trained routes's delete button$/ do
  selector = "#routes a[href='/cases/delete_route?kase_id=#{@kase.id}&route_id=#{@route.id}'][data-method=post]"
  button = find(selector)
  button['data-confirm'].should eql("Are you sure?")
  button.click
  page.driver.browser.switch_to.alert.accept
  page.has_no_selector?(selector)
  # No confirmation message is displayed by this action
end

Then /^I should be able to add a new route$/ do
  fill_in "Name", with: "My New Route"
  click_button "Create Route"
  # Get the newly generated ID so we can find the record later
  @route = Route.find_by_name("My New Route")
  @confirmation_message = 'Route was successfully created.'
  step %Q(I should see a confirmation message)
end

Then /^I should( not)? see the route on the routes page$/ do |negation|
  selector_assertion = negation ? :have_no_selector : :have_selector
  content_assertion = negation ? :have_no_content : :have_content
  visit "/routes"
  selector = "a[href='/routes/#{@route.id}']"
  page.should send(selector_assertion, selector, {text: "Show"})
  page.should send(selector_assertion, "a[href='/routes/#{@route.id}/edit']", {text: "Edit"})
  if negation
    page.should send(content_assertion, @route.name)
  else
    first(selector).find(:xpath, "../../td[1]").should send(content_assertion, @route.name)
  end
end

Then /^I click through to the route details$/ do
  find("a[href='/routes/#{@route.id}/edit']", text: "Edit").click
end

Then /^I should be able to edit the route$/ do
  fill_in "Name", with: "#{@route.name} and More!"
  click_button "Update Route"
  @route.reload
  @confirmation_message = 'Route was successfully updated.'
  step %Q(I should see a confirmation message)
end

Then /^I should see a button to delete the route$/ do
  button = find("a[href='/routes/#{@route.id}']", text: "Destroy")
  button['data-method'].should eql("delete")
  button['data-confirm'].should eql("Are you sure?")
end

Then /^I should be prompted to confirm the deletion when I click the routes's delete button$/ do
  selector = "a[href='/routes/#{@route.id}'][data-method=delete]"
  button = find(selector)
  button['data-confirm'].should eql("Are you sure?")
  button.click
  page.driver.browser.switch_to.alert.accept
  page.has_no_selector?(selector)
  # No confirmation message is displayed by this action
end
