@customer
Feature: Manage customers
  As a user of the system
  trainers
  want to be able to create customers
 
  Scenario: Create customer
    Given I am logged in as a trainer
    When I go to the Customers page
    Then I should be able to create a new customer

  @wip
  Scenario: Edit Customer
    Given I am logged in as a trainer
    When the following customer exists:
        | first_name | last_name |
        | Birtha     | Jones     |
      And I go to the Customers page
    Then I should be able to edit the customer profile for "Birtha Jones"