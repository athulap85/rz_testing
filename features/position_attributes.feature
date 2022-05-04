Feature: Position Attributes

   @nuwan
   Scenario: TC_001 Validating PositionID ( not ran)

        When "Position_Updates" are submitted with following values
        | Instance ID    | symbol     | quantity | price | side | participant | account  |
        | TC_001_Ins1    | ACH        | 1000     | 50.0  | SHORT|  HSBC       | Home_NK9     |

       Then response of the request "TC_001_Ins1" should be
        | Instance ID       | status    | subStatus            |
        | TC_001_Ins1_Res1  | POSTED    | PROCESSING           |

        Then "Position" messages are filtered by "level,account,participant" should be
        | Instance ID      | symbol     		   | level    | account | participant                | shortPosition         | netPosition| positionId  |
        | TC_001_Ins1_Res2 | [TC_001_Ins1.symbol]  | ACCOUNT  | Home_NK9| [TC_001_Ins1.participant]  | [TC_001_Ins1.quantity]| -1000.0    | exists      |


    Scenario: TC_002 Validating Position Type - Margin

        When "Position_Updates" are submitted with following values
        | Instance ID    | symbol      | quantity | price | side | participant | type   |
        | TC_002_Ins1    | ACIC        | 1000     | 50.0  | SHORT|  HSBC       | MARGIN |

        Then response of the request "TC_001_Ins1" should be
        | Instance ID       | status    | subStatus            |
        | TC_002_Ins1_Res1  | POSTED    | PROCESSING           |


        Then "Position" messages are filtered by "symbol,level,account,participant,type,shortPosition,netPosition" should be
        | Instance ID      | symbol                   | level    | account                       | participant                     | type   | shortPosition              | netPosition|
        | TC_002_Ins1_Res2 | [TC_002_Ins1_Res1.symbol]| ACCOUNT  | [TC_002_Ins1_Res1.account]    | [TC_002_Ins1_Res1.participant]  | MARGIN | [TC_002_Ins1_Res1.quantity]| -1000.0    |

    Scenario: TC_003 Validating Position Type - Collateral ? Failed due to a business validation of collateral

        When "Position_Updates" are submitted with following values
        | Instance ID    | symbol      | quantity | price | side | participant | type       | account         |
        | TC_003_Ins1    | ACIC        | 1000     | 50.0  | SHORT|  HSBC       | COLLATERAL | Home-Collateral |

        Then "Position" messages are filtered by "symbol,level,account,participant,type,shortPosition,netPosition" should be
        | Instance ID       | symbol                 | level    | account                  | participant               | type       | shortPosition   | netPosition|
        | TC_003_Ins1_Res1  | [TC_003_Ins1.symbol]   | ACCOUNT  | [TC_003_Ins1.account]    | [TC_003_Ins1.participant] | COLLATERAL | 1000.0          | -1000.0    |

    Scenario: TC_004 Validate All Values in Long position


        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id   | Name       | Participant    |
        | TC_004_Ins1 | HNKG_3       | HNKG_3     | HSBC           |

        When "Position_Updates" are submitted with following values
        | Instance ID | account               | quantity | price | value   | side | participant               |
        | TC_004_Ins2 | [TC_004_Ins1.account] | 6000     | 50.0  | 30000.0 | LONG | [TC_004_Ins1.participant] |

        Then response of the request "TC_004_Ins2" should be
        | Instance ID      | status   | subStatus   |
        | TC_004_Ins2_Res1 | POSTED   | PROCESSING  |

        Then "Position" messages are filtered by "level,participant,account" should be
        | Instance ID     | level   | participant                   | longPosition   | longValue | netPosition  | netValue | account                 |
        | TC_004_Ins2_Res2| ACCOUNT | [TC_004_Ins1.participant]     | 6000.0         | 30000.0   | 6000.0       | 30000.0  | [TC_004_Ins1.account]   |

		Given instance "HNKG_3" of entity "Accounts" is deleted


    Scenario: TC_005 Validate Short Position Calculation, Average price calculation when multiple short positions exist

       Given instance "HNKG_5" of entity "Accounts" is deleted

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id  | Name       | Participant    |
        | TC_005_Ins1 | HNKG_5      | HNKG_5     | HSBC           |

        When "Position_Updates" are submitted with following values
        | Instance ID   | account               | quantity | price | value   | side  | participant                 |
        | TC_005_Ins2   | [TC_005_Ins1.account] | 600      | 50.0  | 30000.0 | SHORT |  [TC_005_Ins1.participant]  |

        And "Position_Updates" are submitted with following values
        | Instance ID   | account                  | quantity | price | value   | side  | participant               |
        | TC_005_Ins3   | [TC_005_Ins1.account]    | 1000     | 51.0  | 51000.0 | SHORT |  [TC_005_Ins1.participant]|

        Then response of the request "TC_005_Ins2" should be
        | Instance ID      | status   | subStatus   |
        | TC_005_Ins2_Res1 | POSTED   | PROCESSING  |

        Then response of the request "TC_005_Ins3" should be
        | Instance ID      | status   | subStatus   |
        | TC_005_Ins3_Res2 | POSTED   | PROCESSING  |

        Then "Position" messages are filtered by "level,participant,account" should be
        | Instance ID        | level   | participant               | shortPosition   | shortValue | netPosition  | netValue | avgPrice | account                 |
        | TC_005_Ins2_Res1   | ACCOUNT | [TC_005_Ins1.participant] | 600.0           | 30000.0    | -600.0       | -30000.0 | 50.0     | [TC_005_Ins1.account]   |

         Then "Position" messages are filtered by "level,participant,account" should be
        | Instance ID     | level   | participant              | shortPosition   | shortValue | netPosition  | netValue  | avgPrice    | account                 |
        | PU_Short2_Res2  | ACCOUNT | [TC_005_Ins1.participant]| 1600.0          | 81000.0    | -1600.0      | -810000.0 | 50.625      | [TC_005_Ins1.account]   |

    Scenario: TC_006 Validate Long Position Calculation, Average price calculation when multiple long positions exist

       Given instance "HNKG_6" of entity "Accounts" is deleted

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID  | Account Id  | Name       | Participant    |
        | TC_006_Ins1  | HNKG_6      | HNKG_6     | HSBC           |

        When "Position_Updates" are submitted with following values
        | Instance ID  | account   				  | quantity | price | value   | side  | participant                |
        | TC_006_Ins2  | [TC_005_Ins1.account]    | 600      | 50.0  | 30000.0 | LONG  |  [TC_006_Ins1.participant] |

        And "Position_Updates" are submitted with following values
        | Instance ID  | account  				  | quantity | price | value   | side  | participant |
        | TC_006_Ins3  | [TC_005_Ins1.account]    | 1000     | 51.0  | 51000.0 | LONG  |  HSBC       |

        Then response of the request "PU_Long1" should be
        | Instance ID   | status   | subStatus   |
        | PU_Long_Res1  | POSTED   | PROCESSING  |

        Then response of the request "PU_Long2" should be
        | Instance ID   | status   | subStatus   |
        | PU_Long_Res2  | POSTED   | PROCESSING  |

        Then "Position" messages are filtered by "level,participant,account" should be
        | Instance ID      | level   | participant   | shortPosition   | longValue  | netPosition  | netValue | avgPrice | account  |
        | PU_Long1_Res1    | ACCOUNT | HSBC          | 600.0           | 30000.0    | 30000.0      | 30000.0  | 50.0     | HNKG_6   |

         Then "Position" messages are filtered by "level,participant,account" should be
        | Instance ID      | level   | participant   | longPosition    | longValue  | netPosition  | netValue  | avgPrice    | account  |
        | PU_Long2_Res2    | ACCOUNT | HSBC          | 1600.0          | 81000.0    | 1600.0       | 810000.0  | 50.625      | HNKG_6   |

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
