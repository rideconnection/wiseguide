Feature: Manage assessments aka response sets
  As a user of the system
  trainers and admins
  want to be able to manage assessments on cases
  
  Scenario: Trainers should be allowed to add multiple assessments to a training case
    Given I am logged in as a trainer
      And an open training case exists
      And the case has one assessment
      And I am on the homepage
    When I click on the "Training Cases" link
      And I click through to the case details
    Then I should see a link to add a new assessment

  Scenario: Trainers should only be allowed to add one assessment to a coaching case
    Given I am logged in as a trainer
      And an open coaching case exists
      And the case has one assessment
      And I am on the homepage
    When I click on the "Coaching Cases" link
      And I click through to the case details
    Then I should not see a link to add a new assessment
