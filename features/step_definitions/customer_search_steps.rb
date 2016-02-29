When /^I enter "([^"]*)" into the search box$/ do |term|
  within("#customer_search_form") do
    fill_in "Filter by Name", with: term
  end
end

When /^I click the "Search" button in the customer search form$/ do
  within("#customer_search_form") do
    click_button "Search"
  end
end

When /^I fill in something close to Carl's name$/ do
  fill_in 'customer[first_name]', with: 'carl'
  fill_in 'customer[last_name]', with: 'bobsons'
  fill_in 'customer[middle_initial]', with: " "
end

Then /^I should see the following customers in the customers table:$/ do |table|
  check_simple_table_data "#customers", table
end
