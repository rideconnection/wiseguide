Feature: Manage kases aka cases
  As a user of the system
  trainers and admins
  want to be able to manage cases
  
  Scenario: Trainers can create new cases
    Given I am logged in as a trainer
      And a customer exists
      And a referral type exists
      And a funding source exists
      And I am on the homepage
    When I click on the "Customers" link
      And I click through to the customer's profile
      And I click the link to add a case
    Then I should be able to create a new open, unassigned case for the customer
      And I should see a confirmation message
      And I should see the case listed as "In Progress" on the case's customer's profile
      And I should see the case listed in the "Wait List" section of the Cases page
  
  Scenario: Trainers can edit a case by assigning it to themselves
    Given I am logged in as a trainer
      And an unassigned open case exists
      And I am on the homepage
    When I click on the "Cases" link
      And I click through to the case details
    Then I should be able to assign the case to myself
      And I should see a confirmation message
      And I should see the case listed in the "Open" sub-section of the "My Cases" section of the Cases page
  
  Scenario: Trainers can edit a case by assigning it to another trainer
    Given I am logged in as a trainer
      And another trainer exists
      And an unassigned open case exists
      And I am on the homepage
    When I click on the "Cases" link
      And I click through to the case details
    Then I should be able to assign the case to the other trainer
      And I should see a confirmation message
      And I should see the case listed in the "Open" sub-section of the "Other Cases" section of the Cases page
      And the other trainer should be listed as the case assignee
  
  Scenario: Trainers can close a case assigned to themselves
    Given I am logged in as a trainer
      And an open case exists and is assigned to me
      And a disposition exists with a name of "Successful"
      And I am on the homepage
    When I click on the "Cases" link
      And I click through to the case details
    Then I should be able to close the case
      And I should see a confirmation message
      And I should not see the case listed on the Cases page
      And I should see the case listed as "Successful" on the case's customer's profile
  
  Scenario: Trainers can close a case assigned to another trainer
    Given I am logged in as a trainer
      And another trainer exists
      And an open case exists and is assigned to the other trainer
      And a disposition exists with a name of "Successful"
      And I am on the homepage
    When I click on the "Cases" link
      And I click through to the case details
    Then I should be able to close the case
      And I should see a confirmation message
      And I should not see the case listed on the Cases page
      And I should see the case listed as "Successful" on the case's customer's profile
  
  @javascript
  Scenario: Trainers cannot delete a case
    Given I am logged in as an trainer
      And an open case exists
      And I am on the homepage
    When I click on the "Cases" link
      And I click through to the case details
    Then I should see a button to delete the case
      And I should be prompted to confirm the deletion when I click the case's delete button
      And I should see an error message because I don't have permission to delete the case
      And I should see the case listed when I return to the customer's profile

  @javascript
  Scenario: Admins can delete a case
    Given I am logged in as an admin
      And an open case exists
      And I am on the homepage
    When I click on the "Cases" link
      And I click through to the case details
    Then I should see a button to delete the case
      And I should be prompted to confirm the deletion when I click the case's delete button
      And I should see a confirmation message
      And I should not see the case listed when I return to the customer's profile
