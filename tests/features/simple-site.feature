Feature: simple site
  In order to view the latest sensor data
  As a user that wants to see current data
  I should be able to see a simple website that contains the latest data

  Scenario: two sensors have data
    Given there are sensors that sent measurements:
      | name   | TemperatureC | Humidity100 |
      | test-1 | 22 | 38 |
      | test-2 | 25 | 80 |
