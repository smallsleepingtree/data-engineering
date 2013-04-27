Feature: User uploads file

  Scenario: User is authorized, file is valid
    Given I am an authorized user

    When I sign in
    And I choose to upload a new file
    And I upload a valid file

    Then I see a confirmation message
    And I see the file in the list of recent uploads
    And I see the gross revenue from the uploaded file

  Scenario: User is authorized, file is invalid
    Given I am an authorized user

    When I sign in
    And I choose to upload a new file
    And I upload an invalid file

    Then I see an error message
    And I don't see the file in the list of recent uploads

  Scenario: User is not authorized
    Given I am an unauthorized user

    When I sign in
    And I choose to upload a new file

    Then I am informed that I am unauthorized
    And I am not able to upload a file

  Scenario: User is not signed in
    Given I do not have a user account

    When I choose to upload a new file

    Then I am asked to sign in