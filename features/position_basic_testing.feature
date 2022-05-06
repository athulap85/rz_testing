Feature: Position Basic Testing

  @done
  Scenario: TC_001 Validate All Values in Long position
      
        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id   | Name             | Participant    |
        | TC_001_Ins  | ACC_001_POBT | ACC_001_POBT     | HSBC           |

        When "Position_Updates" are submitted with following values
        | Instance ID | account               | quantity | price | value   | side | participant               |
        | TC_001_Ins1 | [TC_001_Ins.Name]     | 6000     | 5.0   | 30000.0 | LONG | [TC_001_Ins.Participant]  |

        Then response of the request "TC_001_Ins1" should be
        | Instance ID      | status   | subStatus   |
        | TC_001_Ins1_Res1 | POSTED   | PROCESSING  |

        Then "Position" messages are filtered by "level,participant,account" should be
        | Instance ID     | level   | participant                   | longPosition   | longValue | netPosition  | netValue | account                  | avgPrice |
        | TC_001_Ins1_Res2| ACCOUNT | [TC_001_Ins1.participant]     | 6000.0         | 30000.0   | 6000.0       | 30000.0  | [TC_001_Ins1.account]    | 5.0      |

		Given instance "ACC_001_POBT" of entity "Accounts" is deleted
    @wip
    Scenario: TC_002 Validate Short Position Calculation, Average price calculation when multiple short positions exist

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id        | Name              | Participant    |
        | TC_002_Ins1 | ACC_002_POBT      | ACC_002_POBT     | HSBC           |

        When "Position_Updates" are submitted with following values
        | Instance ID   | account               | quantity | price | value   | side  | participant                 |
        | TC_002_Ins2   | [TC_002_Ins1.Name]    | 600      | 50.0  | 30000.0 | SHORT |  [TC_002_Ins1.Participant]  |

        Then response of the request "TC_002_Ins2" should be
        | Instance ID      | status   | subStatus   |
        | TC_002_Ins2_Res1 | POSTED   | PROCESSING  |

       And "Position" messages are filtered by "level,participant,account" should be
        | Instance ID        | level   | participant               | shortPosition   | shortValue | netPosition  | netValue | avgPrice | account                 |
        | TC_002_Ins2_Res2   | ACCOUNT | [TC_002_Ins2.participant] | 600.0           | 30000.0    | -600.0       | -30000.0 | 50.0     | [TC_002_Ins2.account]   |

        When "Position_Updates" are submitted with following values
        | Instance ID   | account                  | quantity | price | value   | side  | participant               |
        | TC_002_Ins3   | [TC_002_Ins1.Name]       | 1000     | 51.0  | 51000.0 | SHORT |  [TC_002_Ins1.Participant]|

        Then response of the request "TC_002_Ins3" should be
        | Instance ID      | status   | subStatus   |
        | TC_002_Ins3_Res1 | POSTED   | PROCESSING  |

         And "Position" messages are filtered by "level,participant,account,shortPosition" should be
        | Instance ID       | level   | participant              | shortPosition   | shortValue | netPosition  | netValue  | avgPrice    | account                 |
        | TC_002_Ins3_Res2  | ACCOUNT | [TC_002_Ins2.participant]| 1600.0          | 81000.0    | -1600.0      | -81000.0  | 50.625      | [TC_002_Ins2.account]   |

      Given instance "ACC_002_POBT" of entity "Accounts" is deleted

    Scenario: TC_003 Validate Long Position Calculation, Average price calculation when multiple long positions exist

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID  | Account Id        | Name             | Participant    |
        | TC_003_Ins1  | ACC_003_POBT      | ACC_003_POBT     | HSBC           |

        When "Position_Updates" are submitted with following values
        | Instance ID  | account   				  | quantity | price | value   | side  | participant                |
        | TC_003_Ins2  | [TC_003_Ins1.account]    | 600      | 50.0  | 30000.0 | LONG  |  [TC_003_Ins1.participant] |

        Then response of the request "TC_003_Ins2" should be
        | Instance ID       | status   | subStatus   |
        | TC_003_Ins2_Res1  | POSTED   | PROCESSING  |

        And  "Position" messages are filtered by "level,participant,account" should be
        | Instance ID         | level   | participant              | longPosition   | longValue  | netPosition  | netValue | avgPrice | account                 |
        | TC_003_Ins2_Res2    | ACCOUNT | [TC_003_Ins1.participant]| 600.0          | 30000.0    | 30000.0      | 30000.0  | 50.0     | [TC_003_Ins1.account]   |

        When "Position_Updates" are submitted with following values
        | Instance ID  | account  				  | quantity | price | value   | side  | participant |
        | TC_003_Ins3  | [TC_003_Ins1.account]    | 1000     | 51.0  | 51000.0 | LONG  |  HSBC       |

        Then response of the request "TC_003_Ins3" should be
        | Instance ID       | status   | subStatus   |
        | TC_003_Ins3_Res1  | POSTED   | PROCESSING  |

         Then "Position" messages are filtered by "level,participant,account" should be
        | Instance ID         | level   | participant               | longPosition    | longValue  | netPosition  | netValue  | avgPrice    | account                 |
        | TC_003_Ins3_Res2    | ACCOUNT | [TC_003_Ins1.participant] | 1600.0          | 81000.0    | 1600.0       | 810000.0  | 50.625      | [TC_003_Ins1.account]   |

        Given instance "ACC_003_POBT" of entity "Accounts" is deleted

    Scenario: TC_POBT_1.2. Validate Position Calculation, Average price calculation when both short and long positions exist for same Account

       Given instance "HNKG_7" of entity "Accounts" is deleted

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id  | Name       | Participant    |
        | Acc_01      | HNKG_7      | HNKG_7     | HSBC           |

        When "Position_Updates" are submitted with following values
        | Instance ID   | account   | quantity | price | value   | side  | participant |
        | PU_Short1     | HNKG_7    | 600      | 50.0  | 30000.0 | SHORT |  HSBC       |

        And "Position_Updates" are submitted with following values
        | Instance ID  | account   | quantity | price | value   | side  | participant |
        | PU_Long1     | HNKG_7    | 1000     | 51.0  | 51000.0 | LONG  |  HSBC       |

        Then response of the request "PU_Long1" should be
        | Instance ID    | status   | subStatus   |
        | PU_Long1_Res1  | POSTED   | PROCESSING  |

        Then response of the request "PU_Short1" should be
        | Instance ID     | status   | subStatus   |
        | PU_Short1_Res1  | POSTED   | PROCESSING  |

        Then "Position" messages are filtered by "level,participant,account" should be
        | Instance ID       | level   | participant   | shortPosition   | shortValue | netPosition  | netValue | avgPrice | account  |
        | PU_Short1_Res1    | ACCOUNT | HSBC          | 600             | 30000.0    | -600         | -30000.0 | 50.0     | HNKG_7   |

         Then "Position" messages are filtered by "level,participant,account" should be
        | Instance ID      | level   | participant   | shortPosition   | longPosition | shortValue | longValue  | netPosition  | netValue  | avgPrice    | account  |
        | PU_Long1_Res1    | ACCOUNT | HSBC          | 600             | 1000		  | 30000.0    | 51000.0    | 400          | 21000.0   | 35.0        | HNKG_7   |

      @final
       Scenario: TC_POBT_3.1. (+4.1) Validate  Average Price,MTM value and CVM value for positive net Positions

#        Given instance "Home" of entity "Accounts" is copied with following values
#        | Instance ID | Account Id   | Name       | Participant    |
#        | HSBC-H1    | HSBC-H1       | HSBC-H1     | HSBC           |

		 Given  "Risk_Factor_Updates" are submitted with following values
        | Instance ID | symbol      | type   | value |
        | MD_Req1     | SYM_002     | LTP    | 100.0 |
		| MD_Req2     | SYM_002     | AI     | 2.0   |

        When "Position_Updates" are submitted with following values
        | Instance ID | account    | symbl   |  quantity  | price | value   | side | participant |
        | PU_Long     | HSBC-H1    | SYM_002 | 600        | 50.0  | 30000.0 | LONG |  HSBC       |

         Then response of the request "PU_Long" should be
        | Instance ID  | status   | subStatus   |
        | PU_Long_Res1 | POSTED   | PROCESSING  |

        Then "Position" messages are filtered by "level,participant,account" should be
        | Instance ID     | level   | participant   | longPosition   | longValue | netPosition  | netValue | avgPrice |  mtmValue  | cvm     | account   |
        | PU_Long_Res2    | ACCOUNT | HSBC          | 600.0          | 30000.0   | 600.0        | 30000.0  | 50.0     |  61200.0   | 31200.0 | HSBC-H1   |


         @finals
       Scenario: TC_POBT_3.2. (+4.2) Validate Average Price,MTM value and CVM value for negative net Positions

#        Given instance "Home" of entity "Accounts" is copied with following values
#        | Instance ID | Account Id   | Name       | Participant    |
#        | HSBC-H1    | HSBC-H1       | HSBC-H1     | HSBC           |

#		 Given  "Risk_Factor_Updates" are submitted with following values
#        | Instance ID | symbol      | type   | value |
#        | MD_Req1     | SYM_002     | LTP    | 100.0 |
#		| MD_Req2     | SYM_002     | AI     | 2.0   |

        When "Position_Updates" are submitted with following values
        | Instance ID | account    | symbol   |  quantity  | price | value   | side  | participant |
        | PU_Long     | HSBC-H1    | TSL_0.7_07-06-46| 600        | 50.0  | 30000.0 | SHORT |  TEST_HSBC       |

         Then response of the request "PU_Long" should be
        | Instance ID  | status   | subStatus   |
        | PU_Long_Res1 | POSTED   | PROCESSING  |

        Then "Position" messages are filtered by "level,participant,account" should be
        | Instance ID     | level   | participant   | shortPosition   | shortValue | netPosition  | netValue  | avgPrice  | mtmValue   | cvm      | account   |
        | PU_Long_Res2    | ACCOUNT | HSBC          | 600.0           | 30000.0    | -600.0       | -30000.0  | 50.0      | -61200.0   | -31200.0 | HSBC-H1   |
