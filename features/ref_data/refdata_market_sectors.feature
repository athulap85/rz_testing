Feature: refdata market sectors add edit delete instance

  Scenario: TC_001 create an new market sectors
    When instance of entity "Market Sectors" is created with following values
      | Instance ID | Market Sector Id | Description | Country |
      | MaS01       | Market Sector 1  | Bonds       | US      |

  Scenario: TC_002 create an new market sectors with same market sector ID
    When instance of entity "Market Sectors" is created with following values
      | Instance ID | Market Sector Id | Description | Country |
      | MaS02       | Market Sector 1  | Bonds       | UK      |

     Then the request should be rejected with the error "Market sector Id already exists."

   Scenario: TC_003 create an new market sectors with same market sector ID
    When instance of entity "Market Sectors" is created with following values
      | Instance ID | Description | Country |
      | MaS02       | Bonds       | UK      |

     Then the request should be rejected with the error "Market Sector Id is required."

   Scenario: TC_004 create an new market sectors with country not in drop down
    When instance of entity "Market Sectors" is created with following values
      | Instance ID | Description | Country | Market Sector Id |
      | MaS02       | Bonds       | CAD      | Market Sector 2 |

     Then the request should be rejected with the error "Country not availble"
#fails as bad request

  Scenario: TC_011 Deleting instances
    Given instance "Market Sector 1" of entity "Market Sectors" is deleted