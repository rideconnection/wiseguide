Feature: Manage organizations
  As a user of the system
  trainers and admins
  want to be able to manage organizations

  @javascript
  Scenario: Admins can delete organizations
    Given I am logged in as an admin
      And an organization exists with a name of "Supporty Spice"
      And I am on the admin page
    When I click on the "Organizations" link
    Then I should see a button to delete the organization's profile
      And I should be prompted to confirm the deletion when I click the organization's delete button
      And I should see a confirmation message
      And I should not see a link to the organization's profile when I return to the organizations list

  @javascript
  Scenario: Admins cannot delete organizations that still have users assigned to them
    Given I am logged in as an admin
      And an organization exists with a name of "Supporty Spice"
      And a user exists who belongs to the organization
      And I am on the admin page
    When I click on the "Organizations" link
    Then I should see a button to delete the organization's profile
      And I should be prompted to confirm the deletion when I click the organization's delete button
      And I should see the error message "You cannot delete an organization that still has users assigned to it"
      And I should still see a link to the organization's profile when I return to the organizations list
