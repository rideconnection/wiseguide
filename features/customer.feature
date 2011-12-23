@customer
Feature: Manage customers
  As a user of the system
  trainers
  want to be able to manage customers
 
  Scenario: Trainer can create customers
    Given I am logged in as a trainer
    When I go to the Customers page
    Then I should be able to create a new customer

  Scenario: Trainers can edit customers
    Given I am logged in as a trainer
    When the following customer exists:
        | first_name | last_name |
        | Birtha     | Jones     |
      And I go to the Customers page
    Then I should be able to edit the customer profile for "Birtha Jones"
    
  Scenario: Trainers cannot delete customers
    Given I am logged in as a trainer
    When the following customer exists:
        | first_name | last_name | email             |
        | Birtha     | Jones     | birtha@jones.name |
      And I go to the Customers page
    Then I should not be able to delete the customer profile for "Birtha Jones" with email "birtha@jones.name"

  # Scenario: Admins can delete customers
  #   Given I am logged in as a trainer
  #   When the following customers exists:
  #       | first_name | last_name | email             |
  #       | Birtha     | Jones     | birtha@jones.name |
  #       | Bobby      | Jones     | bobby@jones.name  |
  #     And I go to the Customers page
  #   Then I should be able to delete the customer profile for "Birtha Jones" with email "birtha@jones.name"
  #     And I should still see the customer profile for "Bobby Jones"
