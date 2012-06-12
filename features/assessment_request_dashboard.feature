Feature: Manage assessment requests via the "Requests" page (dashboard)
  As a user of the system
  trainers and admins
  want to be able to manage assessment requests

  Background:
    Given I am logged in as a trainer
      And my name is "Tony Hawk"
      And the following organizations exist:
        | id | organization_type | parent_id |
        | 90 | staff             | 0         |
        | 91 | government        | 0         |
        | 92 | case_mgmt         | 91        |
      And I belong to organization 90
      And the following users exist:
        | id | first_name | last_name | organization_id |
        | 90 | Ray        | Combs     | 90              |
        | 91 | Louie      | Anderson  | 91              |
        | 92 | Richard    | Karn      | 92              |
        | 93 | John       | O'Hurley  | 90              |
        | 94 | Steve      | Harvey    | 91              |
        | 95 | Ned        | Flanders  | 92              |
      And the following customers exist:
        | id | first_name | last_name | 
        | 10 | Kyle       | Krauss    |
      And the following assessment requests exist:
        | customer_first_name | customer_last_name | customer_phone | customer_birth_date | notes | reason_not_completed | submitter_id | kase_id | created_at       |
        | Abe                 | Akron              | 1234567890     |                     |       | Duplicate request    | 90           |         | 2012-04-26 14:30 |
        | Bob                 | Bixby              | 2345678901     | 2002-02-02          |       |                      | 91           | 1       | 2012-04-26 14:31 |
        | Cam                 | Cosby              | 3456789012     |                     | Blah  |                      | 92           | 2       | 2012-04-26 14:32 |
        | Dot                 | Devry              | 4567890123     |                     |       | Could not reach      | 93           |         | 2042-01-01 12:33 |
        | Emm                 | Elway              | 5678901234     |                     |       |                      | 94           | 3       | 2000-01-01 00:34 |
        | Fay                 | Furby              | 6789012345     |                     |       |                      | 95           | 4       | 2012-04-26 14:35 |
        | Gay                 | Gamma              | 7890123456     |                     |       | Duplicate request    | 90           |         | 2012-04-26 14:36 |
        | Hue                 | Himby              | 8901234567     |                     |       |                      | 91           |         | 2012-04-26 14:37 |
      And the following assessment requests exist that belong to me:
        | customer_first_name | customer_last_name | customer_phone | customer_birth_date | notes | reason_not_completed | customer_id | kase_id | created_at |
        | Ira                 | Glass              | 9012345678     |                     |       |                      |             |         | 2012-04-26 14:38 |
        | Jay                 | Jomba              | 0123456789     |                     |       |                      |             | 5       | 2012-04-26 14:39 |
        | Kyle                | Krauss             | 1234567890     |                     |       |                      | 10          |         | 2012-04-26 14:40 |
      And I am on the homepage

  Scenario: Trainers should be able to see all assessment requests in order of creation date
    When I click on the "Requests" link
    Then I should see the following data in the "Assessment Requests" table:
        | Request Date        | Customer name | Customer phone | Customer birth date | Notes | Submitter      | Status                            |
        | 01/01/2000 12:34 AM | Elway, Emm    | 5678901234     |                     |       | Steve Harvey   | Completed                         |
        | 04/26/2012 02:30 PM | Akron, Abe    | 1234567890     |                     |       | Ray Combs      | Not completed (Duplicate request) |
        | 04/26/2012 02:31 PM | Bixby, Bob    | 2345678901     | 2002-02-02          |       | Louie Anderson | Completed                         |
        | 04/26/2012 02:32 PM | Cosby, Cam    | 3456789012     |                     | Blah  | Richard Karn   | Completed                         |
        | 04/26/2012 02:35 PM | Furby, Fay    | 6789012345     |                     |       | Ned Flanders   | Completed                         |
        | 04/26/2012 02:36 PM | Gamma, Gay    | 7890123456     |                     |       | Ray Combs      | Not completed (Duplicate request) |
        | 04/26/2012 02:37 PM | Himby, Hue    | 8901234567     |                     |       | Louie Anderson | Pending                           |
        | 04/26/2012 02:38 PM | Glass, Ira    | 9012345678     |                     |       | Tony Hawk      | Pending                           |
        | 04/26/2012 02:39 PM | Jomba, Jay    | 0123456789     |                     |       | Tony Hawk      | Completed                         |
        | 04/26/2012 02:40 PM | Krauss, Kyle  | 1234567890     |                     |       | Tony Hawk      |                                   |
        | 01/01/2042 12:33 PM | Devry, Dot    | 4567890123     |                     |       | John O'Hurley  | Not completed (Could not reach)   |
  
  Scenario: Trainers should see a message when no assessment requests are available
    Given there are no assessment requests
    When I click on the "Requests" link
    Then I should see the following data in the "Assessment Requests" table:
        | Request Date |
        | There are no assessment requests that match your request |
  
  Scenario: Trainers should be able to filter requests by the user type
    When I click on the "Requests" link
    Then I should see the following data in the "Assessment Requests" table:
        | Customer name | Submitter      |
        | Elway, Emm    | Steve Harvey   |
        | Akron, Abe    | Ray Combs      |
        | Bixby, Bob    | Louie Anderson |
        | Cosby, Cam    | Richard Karn   |
        | Furby, Fay    | Ned Flanders   |
        | Gamma, Gay    | Ray Combs      |
        | Himby, Hue    | Louie Anderson |
        | Glass, Ira    | Tony Hawk      |
        | Jomba, Jay    | Tony Hawk      |
        | Krauss, Kyle  | Tony Hawk      |
        | Devry, Dot    | John O'Hurley  |
      And I should see a form to filter by user type
    When I check the "Me" option in the user type filter form
      And I click the "Filter" button to apply filter
    Then I should see the following data in the "Assessment Requests" table:
        | Customer name | Submitter      |
        | Glass, Ira    | Tony Hawk      |
        | Jomba, Jay    | Tony Hawk      |
        | Krauss, Kyle  | Tony Hawk      |
    When I check the "My Organization" option in the user type filter form
      And I click the "Filter" button to apply filter
    Then I should see the following data in the "Assessment Requests" table:
        | Customer name | Submitter      |
        | Akron, Abe    | Ray Combs      |
        | Gamma, Gay    | Ray Combs      |
        | Glass, Ira    | Tony Hawk      |
        | Jomba, Jay    | Tony Hawk      |
        | Krauss, Kyle  | Tony Hawk      |
        | Devry, Dot    | John O'Hurley  |
    When I check the "Outside users" option in the user type filter form
      And I click the "Filter" button to apply filter
    Then I should see the following data in the "Assessment Requests" table:
        | Customer name | Submitter      |
        | Elway, Emm    | Steve Harvey   |
        | Bixby, Bob    | Louie Anderson |
        | Cosby, Cam    | Richard Karn   |
        | Furby, Fay    | Ned Flanders   |
        | Himby, Hue    | Louie Anderson |
    When I check the "Anyone" option in the user type filter form
      And I click the "Filter" button to apply filter
    Then I should see the following data in the "Assessment Requests" table:
        | Customer name | Submitter      |
        | Elway, Emm    | Steve Harvey   |
        | Akron, Abe    | Ray Combs      |
        | Bixby, Bob    | Louie Anderson |
        | Cosby, Cam    | Richard Karn   |
        | Furby, Fay    | Ned Flanders   |
        | Gamma, Gay    | Ray Combs      |
        | Himby, Hue    | Louie Anderson |
        | Glass, Ira    | Tony Hawk      |
        | Jomba, Jay    | Tony Hawk      |
        | Krauss, Kyle  | Tony Hawk      |
        | Devry, Dot    | John O'Hurley  |

  Scenario: Trainers should be able to filter requests by the current status
    When I click on the "Requests" link
    Then I should see the following data in the "Assessment Requests" table:
        | Customer name | Status                            |
        | Elway, Emm    | Completed                         |
        | Akron, Abe    | Not completed (Duplicate request) |
        | Bixby, Bob    | Completed                         |
        | Cosby, Cam    | Completed                         |
        | Furby, Fay    | Completed                         |
        | Gamma, Gay    | Not completed (Duplicate request) |
        | Himby, Hue    | Pending                           |
        | Glass, Ira    | Pending                           |
        | Jomba, Jay    | Completed                         |
        | Krauss, Kyle  | Pending                           |
        | Devry, Dot    | Not completed (Could not reach)   |
    Then I should see a form to filter by current status
    When I check the "Pending" option in the current status filter form
      And I click the "Filter" button to apply filter
    Then I should see the following data in the "Assessment Requests" table:
        | Customer name | Status                            |
        | Himby, Hue    | Pending                           |
        | Glass, Ira    | Pending                           |
        | Krauss, Kyle  | Pending                           |
    When I check the "Not completed" option in the current status filter form
      And I click the "Filter" button to apply filter
    Then I should see the following data in the "Assessment Requests" table:
        | Customer name | Status                            |
        | Akron, Abe    | Not completed (Duplicate request) |
        | Gamma, Gay    | Not completed (Duplicate request) |
        | Devry, Dot    | Not completed (Could not reach)   |
    When I check the "Completed" option in the current status filter form
      And I click the "Filter" button to apply filter
    Then I should see the following data in the "Assessment Requests" table:
        | Customer name | Status                            |
        | Elway, Emm    | Completed                         |
        | Bixby, Bob    | Completed                         |
        | Cosby, Cam    | Completed                         |
        | Furby, Fay    | Completed                         |
        | Jomba, Jay    | Completed                         |
    When I check the "All" option in the current status filter form
      And I click the "Filter" button to apply filter
    Then I should see the following data in the "Assessment Requests" table:
        | Customer name | Status                            |
        | Elway, Emm    | Completed                         |
        | Akron, Abe    | Not completed (Duplicate request) |
        | Bixby, Bob    | Completed                         |
        | Cosby, Cam    | Completed                         |
        | Furby, Fay    | Completed                         |
        | Gamma, Gay    | Not completed (Duplicate request) |
        | Himby, Hue    | Pending                           |
        | Glass, Ira    | Pending                           |
        | Jomba, Jay    | Completed                         |
        | Krauss, Kyle  | Pending                           |
        | Devry, Dot    | Not completed (Could not reach)   |

  Scenario: Trainers should be able to filter requests by the user type AND the current status
    When I click on the "Requests" link
    Then I should see the following data in the "Assessment Requests" table:
        | Customer name |  Submitter      | Status                            |
        | Elway, Emm    |  Steve Harvey   | Completed                         |
        | Akron, Abe    |  Ray Combs      | Not completed (Duplicate request) |
        | Bixby, Bob    |  Louie Anderson | Completed                         |
        | Cosby, Cam    |  Richard Karn   | Completed                         |
        | Furby, Fay    |  Ned Flanders   | Completed                         |
        | Gamma, Gay    |  Ray Combs      | Not completed (Duplicate request) |
        | Himby, Hue    |  Louie Anderson | Pending                           |
        | Glass, Ira    |  Tony Hawk      | Pending                           |
        | Jomba, Jay    |  Tony Hawk      | Completed                         |
        | Krauss, Kyle  |  Tony Hawk      | Pending                           |
        | Devry, Dot    |  John O'Hurley  | Not completed (Could not reach)   |
    When I check the "Pending" option in the current status filter form
      And I click the "Filter" button to apply filter
    Then I should see the following data in the "Assessment Requests" table:
        | Customer name |  Submitter      | Status                            |
        | Himby, Hue    |  Louie Anderson | Pending                           |
        | Glass, Ira    |  Tony Hawk      | Pending                           |
        | Krauss, Kyle  |  Tony Hawk      | Pending                           |
    When I check the "Outside users" option in the current status filter form
      And I click the "Filter" button to apply filter
    Then I should see the following data in the "Assessment Requests" table:
        | Customer name |  Submitter      | Status                            |
        | Himby, Hue    |  Louie Anderson | Pending                           |
    When I check the "Completed" option in the current status filter form
      And I check the "My Organization" option in the user type filter form
      And I click the "Filter" button to apply filter
    Then I should see the following data in the "Assessment Requests" table:
        | Customer name |  Submitter      | Status                            |
        | Jomba, Jay    |  Tony Hawk      | Completed                         |
    When I check the "All" option in the current status filter form
      And I click the "Filter" button to apply filter
    Then I should see the following data in the "Assessment Requests" table:
        | Customer name |  Submitter      | Status                            |
        | Akron, Abe    |  Ray Combs      | Not completed (Duplicate request) |
        | Gamma, Gay    |  Ray Combs      | Not completed (Duplicate request) |
        | Glass, Ira    |  Tony Hawk      | Pending                           |
        | Jomba, Jay    |  Tony Hawk      | Completed                         |
        |   |  Tony Hawk      | Pending                           |
        | Devry, Dot    |  John O'Hurley  | Not completed (Could not reach)   |

  Scenario: Filter form state should be preserved in a session store and reapplied on next load
    When I click on the "Requests" link
    Then I should see the following data in the "Assessment Requests" table:
      | Customer name |  Submitter      | Status                            |
      | Elway, Emm    |  Steve Harvey   | Completed                         |
      | Akron, Abe    |  Ray Combs      | Not completed (Duplicate request) |
      | Bixby, Bob    |  Louie Anderson | Completed                         |
      | Cosby, Cam    |  Richard Karn   | Completed                         |
      | Furby, Fay    |  Ned Flanders   | Completed                         |
      | Gamma, Gay    |  Ray Combs      | Not completed (Duplicate request) |
      | Himby, Hue    |  Louie Anderson | Pending                           |
      | Glass, Ira    |  Tony Hawk      | Pending                           |
      | Jomba, Jay    |  Tony Hawk      | Completed                         |
      | Krauss, Kyle  |  Tony Hawk      | Pending                           |
      | Devry, Dot    |  John O'Hurley  | Not completed (Could not reach)   |
    When I check the "Pending" option in the current status filter form
    And I click the "Filter" button to apply filter
    Then I should see the following data in the "Assessment Requests" table:
      | Customer name |  Submitter      | Status                            |
      | Himby, Hue    |  Louie Anderson | Pending                           |
      | Glass, Ira    |  Tony Hawk      | Pending                           |
      | Krauss, Kyle  |  Tony Hawk      | Pending                           |
    When I reload the page
    Then the "Pending" option in the current status filter form should be selected
    And I should see the following data in the "Assessment Requests" table:
      | Customer name |  Submitter      | Status                            |
      | Himby, Hue    |  Louie Anderson | Pending                           |
      | Glass, Ira    |  Tony Hawk      | Pending                           |
      | Krauss, Kyle  |  Tony Hawk      | Pending                           |  

  @javascript
  Scenario: Trainers with javascript enabled should be able to filter requests using an AJAXified form
    When I click on the "Requests" link
    Then I should see the following data in the "Assessment Requests" table:
      | Customer name |  Submitter      | Status                            |
      | Elway, Emm    |  Steve Harvey   | Completed                         |
      | Akron, Abe    |  Ray Combs      | Not completed (Duplicate request) |
      | Bixby, Bob    |  Louie Anderson | Completed                         |
      | Cosby, Cam    |  Richard Karn   | Completed                         |
      | Furby, Fay    |  Ned Flanders   | Completed                         |
      | Gamma, Gay    |  Ray Combs      | Not completed (Duplicate request) |
      | Himby, Hue    |  Louie Anderson | Pending                           |
      | Glass, Ira    |  Tony Hawk      | Pending                           |
      | Jomba, Jay    |  Tony Hawk      | Completed                         |
      | Krauss, Kyle  |  Tony Hawk      | Pending                           |
      | Devry, Dot    |  John O'Hurley  | Not completed (Could not reach)   |
    And I should see an AJAXified form to filter by user type
    And I should see an AJAXified form to filter by current status
    When I check the "Pending" option in the current status filter form
    Then the filter should apply and the table data should refresh without having to click the "Filter" button
    And I should see the following data in the "Assessment Requests" table:
      | Customer name |  Submitter      | Status                            |
      | Himby, Hue    |  Louie Anderson | Pending                           |
      | Glass, Ira    |  Tony Hawk      | Pending                           |
      | Krauss, Kyle  |  Tony Hawk      | Pending                           |
    When I check the "Outside users" option in the current status filter form
    Then the filter should apply and the table data should refresh without having to click the "Filter" button
    And I should see the following data in the "Assessment Requests" table:
      | Customer name |  Submitter      | Status                            |
      | Himby, Hue    |  Louie Anderson | Pending                           |

  @javascript
  Scenario: AJAXified filter form state should be preserved in a session store and reapplied on next load
    When I click on the "Requests" link
    Then I should see the following data in the "Assessment Requests" table:
      | Customer name |  Submitter      | Status                            |
      | Elway, Emm    |  Steve Harvey   | Completed                         |
      | Akron, Abe    |  Ray Combs      | Not completed (Duplicate request) |
      | Bixby, Bob    |  Louie Anderson | Completed                         |
      | Cosby, Cam    |  Richard Karn   | Completed                         |
      | Furby, Fay    |  Ned Flanders   | Completed                         |
      | Gamma, Gay    |  Ray Combs      | Not completed (Duplicate request) |
      | Himby, Hue    |  Louie Anderson | Pending                           |
      | Glass, Ira    |  Tony Hawk      | Pending                           |
      | Jomba, Jay    |  Tony Hawk      | Completed                         |
      | Krauss, Kyle  |  Tony Hawk      | Pending                           |
      | Devry, Dot    |  John O'Hurley  | Not completed (Could not reach)   |
    When I check the "Pending" option in the current status filter form
    Then the filter should apply and the table data should refresh without having to click the "Filter" button
    And I should see the following data in the "Assessment Requests" table:
      | Customer name |  Submitter      | Status                            |
      | Himby, Hue    |  Louie Anderson | Pending                           |
      | Glass, Ira    |  Tony Hawk      | Pending                           |
      | Krauss, Kyle  |  Tony Hawk      | Pending                           |
    When I reload the page
    Then the "Pending" option in the current status filter form should be selected
    And I should see the following data in the "Assessment Requests" table:
      | Customer name |  Submitter      | Status                            |
      | Himby, Hue    |  Louie Anderson | Pending                           |
      | Glass, Ira    |  Tony Hawk      | Pending                           |
      | Krauss, Kyle  |  Tony Hawk      | Pending                           |  

  @dmetaphone
  Scenario: Trainers can associate a request with a new customer
    When I click on the "Requests" link
      And I click the request from Glass, Ira
      And I click the customer change link
    Then I should see an empty list of similar customers
    When I click Continue to create a new customer
    Then I should see the first name set to Ira
      And I should see the last name set to Glass
    When I populate the customer details
    Then I should see the request associated with Glass, Ira

  Scenario: Trainers can create a case from an assessment request
    When I click on the "Requests" link
      And I click the request from Krauss, Kyle
      And I click on the "Create new coaching case..." link
      And I populate the coaching case details
    Then I should see a link to the case
