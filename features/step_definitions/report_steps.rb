When /^I submit the "Monthly Transportation Report" form with a date range of "([^"]*)" to "([^"]*)"$/ do |start_date, end_date|
  within('#monthly_transportation') do
    fill_in "start_date", :with => start_date
    fill_in "end_date", :with => end_date
    click_button "Report"
  end
end

Then /^I should see the following report:$/ do |table|  
  # | Customer Name | Referral Date | First Contact | Assessment Date | CMO Notified |  
  # Convert all headers to lower case symbol
  table.map_headers! {|header| header.downcase.to_sym }

  table.hashes.each_with_index do |row, index|
    xpath_base = '//table[@id="monthly_transportation"]/tbody/tr[%i]/td[%i]';
    row.keys.each_with_index do |key, index_2|
      find(:xpath, xpath_base % [index + 1, index_2 + 1]).should have_content(row[key])
    end
  end
end
