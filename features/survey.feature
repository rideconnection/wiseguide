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
 
      