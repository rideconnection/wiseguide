Feature: Assessment requests in coaching kase details
  In order to better navigate through a coaching kase's history
  As a trainer or admin
  I want to see if the kase was created from a assessment request

  Background:
    Given I am logged in as a trainer
    And the following customer exists:
      | id  | first_name | last_name |
      | 100 | Pamela     | Sue       |
    And the following open coaching kase exists:
      | id  | customer_id |
      | 100 |         100 |
    And I am on the homepage
    When I click on the "Coaching Cases" link
    And I click on the "Sue, Pamela" link

  Scenario: With no associated assessment request
    Then I should see a assessment requests list with 0 rows
  
  Scenario: With an associated assessment request
    Given the following assessment request exists:
      | id  | kase_id | created_at |
      | 100 |     100 | 2000-01-02 |
    When I reload the page
    Then I should see a assessment requests list with 1 row
    And I should see "This case was generated from an assessment request dated 1/2/2000" in row 1 of the assessment requests list
    And I should see a "Details" link in row 1 of the assessment requests list that goes to "/assessment_requests/100"
