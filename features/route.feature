Feature: Manage routes trained on cases
  As a user of the system
  trainers and admins
  want to be able to manage routes trained on cases
  
  @javascript 
  Scenario: Trainers can add trained routes to cases
    Given I am logged in as a trainer
      And there is an open training case
      And a route exists with a name of "Hometown Express 123"
      And I am on the homepage
    When I click on the "Training Cases" link
      And I click through to the case details
      And I click the link to add a trained route
    Then I should be able to add a trained route using the AJAX form
      And I should see the trained route under the Routes Trained section of the case profile
  
  @javascript
  Scenario: Trainers can delete trained routes from cases
    Given I am logged in as a trainer
      And there is an open training case
      And a trained route exists for the existing case
      And I am on the homepage
    When I click on the "Training Cases" link
      And I click through to the case details
    Then I should see a button to delete the trained route
      And I should be prompted to confirm the deletion when I click the trained routes's delete button
      And I should not see the trained route under the Routes Trained section of the case profile

  Scenario: Admins can add new routes
    Given I am logged in as an admin
      And I am on the homepage
    When I click on the "Admin" link
      And I click on the "Routes" link
      And I click on the "New Route" link
    Then I should be able to add a new route
      And I should see a confirmation message
      And I should see the route on the routes page
    
  Scenario: Admins can edit routes
    Given I am logged in as an admin
      And a route exists
      And I am on the homepage
    When I click on the "Admin" link
      And I click on the "Routes" link
      And I click through to the route details
    Then I should be able to edit the route
      And I should see a confirmation message
      And I should see the route on the routes page
      
  @javascript
  Scenario: Admins can delete routes
    Given I am logged in as an admin
      And a route exists
      And I am on the homepage
    When I click on the "Admin" link
      And I click on the "Routes" link
    Then I should see a button to delete the route
      And I should be prompted to confirm the deletion when I click the routes's delete button
      And I should not see the route on the routes page
