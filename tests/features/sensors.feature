Feature: sensor data
  In order to view see the latest sensor data
  As a consumer of sensor data
  I should be able to see updates sent from sensors immediately

  Scenario: an unsupported measurement type is sent
    Given a sensor named "test-bad"
    And the sensor has no previous data
    When the sensor sends a bad temperature measurement of 70
    Then the status code should be 400

  Scenario: no sensor data exists
    Given a sensor named "test-none"
    And the sensor has no previous data
    When I request the latest TemperatureC measurement for "test-none"
    Then the measurement should not be found

  Scenario: the first sensor update is sent
    Given a sensor named "test-first"
    And the sensor has no previous data
    When the sensor sends a TemperatureC measurement of 28
    And I request the latest TemperatureC measurement for "test-first"
    Then the measurement should equal 28

  Scenario: multiple measurement kinds are sent
    Given there are sensors that sent measurements:
      | name | TemperatureC | Humidity100 |
      | test-multi | 21 | 54 |
    When I request the latest TemperatureC measurement for "test-multi"
    Then the measurement should equal 21
