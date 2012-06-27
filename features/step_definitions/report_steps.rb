When /^I submit the "Monthly Transportation Report" form with a date range of "([^"]*)" to "([^"]*)"$/ do |start_date, end_date|
  fill_in_date_range "monthly_transportation", start_date, end_date
end

Then /^I should see the following report in the "Monthly Transportation Report" table:$/ do |table|
  check_simple_table_data "#monthly_transportation", table
end

Given /^the following referral document associations exist:$/ do |table|
  # | id | kase_id | resource_ids |  
  # Convert all headers to lower case symbol
  table.map_headers! {|header| header.downcase.to_sym }

  table.hashes.each_with_index do |row, index|
    doc = FactoryGirl.build(:referral_document_prototype, :id => row[:id], :kase_id => row[:kase_id])
    resources = row[:resource_ids].split(',').map{|id| id.strip.to_i }
    resources.each do |resource_id|
      doc.referral_document_resources << FactoryGirl.create(:referral_document_resource, :referral_document => nil, :resource_id => resource_id)
    end
    doc.save!
  end  
end

When /^I submit the "Customer Referral Report" form with a date range of "([^"]*)" to "([^"]*)"$/ do |start_date, end_date|
  fill_in_date_range "customer_referral", start_date, end_date
end

Then /^I should see the following report in the "Assessments Performed" table:$/ do |table|
  check_simple_table_data "#assessments_performed", table
end

Then /^I should see the following report in the "Referral Sources" table:$/ do |table|
  check_simple_table_data "#referral_sources", table
end

Then /^I should see the following report in the "Services Referred" table:$/ do |table|
  check_simple_table_data "#services_referred", table
end

def fill_in_date_range (parent_id, start_date, end_date)
  within("##{parent_id}") do
    fill_in "start_date", :with => start_date
    fill_in "end_date", :with => end_date
    click_button "Report"
  end
end
