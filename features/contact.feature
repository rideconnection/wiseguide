Feature: Manage contacts aka contact events
  As a user of the system
  trainers and admins
  want to be able to manage contacts
 
  Scenario: Only case-less contact events appear on the customer profile
    Given I am logged in as a trainer
      And a customer exists
      And the customer has a case-less contact event
      And the customer has a contact event associated with an open training case
      And I am on the homepage
    When I click on the "Customers" link
      And I click through to the customer's profile
    Then I should see the read-only case-less contact event
      And I should not see the contact event associated with the case
    
  Scenario: Only contact events associated with a case should appear on the case profile
    Given I am logged in as a trainer
      And a customer exists
      And the customer has a case-less contact event
      And the customer has a contact event associated with an open training case
      And I am on the homepage
    When I click on the "Training Cases" link
      And I click through to the case details
    Then I should see the read-only contact event associated with the case
      And I should not see the case-less contact event
      
  Scenario: Trainers should be able to create a case-less contact event from a customer's profile
    Given I am logged in as a trainer
      And a customer exists
      And I am on the homepage
    When I click on the "Customers" link
      And I click through to the customer's profile
      And I click on the link to add a case-less contact event
    Then I should be able to complete the case-less contact event form
      And I should be redirected to the customer page
      And I should see a confirmation message
      And I should see the case-less contact event

  Scenario: Trainers should be able to create a contact event from a case
    Given I am logged in as a trainer
      And there is an open training case
      And I am on the homepage
    When I click on the "Training Cases" link
      And I click through to the case details
      And I click on the link to add a contact event
    Then I should be able to complete the contact event form
      And I should be redirected to the kase page
      And I should see a confirmation message
      And I should see the contact event associated with the case
