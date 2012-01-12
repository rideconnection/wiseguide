Feature: Manage surveys aka Assessments
  As a user of the system
  trainers and admins
  want to be able to manage surveys
  
  Scenario: Admins can import new surveys
    Given I am logged in as an admin
      And I am on the homepage
    When I click on the "Admin" link
      And I click on the "Surveys" link
      And I click on the "Create survey" link
    Then I should be able to paste JSON-formatted data to create a new survey
      And I should see a confirmation message
      And I should see the survey listed when I return to the surveys list
 
  Scenario: Trainers can complete surveys
  Given I am logged in as a trainer
    And an open case exists assigned to me
    And a simple survey exists
    And I am on the homepage
  When I click on the "Cases" link
    And I click on the link to the existing case
    And I click the link to add an assessment
    And I click the button for the open survey
  Then I should be able to complete the survey form
    And I should see a confirmation message
    And I should see the survey listed when I return to the case page
