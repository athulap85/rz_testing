Feature: Position Basic Testing

   @done
   Scenario: TC_001 Validate All Values in Long position
      
        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id     | Name               | Participant    |
        | TC_001_Ins  | random(ACC,6)  | random(ACN,6)       | HSBC           |

       When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol         | type   | value |
        | TC_001_MD1 | Bond_Test_5     | LTP    | 100.0 |
		| TC_001_MD2 | Bond_Test_5     | AI     | 2.0   |

        When "Position Update" messages are submitted with following values
        | Instance ID | account                 | quantity | price | value   | side | participant               | notional  |
        | TC_001_Ins1 | [TC_001_Ins.Account Id] | 6000     | 5.0   | 30000.0 | LONG | [TC_001_Ins.Participant]  | 10        |

        Then response of the request "TC_001_Ins1" should be
        | Instance ID      | status   | subStatus   |
        | TC_001_Ins1_Res1 | POSTED   | PROCESSING  |

        Then "Position" messages are filtered by "level,participant,account" should be
        | Instance ID     | level   | participant                   | longPosition   | longValue | netPosition  | netValue | account                  | avgPrice |
        | TC_001_Ins1_Res2| ACCOUNT | [TC_001_Ins1.participant]     | 6000.0         | 30000.0   | 6000.0       | 30000.0  | [TC_001_Ins1.account]    | 5.0      |

		Given instance "[TC_001_Ins.Account Id]" of entity "Accounts" is deleted

    @done
    Scenario: TC_002 Validate Short Position Calculation, Average price calculation when multiple short positions exist

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id        | Name              | Participant    |
        | TC_002_Ins1 | random(ACC,6)    | random(ACN,6)    | HSBC           |

        When "Position Update" messages are submitted with following values
        | Instance ID   | account                  | quantity | price | value   | side  | participant                 | notional  |
        | TC_002_Ins2   | [TC_002_Ins1.Account Id] | 600      | 50.0  | 30000.0 | SHORT |  [TC_002_Ins1.Participant]  |  10       |

        Then response of the request "TC_002_Ins2" should be
        | Instance ID      | status   | subStatus   |
        | TC_002_Ins2_Res1 | POSTED   | PROCESSING  |

       And "Position" messages are filtered by "level,participant,account" should be
        | Instance ID        | level   | participant               | shortPosition   | shortValue | netPosition  | netValue | avgPrice | account                 |
        | TC_002_Ins2_Res2   | ACCOUNT | [TC_002_Ins2.participant] | 600.0           | 30000.0    | -600.0       | -30000.0 | 50.0     | [TC_002_Ins2.account]   |

        When "Position Update" messages are submitted with following values
        | Instance ID   | account                   | quantity | price | value   | side  | participant               | notional  |
        | TC_002_Ins3   | [TC_002_Ins1.Account Id]  | 1000     | 51.0  | 51000.0 | SHORT |  [TC_002_Ins1.Participant]|  10       |

        Then response of the request "TC_002_Ins3" should be
        | Instance ID      | status   | subStatus   |
        | TC_002_Ins3_Res1 | POSTED   | PROCESSING  |

         And "Position" messages are filtered by "level,participant,account" should be
        | Instance ID       | level   | participant              | shortPosition   | shortValue | netPosition  | netValue  | avgPrice    | account                 |
        | TC_002_Ins3_Res2  | ACCOUNT | [TC_002_Ins2.participant]| 1600.0          | 81000.0    | -1600.0      | -81000.0  | 50.625      | [TC_002_Ins2.account]   |

      Given instance "[TC_002_Ins1.Account Id]" of entity "Accounts" is deleted

      @done
    Scenario: TC_003 Validate Long Position Calculation, Average price calculation when multiple long positions exist

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID  | Account Id          | Name             | Participant    |
        | TC_003_Ins1  | random(ACC,6)      | random(ACC,6)     | HSBC           |

        When "Position Update" messages are submitted with following values
        | Instance ID  | account   				  | quantity | price | value   | side  | participant                |  notional  |
        | TC_003_Ins2  | [TC_003_Ins1.Account Id] | 600      | 50.0  | 30000.0 | LONG  |  [TC_003_Ins1.Participant] |  10        |

        Then response of the request "TC_003_Ins2" should be
        | Instance ID       | status   | subStatus   |
        | TC_003_Ins2_Res1  | POSTED   | PROCESSING  |

        And  "Position" messages are filtered by "level,participant,account" should be
        | Instance ID         | level   | participant              | longPosition   | longValue  | netPosition  | netValue | avgPrice | account                    |
        | TC_003_Ins2_Res2    | ACCOUNT | [TC_003_Ins2.participant]| 600.0          | 30000.0    | 600.0        | 30000.0  | 50.0     | [TC_003_Ins1.Account Id]   |

        When "Position Update" messages are submitted with following values
        | Instance ID  | account  				  | quantity | price | value   | side  | participant                 | notional  |
        | TC_003_Ins3  | [TC_003_Ins1.Account Id] | 1000     | 51.0  | 51000.0 | LONG  |  [TC_003_Ins1.Participant]  |  10       |

        Then response of the request "TC_003_Ins3" should be
        | Instance ID       | status   | subStatus   |
        | TC_003_Ins3_Res1  | POSTED   | PROCESSING  |

         Then "Position" messages are filtered by "level,participant,account,longPosition" should be
        | Instance ID         | level   | participant               | longPosition    | longValue  | netPosition  | netValue  | avgPrice    | account                 |
        | TC_003_Ins3_Res2    | ACCOUNT | [TC_003_Ins2.participant] | 1600.0          | 81000.0    | 1600.0       | 81000.0  | 50.625      | [TC_003_Ins1.Account Id]   |

        Given instance "[TC_003_Ins1.Account Id] " of entity "Accounts" is deleted

        @wip1
    Scenario: TC_004 Validate Position Calculation, Average price calculation when both short and long positions exist for same Account

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id     | Name          | Participant    |
        | TC_004_Ins1 | random(ACC,6)  | random(ACN,6) | HSBC           |

        When "Position Update" messages are submitted with following values
        | Instance ID   | account                     | quantity | price | value   | side  | participant                 | notional |
        | TC_004_Ins2   | [TC_004_Ins1.Account Id]    | 600      | 50.0  | 30000.0 | SHORT |  [TC_004_Ins1.Participant]  | 10       |

        Then response of the request "TC_004_Ins2" should be
        | Instance ID       | status   | subStatus   |
        | TC_004_Ins2_Res1  | POSTED   | PROCESSING  |

        And "Position" messages are filtered by "level,participant,account" should be
        | Instance ID         | level   | participant               | shortPosition   | shortValue | netPosition  | netValue | avgPrice | account                    |
        | TC_004_Ins2_Res2    | ACCOUNT |  [TC_004_Ins1.Participant]| 600.0           | 30000.0    | -600.0       | -30000.0 | 50.0     | [TC_004_Ins1.Account Id]   |

       When "Position Update" messages are submitted with following values
        | Instance ID  | account                     | quantity | price | value   | side  | participant                      | notional |
        | TC_004_Ins3  | [TC_004_Ins1.Account Id]    | 1000     | 51.0  | 51000.0 | LONG  |  [TC_004_Ins1.Participant]       |  10      |

      Then response of the request "TC_004_Ins3" should be
        | Instance ID       | status   | subStatus   |
        | TC_004_Ins3_Res1  | POSTED   | PROCESSING  |

       And "Position" messages are filtered by "level,participant,account,shortPosition,longPosition" should be
        | Instance ID         | level   | participant   | shortPosition   | longPosition  | shortValue | longValue  | netPosition  | netValue  | avgPrice    | account                    |
        | TC_004_Ins3_Res2    | ACCOUNT | HSBC          | 600.0           | 1000.0        | 30000.0    | 51000.0    | 400.0        | 21000.0   | 35.0        | [TC_004_Ins1.Account Id]   |

       Given instance "[TC_004_Ins1.Account Id] " of entity "Accounts" is deleted

    @wip
   Scenario: TC_005 Validate  Average Price,MTM value and CVM value for positive net Positions

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id   | Name          | Participant    |
        | TC_005_Ins1 | random(ACC,6)| random(ACN,6) | HSBC           |

       When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol          | type   | value |
        | TC_005_Ins2 | Bond_Test_1     | LTP    | 100.0 |
		| TC_005_Ins3 | Bond_Test_1     | AI     | 2.0   |

        When "Position Update" messages are submitted with following values
        | Instance ID | account                      | symbol                    |  quantity  | price | value   | side |   participant              | notional  |
        | TC_005_Ins4 | [TC_005_Ins1.Account Id]     | [TC_005_Ins2.symbol]      | 600        | 50.0  | 30000.0 | LONG |  [TC_005_Ins1.Participant] | 10        |

         Then response of the request "TC_005_Ins4" should be
        | Instance ID      | status   | subStatus   |
        | TC_005_Ins4_Res1 | POSTED   | PROCESSING  |

        Then "Position" messages are filtered by "level,participant,account" should be
        | Instance ID     | level   | participant               | longPosition   | longValue | netPosition  | netValue | avgPrice |  mtmValue  | cvm     | account                  |
        | TC_005_Ins4_Res2| ACCOUNT | [TC_005_Ins1.Participant] | 600.0          | 30000.0   | 600.0        | 30000.0  | 50.0     |  61200.0   | 31200.0 | [TC_005_Ins1.Account Id] |

		Given instance "[TC_005_Ins1.Account Id] " of entity "Accounts" is deleted


       @final
       Scenario: TC_006 Validate Average Price,MTM value and CVM value for negative net Positions

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id    | Name          | Participant    |
        | TC_006_Ins1 |  random(ACC,6)| random(ACN,6) | HSBC           |

		When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol      | type   | value |
        | TC_006_Ins2 | Bond_Test_2 | LTP    | 100.0 |
		| TC_006_Ins3 | Bond_Test_2 | AI     | 2.0   |

        When "Position Update" messages are submitted with following values
        | Instance ID | account                     | symbol                |  quantity  | price | value   | side  |  participant                |  notional  |
        | TC_006_Ins4 | [TC_006_Ins1.Account Id]    | [TC_006_Ins2.symbol]  | 600        | 50.0  | 30000.0 | SHORT |  [TC_006_Ins1.Participant]  |  10        |

         Then response of the request "TC_006_Ins4" should be
        | Instance ID      | status   | subStatus   |
        | TC_006_Ins4_Res1 | POSTED   | PROCESSING  |

        Then "Position" messages are filtered by "level,participant,account" should be
        | Instance ID         | level   | participant              | shortPosition   | shortValue | netPosition  | netValue  | avgPrice  | mtmValue   | cvm      | account                    |
        | TC_006_Ins4_Res2    | ACCOUNT | [TC_006_Ins1.Participant] | 600.0           | 30000.0    | -600.0       | -30000.0  | 50.0      | -61200.0   | -31200.0 | [TC_006_Ins1.Account Id]   |

        Given instance "[TC_006_Ins1.Account Id] " of entity "Accounts" is deleted

