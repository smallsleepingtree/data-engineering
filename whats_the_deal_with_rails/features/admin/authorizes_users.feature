Feature: Admin authorizes users

  Scenario: Authorize pending user
    Given there is a user pending authorization
    And I am an administrator

    When I sign in
    And I choose to view the authorization pending list

    Then I see the user in the authorization pending list

    When I choose to authorize the user's request

    Then the user is authorized to upload files
    And the user receives an email about their approved authorization
    And I don't see the user in the authorization pending list

  Scenario: Reject pending user
    Given there is a user pending authorization
    And I am an administrator

    When I sign in
    And I choose to view the authorization pending list

    Then I see the user in the authorization pending list

    When I choose to reject the user's request

    Then the user is not authorized to upload files
    And the user receives an email about their rejected authorization
    And I don't see the user in the authorization pending list

  Scenario: Non-admin tries to authorize
    Given I am an authorized user

    When I sign in
    And I choose to view the authorization pending list

    Then I am informed that I am unauthorized
