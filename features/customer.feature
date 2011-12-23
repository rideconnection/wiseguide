Feature: Manage customers
  As a user of the system
  trainers and admins
  want to be able to manage customers
 
  Scenario: Trainer can create customers
    Given I am logged in as a trainer
      And I am on the homepage
    When I click on the "Customers" link
      And I click on the "New Customer" link
    Then I should be able to create a new customer
      # This next step is redundant since the previous step tests for the same
      # thing, but I feel like we should explicitly state it because as a 
      # user it's what I would expect to see to know that the previous step
      # completed properly.
      And I should see a confirmation message
      And I should see a link to the customer's profile when I return to the customers list

  Scenario: Trainers can edit customers
    Given I am logged in as a trainer
      And a customer exists
      And I am on the homepage
    When I click on the "Customers" link
      And I click through to the customer's profile
    Then I should be able to modify the customer's profile
      And I should see a confirmation message
    
  Scenario: Trainers cannot delete customers
    Given I am logged in as a trainer
      And a customer exists
      And I am on the homepage
    When I click on the "Customers" link
    Then I should not see a button to delete the customer's profile

  @javascript
  Scenario: Admins can delete customers
    Given I am logged in as an admin
      And a customer exists
      And I am on the homepage
    When I click on the "Customers" link
    Then I should see a button to delete the customer's profile
      And I should be prompted to confirm the deletion when I click the customer's delete button
      And I should see a confirmation message
      And I should not see a link to the customer's profile when I return to the customers list
