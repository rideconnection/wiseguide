Feature: notify case manager button
  In order to make the system more accountable
  trainers and admins
  want to have a button to trigger notifying a coaching case manager

  Background:
    Given I am logged in as a trainer
      And I am on the homepage
      
  Scenario: Trainers can see a "Email case manager" button on coaching cases
    Given an open coaching case exists
    When I click on the "Coaching Cases" link
      And I click through to the case details
    Then I should see an "Email case manager" button

  Scenario: Trainers can click the "Email case manager" button to trigger an email to the case manager
    Given the following customer exists:
        | first_name | last_name |
        | Billy      | Joel      |
      And a case manager exists with an email of "brappy@mcfun.org"
      And an open coaching case exists belonging to the customer and assigned to the case manager
      And no emails have been sent
    When I click on the "Coaching Cases" link
      And I click through to the case details
      And I click the "Email case manager" button
    Then I should see the confirmation message "The notification has been sent."
      And I should see today's date in the Case Manager Notification Date field
      And "brappy@mcfun.org" should receive an email
    When they open the email
      And they should see "Customer Assessment Notification" in the email subject
      And they should see "Your requested referral has been assessed" in the email body
      And they should see "Customer: Joel, Billy" in the email body
      And they should see a link to the case URL in the email body

  Scenario: Trainers cannot click the "Email case manager" button when no case manager is assigned
    Given an open coaching case exists with no case manager
      And no emails have been sent
    When I click on the "Coaching Cases" link
      And I click through to the case details
      And I click the "Email case manager" button
    Then I should see the error message "The notification could not be sent because there is no case manager assigned."
      And I should see "Not notified yet" in the Case Manager Notification Date field
      And no emails should have been sent
    
  Scenario: The "Email case manager" button should not appear before a coaching kase is saved
    Given a customer exists
      And a case manager exists
      And a referral type exists
    When I click on the "Customers" link
      And I click through to the customer's profile
      And I click the link to add a coaching case
    Then I should not see an "Email case manager" button
  
  Scenario: The "Email case manager" button should not appear on training kases
    Given an open training case exists
    When I click on the "Training Cases" link
      And I click through to the case details
    Then I should not see an "Email case manager" button
    
  Scenario: The "Email case manager" button can be clicked more than once
    Given a case manager exists with an email of "brappy@mcfun.org"
      And an open coaching case exists assigned to the case manager
      And no emails have been sent
    When I click on the "Coaching Cases" link
      And I click through to the case details
      And I click the "Email case manager" button
    Then I should see the confirmation message "The notification has been sent."
      And I should see today's date in the Case Manager Notification Date field
      And "brappy@mcfun.org" should have 1 email
    When I click the "Email case manager" button
    Then I should see the confirmation message "The notification has been sent."
      And "brappy@mcfun.org" should have 2 emails
  
  @javascript
  Scenario: The "Email case manager" button should issue a warning if the form data has changed
    Given a case manager exists with an email of "frappy@mcfun.net"
      And a case manager exists with an email of "brappy@mcfun.org"
      And an open coaching case exists assigned to the case manager
    When I click on the "Coaching Cases" link
      And I click through to the case details
      And I change the Case Manager to "frappy@mcfun.net"
      And the Case Manager should be set to "frappy@mcfun.net"
      And I click the "Email case manager" button
    Then I should see a javascript confirmation dialog asking "You have made changes to the Case form which have not been saved. Are you sure you want to continue?"
    When I cancel the confirmation dialog
    Then I should not see the confirmation message "The notification has been sent."
      And the Case Manager should be set to "frappy@mcfun.net"
    When I click the "Email case manager" button
    Then I should see a javascript confirmation dialog asking "You have made changes to the Case form which have not been saved. Are you sure you want to continue?"
    When I accept the confirmation dialog
    Then I should see the confirmation message "The notification has been sent."
      And the Case Manager should be set to "brappy@mcfun.org"
