Feature: sensor data
  In order to view see the latest sensor data
  As a consumer of sensor data
  I should be able to see updates sent from sensors immediately

  Scenario: the first sensor update is sent
    Given the sensor named "test-first" has no previous data
    When the sensor sends a temperature measurement of 28
    And I request the latest temperature measurement for "test-first"
    Then the measurement should equal 28
