Feature: Manage users
  As a user of the system
  trainers and admins
  want to be able to manage users
  
  Scenario: Trainers should be able to view all users
    Given I am logged in as a trainer
      And the following organizations exist:
        | id | name | organization_type | parent_id |
        | 90 | The Org | staff | 0 |
        | 91 | The Feds | government | 0 |
        | 92 | Men In Blue | case_mgmt | 91 |
      And the following users exist:
        | first_name | last_name | email | level | organization_id |
        | No | Good | good.no@mal.org | -1 | 90 |
        | Bob | Case | bcase@bcase.org | 0 | 90 |
        | Terrance | Phillip | tp@toons.org | 25 | 92 |
        | Philly | Steak | philly@steakbomb.com | 50 | 90 |
        | Super | Man | c.kent@dailynews.com | 100 | 90 |
      And I am on the homepage
    When I click on the "Admin" link
      And I click on the "Users" link
    Then I should see the following users listed:
      | Name | Email | Role |
      | No Good | good.no@mal.org | Deleted |
      | Bob Case | bcase@bcase.org | Viewer |
      | Terrance Phillip | tp@toons.org | Outside |
      | Philly Steak | philly@steakbomb.com | Editor |
      | Super Man | c.kent@dailynews.com | Admin |

  Scenario: Trainers should be able to change only their own password
    Given I am logged in as a trainer
      And a case manager exists
      And a viewer exists
      And a trainer exists
      And an admin exists
      And I am on the homepage
    When I click on the "Admin" link
      And I click on the "Users" link
    Then I should see a change password link for myself
      And I should not see a change password link for anyone else
      And my change password link should take me to the change password form
    
  Scenario: Trainers should not be able to add a new user
    Given I am logged in as a trainer
      And I am on the homepage
    When I click on the "Admin" link
      And I click on the "Users" link
    Then I should not see a "New User" link
      And manually going to the new user page should show me an error

  Scenario: Trainers should not be able to edit existing users' roles
    Given I am logged in as a trainer
      And a case manager exists
      And a viewer exists
      And a trainer exists
      And an admin exists
      And I am on the homepage
    When I click on the "Admin" link
      And I click on the "Users" link
    Then I should not see a form to change my role
      And I should not see see a form to change the role of anyone else
  
  Scenario: Admins should be able to view all users
    Given I am logged in as an admin
      And the following organizations exist:
        | id | name | organization_type | parent_id |
        | 90 | The Org | staff | 0 |
        | 91 | The Feds | government | 0 |
        | 92 | Men In Blue | case_mgmt | 91 |
      And the following users exist:
        | first_name | last_name | email | level | organization_id |
        | No | Good | good.no@mal.org | -1 | 90 |
        | Bob | Case | bcase@bcase.org | 0 | 90 |
        | Terrance | Phillip | tp@toons.org | 25 | 92 |
        | Philly | Steak | philly@steakbomb.com | 50 | 90 |
        | Super | Man | c.kent@dailynews.com | 100 | 90 |
      And I am on the homepage
    When I click on the "Admin" link
      And I click on the "Users" link
    Then I should see the following users listed:
      | Name | Email | Role |
      | No Good | good.no@mal.org | Deleted |
      | Bob Case | bcase@bcase.org | Viewer |
      | Terrance Phillip | tp@toons.org | Outside |
      | Philly Steak | philly@steakbomb.com | Editor |
      | Super Man | c.kent@dailynews.com | Admin |

  Scenario: Admins should be able to change only their own password
    Given I am logged in as an admin
      And a case manager exists
      And a viewer exists
      And a trainer exists
      And an admin exists
      And I am on the homepage
    When I click on the "Admin" link
      And I click on the "Users" link
    Then I should see a change password link for myself
      And I should not see a change password link for anyone else
      And my change password link should take me to the change password form

  Scenario: Admins should be able to add a new inside user
    Given I am logged in as an admin
      And an organization exists with a name of "4Chan"
      And I am on the homepage
    When I click on the "Admin" link
      And I click on the "Users" link
    Then I should see a "New User" link
      And the "New User" link should take me to the new user form
      And I should be able to complete the New User form using the following data:
        | first_name | last_name | email | organization |
        | Rick | Astley | rick@rickrolling.com | 4Chan |
      And "rick@rickrolling.com" should receive a welcome email with a link to the application
      And I should see a confirmation message
      And I should see the new user on the Users index page
  
  Scenario: Admins should be able to edit existing users' roles
    Given I am logged in as an admin
      And an admin exists
      And I am on the homepage
    When I click on the "Admin" link
      And I click on the "Users" link
    Then I should see a form to change the admin user's role
      And I should be able to change the admin user's role to "Viewer"
      And I should see a confirmation message
      And I should see the admin user role listed as "Viewer" on the Users index page
  
  @javascript
  Scenario: Admins should be able to mark a user as deleted
    Given I am logged in as an admin
      And an admin exists
      And I am on the homepage
    When I click on the "Admin" link
      And I click on the "Users" link
    Then I should see a button to mark the admin user as deleted
      And I should be able to click the button to delete the admin user
      And I should be prompted to confirm the deletion of the admin user
      And I should see a confirmation message
      And I should see the admin user role listed as "Deleted" on the Users index page
      