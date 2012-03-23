Feature: System Reports
  In order to provide insight into the application
  System administrators
  Want to run customized reports
  
  Scenario: "Monthly Transportation Report"
    Given I am logged in as an admin
      And the following customers exist:
        | id | first_name | last_name |
        | 1  | Bob        | Villa     |
        | 2  | Barty      | Crouch    |
        | 3  | Darth      | Vader     |
        | 4  | Master     | Chief     |
      And the following open coaching cases exist:
        | id | open_date               | assessment_date | case_manager_notification_date | customer_id |
        | 1  | 2010-12-31              | 2010-12-31      | 2010-12-31                     | 1           |
        | 3  | 2011-01-01              | 2011-01-02      | 2011-01-02                     | 2           |
        | 6  | 2011-01-30              | 2011-02-01      | 2011-02-01                     | 3           |
        | 7  | 2011-04-02              | 2011-04-02      | 2011-01-02                     | 4           |
      And the following closed coaching cases exist:
        | id | open_date  | close_date | assessment_date | case_manager_notification_date | customer_id |
        | 2  | 2010-12-31 | 2011-01-01 | 2011-01-01      | 2011-01-01                     | 3           |
        | 4  | 2011-01-01 | 2011-01-02 | 2011-01-01      | 2011-01-02                     | 1           |
        | 5  | 2011-01-30 | 2011-02-01 | 2011-02-01      | 2011-02-01                     | 2           |
      And the following assessment requests exist:
        | id | customer_first_name | customer_last_name | customer_id | kase_id | created_at |
        | 1  | Robert              | Villa              | 1           | 1       | 2010-12-01 |
        | 2  | Barty               | Crouch             | 2           | 3       | 2010-12-20 |
        | 3  | Darth               | Vader              | 3           | 2       | 2010-12-30 |
      And the following contact events exist:
        | customer_id | kase_id | date_time  | description   |
        | 1           |         | 2010-11-01 | I just called |
        | 1           | 1       | 2011-01-01 | To say        |
        | 2           | 3       | 2011-01-02 | I love you    |
        | 2           | 5       | 2011-01-21 | I just called |
        | 3           | 2       | 2010-12-30 | To say        |
        | 3           | 2       | 2011-01-01 | How much      |
        | 4           | 7       | 2011-01-30 | I care        |
      And I am on the homepage
    When I click on the "Reports" link
      And I submit the "Monthly Transportation Report" form with a date range of "2011-01-01" to "2011-01-30"
    Then I should see the following report:
        | Customer Name | Referral Date | First Contact | Assessment Date | CMO Notified |
        | Vader, Darth  | 2010-12-30    | 2010-12-30    | 2011-01-01      | 2011-01-01   |
        | Villa, Bob    |               |               | 2011-01-01      | 2011-01-02   |
        | Crouch, Barty | 2010-12-20    | 2011-01-02    | 2011-01-02      | 2011-01-02   |
