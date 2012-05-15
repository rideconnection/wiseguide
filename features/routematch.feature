Feature: Routematch
  In order to integrate with the routematch system
  trainers and admins
  need to be able to track routematch-specific fields
  
  Background:
    Given I am logged in as a trainer
      And I am on the homepage  

  Scenario: Trainers can specify if entry into scheduling system is required
    Given a customer exists
      And a case manager exists
      And a referral type exists
    When I click on the "Customers" link
      And I click through to the customer's profile
      And I click the link to add a coaching case
      And I complete the required fields for a coaching case
      And I check the "Entry into scheduling system required" checkbox
      And I submit the form to create the coaching case
    Then I should see a confirmation message
      And the "Entry into scheduling system required" checkbox should be checked

  Scenario: Toggling the "Entry into scheduling system required" checkbox to ON should generate a new Contact record
    Given there is an open coaching case 
      And the case's "Entry into scheduling system required" field is OFF
      And the case has no contact events
    When I click on the "Coaching Cases" link
      And I click through to the case details
      And I check the "Entry into scheduling system required" checkbox
      And I submit the form to update the case
    Then the case should have 1 contact event
      And the contact method should be "Case Action"
      And the contact user_id should be my user ID
      And the contact date should be now
      And the contact description should be "Case marked for entry into trip scheduling system"
      And the contact notes should be blank
  
  Scenario: Toggling the "Entry into scheduling system required" checkbox to OFF should generate a new Contact record
    Given there is an open coaching case
      And the case's "Entry into scheduling system required" field is ON
      And the case has no contact events
    When I click on the "Coaching Cases" link
      And I click through to the case details
      And I uncheck the "Entry into scheduling system required" checkbox
      And I submit the form to update the case
    Then the case should have 1 contact event
      And the contact method should be "Case Action"
      And the contact user_id should be my user ID
      And the contact date should be now
      And the contact description should be "Data entry into trip scheduling system complete"
      And the contact notes should be blank

  Scenario: Trainers can see a list of "Data Entry Needed" cases on the Coaching Cases page
    Given the following customers exist:
        | id | first_name | last_name |
        | 90 | Paul       | Bovinger  |
        | 91 | Mary       | Tyler     |
        | 92 | Maud       | Udz       |
        | 93 | Kenn       | Burnns    |
        | 94 | Mike       | Myers     |
        | 95 | Dave       | Thomas    |
      And the following open coaching kases exist:
        | id | Customer_id | scheduling_system_entry_required |
        | 90 | 90          | false                            |
        | 91 | 91          | true                             |
        | 92 | 92          | false                            |
        | 93 | 93          | true                             |
        | 94 | 94          | false                            |
        | 95 | 95          | true                             |
    When I click on the "Coaching Cases" link
    Then I should see a main section titled "Data Entry Needed"
      And I should see the following cases in the "Data Entry Needed" section:
        | customer_name | kase_id |
        | Tyler, Mary   | 91      |
        | Burnns, Kenn  | 93      |
        | Thomas, Dave  | 95      |

  Scenario: There is no "Data Entry Needed" section on the Training Cases page
    When I click on the "Training Cases" link
    Then I should not see a main section titled "Data Entry Needed"
    