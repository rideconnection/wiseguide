# Running this test requires that the test database is using the postgresql 
# adapter and that the dmetaphone "fuzzystrmatch" functions have been 
# installed into the test database. Because of this restriction, the default
# cucumber profile will ignore tests with the @dmetaphone tag. In order to 
# include these scenarios use the dmetaphone profile in your cucumber command:
# `cucumber features/customer_search.feature -p dmetaphone`

@dmetaphone
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
      And I click the "Search" button
    Then I should see the following customers in the customers table:
      | Name                  |
      | Bradey Sr., Robert    |
      | Bradey, Jr., Bob      |
      | Christchurch, Bradley |
      | Roberts, Brady        |
