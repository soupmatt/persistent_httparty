Feature: Persistent HTTP Connections

  Scenario:
    Given I have an http end point "http://www.example.com/api/thing.json"
    And I perform a "get" against that end point
    And The end point returns "application/json"
    """
    {"name":"foo", "type":"thing"}
    """
    When I visit that end point with HTTParty
    Then the parsed_response contains
      | name | foo   |
      | type | thing |
