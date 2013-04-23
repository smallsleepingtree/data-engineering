Feature: User creates new account

  Scenario: Main
    When I register for a new account

    Then I see a confirmation
    And I am an unauthorized user
    And the admin receives an email announcing me as a new user