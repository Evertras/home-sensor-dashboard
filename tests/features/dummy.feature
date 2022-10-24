Feature: dummy
  In order to gain confidence our infrastructure is valid
  As a developer
  I should be able to access the dummy endpoint successfully

  Scenario: the dummy endpoint is called
    When I call the dummy endpoint
    Then the status code should be 200
