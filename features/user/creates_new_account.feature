Feature: User creates new account

  Scenario: Main
    Given I do not have a user account
    And there is an administrator

    When I register for a new account

    Then I am informed that my new account is created
    And I am in limbo
    And the admin receives an email announcing me as a new user