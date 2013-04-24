@wip
Feature: User views order log

  Scenario: User is authorized
    Given an order log has been uploaded
    Given I am an authorized user

    When I sign in
    And I choose to view the order log details

    Then I see a listing of each order in the log

  Scenario: User is not authorized
    Given an order log has been uploaded
    Given I am an unauthorized user

    When I sign in
    And I choose to view the order log details

    Then I am informed that I am unauthorized
    And I do not see the order log details
