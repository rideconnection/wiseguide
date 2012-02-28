Feature: Manage referral documents
  As a user of the system
  trainers and admins
  want to be able to manage referral documents
  
  Scenario: Trainers can create a new referral document
    Given I am logged in as a trainer
      And an open training case exists
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
      And an open training case exists
      And a referral document exists for the existing case
      And a resource exists with a name of "Sweet Resource"
      And I am on the homepage
    When I click on the "Training Cases" link
      And I click through to the case details
      And I click on the link to edit the referral document
    Then I should be able to add a new resource to the referral document form
      And I should see a confirmation message
      And I should see the new resource listed when I click on the referral document details link
  
  @firebug 
  @pause_on_fail
  @javascript
  Scenario: Trainers can remove a resource from an existing referral document
    Given I am logged in as a trainer
      And an open training case exists
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
    
  @wip
  Scenario: Trainers can print a referral document
  
  @wip
  Scenario: Trainers cannot delete a referral document
  
  @wip
  Scenario: Admins can delete a referral document