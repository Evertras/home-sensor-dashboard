Feature: simple site
  In order to view the latest sensor data
  As a user that wants to see current data
  I should be able to see a simple website that contains the latest data

  # TODO: clear out DB before each for cleaner tests

  Scenario: two sensors have data
    Given there are sensors that sent measurements:
      | name   | TemperatureC | Humidity100 |
      | test-1 | 22 | 38 |
      | test-2 | 25 | 80 |
    When I request the simple site
    Then the status code should be 200
    # TODO: this is fragile/bad, but just to start...
    And the page should contain data:
      | test-1 | 22 | 38 |
      | test-2 | 25 | 80 |

  Scenario: the page shows fahrenheit
    Given there are sensors that sent measurements:
      | name   | TemperatureC | Humidity100 |
      | test-f | 30 | 72 |
    When I request the simple site
    Then the status code should be 200
    And the page should contain data:
      # 28 C ~= 82 F
      | test-f | 30 | 86 |
