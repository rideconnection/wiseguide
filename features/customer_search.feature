Feature: Customer search
  In order to make the workflow more efficient
  trainers and admins
  want to be able to search for a customer
  
  Background:
    Given I am logged in as a trainer
      And the following customers exist:
        | first_name  | last_name          |
        | Donna       | Jennings           |
        | Jennifer    | Donnings           |
        | Robert      | Bradey Sr.         |
        | Bobby       | O'Brady            |
        | Bradley     | Christchurch       |
        | Carl        | Bobson             |
        | Bob         | Bradey, Jr.        |
        | Christopher | Carlson            |
        | Brady       | Roberts            |
      And I am on the customers page
      
  Scenario: Customers are unfiltered by default
    Then I should see the following customers in the customers table:
      | Name                  |
      | Bobson, Carl          |
      | Bradey Sr., Robert    |
      | Bradey, Jr., Bob      |
      | Carlson, Christopher  |
      | Christchurch, Bradley |
      | Donnings, Jennifer    |
      | Jennings, Donna       |
      | O'Brady, Bobby        |
      | Roberts, Brady        |

  Scenario: Searching limits the displayed customers
    When I enter "brad" into the search box
      And I click the "Search" button in the customer search form
    Then I should see the following customers in the customers table:
      | Name                  |
      | Bradey Sr., Robert    |
      | Bradey, Jr., Bob      |
      | Christchurch, Bradley |
      | Roberts, Brady        |

  @javascript
  Scenario: Customer matches when creating a new customer
    When I click on the "New Customer" link
    And I fill in something close to Carl's name
    And I should see "Bobson, Carl"
