Given /^the case has one assessment$/ do
  @assessment = FactoryGirl.create(:response_set, :kase => @kase, :user => @current_user)
end

Then /^I should( not)? see a link to add a new assessment$/ do |negation|
  assertion = negation ? :should_not : :should
  selector = "a[href='/kases/#{@kase.id}/surveys/']"
  page.send(assertion, have_selector(selector))
end
