Feature: Position Basic Testing



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

