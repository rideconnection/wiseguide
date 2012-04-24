Given /^the case has one assessment$/ do
  @assessment = FactoryGirl.create(:response_set, :kase => @kase, :user => @current_user)
end

Then /^I should( not)? see a link to add a new assessment$/ do |negation|
  assertion = negation ? :should_not : :should
  selector = "a[href='/surveys/new?kase_id=#{@kase.id}']"
  page.send(assertion, have_selector(selector))
end
