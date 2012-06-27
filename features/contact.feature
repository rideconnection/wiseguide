Feature: Manage contacts aka contact events
  As a user of the system
  trainers and admins
  want to be able to manage contacts
  
  Background:
    Given I am logged in as a trainer
    And the following customer exists:
      | id | first_name | last_name |
      | 90 | Jim        | Gaffigan  |
    And the following open training kase exists:
      | id | customer_id |
      | 90 | 90          |
    And the following assessment request exists:
      | id | created_at       | kase_id |
      | 90 | 2010-11-13 04:05 |         |
      | 91 | 2011-12-14 05:06 | 90      |
    And the following contacts exist:
      | id | contactable_type  | contactable_id | description                                  |
      | 90 | Customer          | 90             | This is a customer contact event!            |
      | 91 | TrainingKase      | 90             | This is a kase contact event!                |
      | 92 | AssessmentRequest | 90             | This is an assessment request contact event! |
    And I am on the homepage
 
  Scenario: Only customer contact events should appear on the customer profile
    When I click on the "Customers" link
    And I click on the "Gaffigan, Jim" link
    Then I should see a contacts list with 1 row
    And I should see "This is a customer contact event!"
    And I should not see "This is a kase contact event!"
    And I should not see "This is an assessment request contact event!"
    
  Scenario: Only case contact events should appear on the case profile
    When I click on the "Training Cases" link
    And I click on the "Gaffigan, Jim" link
    Then I should see a contacts list with 1 row
    And I should not see "This is a customer contact event!"
    And I should see "This is a kase contact event!"
    And I should not see "This is an assessment request contact event!"
      
  Scenario: Only AR contact events should appear on the AR profile
    When I click on the "Requests" link
    And I click on the "11/13/2010 04:05 AM" link
    Then I should see a contacts list with 1 row
    And I should not see "This is a customer contact event!"
    And I should not see "This is a kase contact event!"
    And I should see "This is an assessment request contact event!"
      
  Scenario: Trainers should be able to create a customer contact event from a customer's profile
    When I click on the "Customers" link
    And I click on the "Gaffigan, Jim" link
    Then I should see a contacts list with 1 row
    When I click on the link to add a contact event
    Then I should be able to complete the contact event form
    And I should be redirected to "customers/90"
    And I should see the confirmation message "Contact was successfully created."
    And I should see a contacts list with 2 rows

  Scenario: Trainers should be able to create a case contact event from a case
    When I click on the "Training Cases" link
    And I click on the "Gaffigan, Jim" link
    Then I should see a contacts list with 1 row
    When I click on the link to add a contact event
    Then I should be able to complete the contact event form
    And I should be redirected to "cases/90"
    And I should see the confirmation message "Contact was successfully created."
    And I should see a contacts list with 2 rows

  Scenario: Trainers should be able to create a case contact event from an AR
    When I click on the "Requests" link
    And I click on the "11/13/2010 04:05 AM" link
    Then I should see a contacts list with 1 row
    When I click on the link to add a contact event
    Then I should be able to complete the contact event form
    And I should be redirected to "assessment_requests/90"
    And I should see the confirmation message "Contact was successfully created."
    And I should see a contacts list with 2 rows

  Scenario: Trainers should not be able to create a case contact event from an AR that has an associated kase
    When I click on the "Requests" link
    And I click on the "12/14/2011 05:06 AM" link
    Then I should see a contacts list with 0 rows
    And I should not see a link to add a contact event
