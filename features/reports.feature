Feature: System Reports
  In order to provide insight into the application
  System administrators
  Want to run customized reports
  
  Scenario: Monthly Transportation Report
    Given I am logged in as an admin
      And the following customers exist:
        | id | first_name | last_name |
        | 1  | Bob        | Villa     |
        | 2  | Barty      | Crouch    |
        | 3  | Darth      | Vader     |
        | 4  | Master     | Chief     |
      And the following open coaching kases exist:
        | id | open_date               | assessment_date | case_manager_notification_date | customer_id |
        | 1  | 2010-12-31              | 2010-12-31      | 2010-12-31                     | 1           |
        | 3  | 2011-01-01              | 2011-01-02      | 2011-01-02                     | 2           |
        | 6  | 2011-01-30              | 2011-02-01      | 2011-02-01                     | 3           |
        | 7  | 2011-04-02              | 2011-04-02      | 2011-01-02                     | 4           |
      And the following closed coaching kases exist:
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
        | contactable_type | contactable_id | date_time  | description   |
        | Customer         | 1              | 2010-11-01 | I just called |
        | CoachingKase     | 1              | 2011-01-01 | To say        |
        | CoachingKase     | 3              | 2011-01-02 | I love you    |
        | CoachingKase     | 5              | 2011-01-21 | I just called |
        | CoachingKase     | 2              | 2010-12-30 | To say        |
        | CoachingKase     | 2              | 2011-01-01 | How much      |
        | CoachingKase     | 7              | 2011-01-30 | I care        |
      And I am on the homepage
    When I click on the "Reports" link
      And I submit the "Monthly Transportation Report" form with a date range of "2011-01-01" to "2011-01-30"
    Then I should see the following report in the "Monthly Transportation Report" table:
        | Customer Name | Referral Date | First Contact | Assessment Date | CMO Notified |
        | Vader, Darth  | 2010-12-30    | 2010-12-30    | 2011-01-01      | 2011-01-01   |
        | Villa, Bob    |               |               | 2011-01-01      | 2011-01-02   |
        | Crouch, Barty | 2010-12-20    | 2011-01-02    | 2011-01-02      | 2011-01-02   |

  Scenario: Customer Referral Report
    Given I am logged in as an admin
      And the following government organization exists:
        | id | name      |
        | 99 | Obamacare | 
      And the following case management organizations exist:
        # Start IDs at a high number to leave room for the parent orgs that
        # FactoryGirl will create automatically.
        # Matched: 91, 92, 93, 94
        | id | name                                    | parent_id |
        | 90 | Foo's Unique Organization               | 99        |
        | 91 | Uncle Bob's Discount Services           | 99        |
        | 92 | Homestar Runner Dot Org - It's Dot Com! | 99        |
        | 93 | Little Helpers Help Big                 | 99        |
        | 94 | The Ketchup Seed                        | 99        |
        | 95 | Jim Halper's Halping Hands              | 99        |
      And the following case managers exist:
        # Start IDs at a high number to leave room for the admin and trainer
        # users that FactoryGirl will create automatically.
        # Matched: 91, 92, 93, 94
        | id | organization_id |
        | 90 | 90              |
        | 91 | 91              |
        | 92 | 92              |
        | 93 | 93              |
        | 94 | 94              |
        | 95 | 95              |
      And the following customers exist:
        # Matched: 2, 3, 4, 5, 6, 8
        | id |
        | 1  |
        | 2  |
        | 3  |
        | 4  |
        | 5  |
        | 6  |
        | 7  |
        | 8  |
      And the following open coaching kases exist:
        # Matched: 2, 3, 4, 5, 6, 7, 8, 11
        | id | open_date               | assessment_date | customer_id | 
        | 1  | 2010-12-31              | 2010-12-31      | 1           |
        | 2  | 2010-12-31              | 2011-01-01      | 2           |
        | 3  | 2011-01-01              | 2011-01-01      | 2           |
        | 4  | 2011-01-02              | 2011-01-02      | 3           |
        | 5  | 2011-01-03              | 2011-01-03      | 4           |
        | 6  | 2011-01-04              | 2011-01-04      | 4           |
        | 7  | 2011-01-05              | 2011-01-05      | 5           |
        | 8  | 2011-01-30              | 2011-01-30      | 6           |
        | 9  | 2011-01-30              | 2011-02-01      | 6           |
        | 10 | 2011-02-01              | 2011-02-01      | 7           |
      And the following closed coaching kases exist:
        | id | open_date  | close_date | assessment_date | customer_id |
        | 11 | 2011-01-01 | 2011-01-01 | 2011-01-01      | 8           |
        | 12 | 2011-01-30 | 2011-02-01 | 2011-02-01      | 8           |
      And the following assessment requests exist:
        # Matched: 2, 3, 4, 5, 6, 9
        | id | customer_id | kase_id | submitter_id |
        | 1  | 1           | 1       | 90           |
        | 2  | 2           | 3       | 91           |
        | 3  | 3           | 4       | 92           |
        | 4  | 4           | 5       | 93           |
        | 5  | 5           | 7       | 94           |
        | 6  | 6           | 8       | 94           |
        | 7  | 6           | 9       | 94           |
        | 8  | 7           | 10      | 90           |
        | 9  | 8           | 11      | 91           |
      And the following resources exist:
        # Matched: 1, 2, 3, 4, 6, 7, 8, 9, 10
        | id | name         |
        | 1  | PETA         |
        | 2  | WWE          |
        | 3  | WWF          |
        | 4  | FEMA         |
        | 5  | CDC          |
        | 6  | ROFL         |
        | 7  | BAMF         |
        | 8  | DIHC         |
        | 9  | FORD         |
        | 10 | PRON         |
      And the following referral document associations exist:
        # Matched: 2, 3, 4, 5, 6, 7, 8, 11, 14, 15, 16, 17, 18, 19, 20
        | id | kase_id | resource_ids   |
        | 1  | 1       | 1, 2, 3, 4, 5  |
        | 2  | 2       | 6, 7, 8        |
        | 3  | 3       | 9, 10, 1       |
        | 4  | 4       | 2              |
        | 5  | 5       | 3, 4, 6, 7     |
        | 6  | 6       | 8              |
        | 7  | 7       | 9              |
        | 8  | 8       | 10, 1, 2, 3, 4 |
        | 9  | 9       | 5, 6           |
        | 10 | 10      | 5              |
        | 11 | 11      | 7              |
        | 12 | 12      | 8              |
        | 13 | 1       | 9              |
        | 14 | 2       | 10             |
        | 15 | 3       | 1              |
        | 16 | 4       | 2, 3, 4        |
        | 17 | 5       | 6              |
        | 18 | 6       | 7              |
        | 19 | 7       | 8, 9           |
        | 20 | 8       | 10             |
      And I am on the homepage
    When I click on the "Reports" link
      And I submit the "Customer Referral Report" form with a date range of "2011-01-01" to "2011-01-30"
    Then I should see the following report in the "Assessments Performed" table:
        # a calculation of the number of coaching cases that have an 
        # assessment date within the specified date range
        | Assessments Performed |
        | 8                     |
      And I should see the following report in the "Referral Sources" table:
        # customers with cases which have an assessment date within the date 
        # range specified, using the CMO of the case manager that created the 
        # initial assessment request
        | Referral Source                         | Customers Assessed |
        | Homestar Runner Dot Org - It's Dot Com! | 1                  |
        | Little Helpers Help Big                 | 1                  |
        | The Ketchup Seed                        | 2                  |
        | Uncle Bob's Discount Services           | 2                  |
      And I should see the following report in the "Services Referred" table:
        # the number of customers who have case files which have referral 
        # documents which reference each given resource, based on the 
        # assessment date listed in the case that the referral document 
        # belongs to
        | Service Name | Customers Referred |
        | BAMF         | 3                  |
        | DIHC         | 3                  |
        | FEMA         | 3                  |
        | FORD         | 2                  |
        | PETA         | 2                  |
        | PRON         | 2                  |
        | ROFL         | 2                  |
        | WWE          | 2                  |
        | WWF          | 3                  |
