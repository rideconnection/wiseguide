Then /^I should see a assessment requests list with (\d+) rows?$/ do |row_count|
  page.should have_selector("#assessment_requests")
  within("#assessment_requests") do
    step %Q(I should see a main section titled "Assessment Requests")
    all("table tbody tr").count.should == row_count.to_i
  end
end

Then /^I should see "([^"]*)" in row (\d+) of the assessment requests list$/ do |value, row|
  within("#assessment_requests table tbody") do
    find(:xpath, ".//tr[#{row.to_i}]").should have_content(value)
  end
end

Then /^I should see a "Details" link in row (\d+) of the assessment requests list that goes to "([^"]*)"$/ do |row, link|
  within("#assessment_requests table tbody") do
    find(:xpath, ".//tr[#{row.to_i}]").should have_selector("a[href='#{link}']", :text => "Details")
  end
end
