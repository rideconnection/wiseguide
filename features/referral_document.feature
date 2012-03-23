Feature: Manage referral documents
  As a user of the system
  trainers and admins
  want to be able to manage referral documents
  
  Scenario: Trainers can create a new referral document
    Given I am logged in as a trainer
      And there is an open training case
      And a resource exists
      And I am on the homepage
    When I click on the "Training Cases" link
      And I click through to the case details
      And I click on the link to create a new referral document
    Then I should be able to complete the referral document form
      And I should see a confirmation message
      And I should see the referral document under the Referral Documents section of the case profile
  
  # @firebug 
  # @pause_on_fail
  @javascript
  Scenario: Trainers can add a resource to an existing referral document
    Given I am logged in as a trainer
      And there is an open training case
      And a referral document exists for the existing case
      And a resource exists with a name of "Sweet Resource"
      And I am on the homepage
    When I click on the "Training Cases" link
      And I click through to the case details
      And I click on the link to edit the referral document
    Then I should be able to add a new resource to the referral document form
      And I should see a confirmation message
      And I should see the new resource listed when I click on the referral document details link
  
  # @firebug 
  # @pause_on_fail
  @javascript
  Scenario: Trainers can remove a resource from an existing referral document
    Given I am logged in as a trainer
      And there is an open training case
      And a referral document exists for the existing case
      And a resource exists with a name of "Sweet Resource"
      And the resource is assigned to the referral document as a second resource
      And I am on the homepage
    When I click on the "Training Cases" link
      And I click through to the case details
      And I click on the link to edit the referral document
    Then I should be able to delete the second resource
      And I should see a confirmation message
      And I should not see the new resource listed when I click on the referral document details link
    
  Scenario: Trainers can print a referral document
    Given I am logged in as a trainer
      And there is an open training case
      And a referral document exists for the existing case
      And I am on the homepage
    When I click on the "Training Cases" link
      And I click through to the case details
      And I click on the link to print the referral document
    Then I should be served the referral document as a PDF
      And I should see the referral document details
  
  @wip
  @firebug 
  @pause_on_fail
  @javascript
  Scenario: Trainers can not delete a referral document
    Given I am logged in as an trainer
      And there is an open training case
      And a referral document exists for the existing case
      And I am on the homepage
    When I click on the "Training Cases" link
      And I click through to the case details
    Then I should see a button to delete the referral document
      And I should be prompted to confirm the deletion when I click the referral document's delete button
      And I should see an error message because I don't have permission to delete the referral document
      And I should see the referral document listed when I return to the case profile

  @wip
  @firebug 
  @pause_on_fail
  @javascript
  Scenario: Admins can delete a referral document
    Given I am logged in as an admin
      And there is an open training case
      And a referral document exists for the existing case
      And I am on the homepage
    When I click on the "Training Cases" link
      And I click through to the case details
    Then I should see a button to delete the referral document
      And I should be prompted to confirm the deletion when I click the referral document's delete button
      And I should see a confirmation message
      And I should not see the referral document listed when I return to the case profile
