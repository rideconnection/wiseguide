Feature: Assessment requests in customer profiles
  In order to better navigate through a customer's history and profile
  As a trainer or admin
  I want to see all associated assessment requests within each customer profile

  Background:
    Given I am logged in as a trainer
    And the following customer exists:
      | id  | first_name | last_name |
      | 100 | Pamela     | Sue       |
    And I am on the homepage
    When I click on the "Customers" link
    And I click on the "Sue, Pamela" link

  Scenario: When no assessment requests exist
    Then I should see a assessment requests list with 0 rows
  
  Scenario: When multiple assessment requests exist
    Given the following assessment request exists:
      | id  | customer_id | created_at |
      | 100 |         100 | 2000-01-02 |
      | 101 |         100 | 2001-02-03 |
    When I reload the page
    Then I should see a assessment requests list with 2 rows
    And I should see "2000-01-02" in row 1 of the assessment requests list
    And I should see a "Details" link in row 1 of the assessment requests list that goes to "/assessment_requests/100"
    And I should see "2001-02-03" in row 2 of the assessment requests list
    And I should see a "Details" link in row 2 of the assessment requests list that goes to "/assessment_requests/101"
