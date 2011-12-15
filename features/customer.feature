Feature: Manage customers
  As a user of the system
  trainers
  want to be able to create customers
 
  Scenario: Create customer
    Given I am logged in as "trainer@rideconnection.org"
    When I go to the Customers page
      And I click "New Customer"
      And I fill in customer Alex Trebek
    Then I should see "Customer was successfully created."

