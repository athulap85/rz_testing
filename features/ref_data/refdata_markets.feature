Feature: refdata markets add edit delete instance

  Scenario: TC_001 create an new market
    When instance of entity "Markets" is created with following values
      | Instance ID | Market Id | Description |
      | Mar01       | CSE       | Colombo     |

  Scenario: TC_002 create an new market with same market ID
    When instance of entity "Markets" is created with following values
      | Instance ID | Market Id | Description |
      | Mar02       | CSE       | Town        |

    Then the request should be rejected with the error "Market Id already exists."

   Scenario: TC_003 create an new market without market Id
    When instance of entity "Markets" is created with following values
      | Instance ID | Description |
      | Mar02       | Town        |

    Then the request should be rejected with the error "Market Id is Required."

   Scenario: TC_004 create an new market without description
    When instance of entity "Markets" is created with following values
      | Instance ID | Market Id |
      | Mar02       | DSE       |

  Scenario: TC_011 Deleting instances
    Given instance "CSE" of entity "Markets" is deleted
    Given instance "DSE" of entity "Markets" is deleted