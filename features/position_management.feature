Feature: Position Management


    @negative
    Scenario: TC_2.2.1 Validating Symbol - Mandatory Field

        When "Position_Updates" are submitted with following values
        | Instance ID | symbol  |
        | POU2        | ""     |

        Then response of the request "POU1" should be
        | Instance ID  | status   |
        | POU2_Res1    | REJECTED |

    @negative
    Scenario: TC_2.2.2 Validating Symbol - Invalid

        When "Position_Updates" are submitted with following values
        | Instance ID | symbol           |
        | POU3        | invalid_symbol   |

        Then response of the request "POU1" should be
        | Instance ID  | status   |
        | POU3_Res1    | REJECTED |

    @negative
    Scenario: TC_1 Validating Firm - Mandatory

        When "Position_Updates" are submitted with following values
        | Instance ID | participant  |
        | POU3        |  ""          |

        Then response of the request "POU1" should be
        | Instance ID  | status   |
        | POU3_Res1    | REJECTED |

    @negative
    Scenario: TC_1.2 Validating Firm - Invalid

        When "Position_Updates" are submitted with following values
        | Instance ID | participant    |
        | POU4        | invalid-Firm   |

        Then response of the request "POU1" should be
        | Instance ID  | status   |
        | POU4_Res1    | REJECTED |

    @wip
    Scenario: TC_3 Validating Account - Optional -?? Why this is getting rejected

        Given instance "Home_NKG1" of entity "Accounts" is deleted

        And instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id   | Name       | Participant    |
        | Acc01       | Home_NKG1    | Home_NKG1  | HSBC           |

        When "Position_Updates" are submitted with following values
        | Instance ID | account      | quantity | price | side | participant |
        | POU5        | Home_NKG1    | 1000     | 50.0  | SHORT|  HSBC       |

        Then response of the request "POU5" should be
        | Instance ID  | status   | subStatus   |
        | POU5_Res1    | POSTED   | PROCESSING  |

        Then "Position" messages are filtered by "level,participant,account" should be
        | Instance ID  | level  | participant   | shortPosition   | account       |
        | POU5_Res2    | SYSTEM | HSBC          | 1000.0          | Home_NKG1     |

    Scenario: TC_PA_3 Validating Instrument ID - Margin position

        When "Position_Updates" are submitted with following values
        | Instance ID    | symbol     | quantity | price | side | participant |
        | POU_PA_3       | ACH        | 1000     | 50.0  | SHORT|  HSBC       |

        Then "Position" messages are filtered by "symbol,level,account,participant,shortPosition,netPosition" should be
        | Instance ID      | symbol     | level    | account | participant   | shortPosition   | netPosition|
        | POU_PA_3_Res1    | ACH        | ACCOUNT  | Home    | HSBC          | 1000.0          | -1000.0    |


    Scenario: TC_PA_5.1 Validating Position Type - Margin

        When "Position_Updates" are submitted with following values
        | Instance ID    | symbol      | quantity | price | side | participant | type   |
        | POU_PA_5.1     | ACIC        | 1000     | 50.0  | SHORT|  HSBC       | MARGIN |

        Then "Position" messages are filtered by "symbol,level,account,participant,type,shortPosition,netPosition" should be
        | Instance ID      | symbol     | level    | account | participant   | type   | shortPosition   | netPosition|
        | POU_PA_5.1_Res1  | ACIC       | ACCOUNT  | Home    | HSBC          | MARGIN | 1000.0          | -1000.0    |


    Scenario: TC_PA_5.2 Validating Position Type - Collateral ? Failed due to a business validation of collateral

        When "Position_Updates" are submitted with following values
        | Instance ID    | symbol      | quantity | price | side | participant | type       | account         |
        | POU_PA_5.2     | ACIC        | 1000     | 50.0  | SHORT|  HSBC       | COLLATERAL | Home-Collateral |

        Then "Position" messages are filtered by "symbol,level,account,participant,type,shortPosition,netPosition" should be
        | Instance ID      | symbol     | level    | account            | participant   | type       | shortPosition   | netPosition|
        | POU_PA_5.2_Res1  | ACIC       | ACCOUNT  | Home-Collateral    | HSBC          | COLLATERAL | 1000.0          | -1000.0    |




    Scenario: Validate All Values in Long position

       Given instance "HNKG_3" of entity "Accounts" is deleted

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id    | Name        | Participant    |
        | Acc_01      | HNKG_3       | HNKG_3     | HSBC           |

        When "Position_Updates" are submitted with following values
        | Instance ID | account   | quantity | price | value   | side | participant |
        | PU_Long     | HNKG_3    | 6000     | 50.0  | 30000.0 | LONG |  HSBC       |

        Then response of the request "PU_Long" should be
        | Instance ID  | status   | subStatus   |
        | PU_Long_Res1 | POSTED   | PROCESSING  |

        Then "Position" messages are filtered by "level,participant,account" should be
        | Instance ID     | level   | participant   | longPosition   | longValue | netPosition  | netValue | account  |
        | PU_Long_Res2    | ACCOUNT | HSBC          | 6000.0         | 30000.0   | 6000.0       | 30000.0  | HNKG_3   |

    Scenario: TC_POBT_2.1. Validate Short Position Calculation, Average price calculation when multiple short positions exist

       Given instance "HNKG_5" of entity "Accounts" is deleted

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id  | Name       | Participant    |
        | Acc_01      | HNKG_5      | HNKG_5     | HSBC           |

        When "Position_Updates" are submitted with following values
        | Instance ID   | account   | quantity | price | value   | side  | participant |
        | PU_Short1     | HNKG_5    | 600      | 50.0  | 30000.0 | SHORT |  HSBC       |

        And "Position_Updates" are submitted with following values
        | Instance ID   | account   | quantity | price | value   | side  | participant |
        | PU_Short2     | HNKG_5    | 1000     | 51.0  | 51000.0 | SHORT |  HSBC       |

        Then response of the request "PU_Short1" should be
        | Instance ID   | status   | subStatus   |
        | PU_Short1_Res1 | POSTED   | PROCESSING  |

        Then response of the request "PU_Short2" should be
        | Instance ID   | status   | subStatus   |
        | PU_Short2_Res2 | POSTED   | PROCESSING  |

        Then "Position" messages are filtered by "level,participant,account" should be
        | Instance ID     | level   | participant   | shortPosition   | shortValue | netPosition  | netValue | avgPrice | account  |
        | PU_Short1_Res1   | ACCOUNT | HSBC         | 600.0           | 30000.0    | -600.0       | -30000.0 | 50.0     | HNKG_5   |

         Then "Position" messages are filtered by "level,participant,account" should be
        | Instance ID     | level   | participant   | shortPosition   | shortValue | netPosition  | netValue  | avgPrice    | account  |
        | PU_Short2_Res2   | ACCOUNT | HSBC         | 1600.0          | 81000.0    | -1600.0      | -810000.0 | 50.625      | HNKG_5   |

    Scenario: TC_POBT_1.1. Validate Long Position Calculation, Average price calculation when multiple long positions exist

       Given instance "HNKG_6" of entity "Accounts" is deleted

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id  | Name       | Participant    |
        | Acc_01      | HNKG_6      | HNKG_6     | HSBC           |

        When "Position_Updates" are submitted with following values
        | Instance ID  | account   | quantity | price | value   | side  | participant |
        | PU_Long1     | HNKG_6    | 600      | 50.0  | 30000.0 | LONG  |  HSBC       |

        And "Position_Updates" are submitted with following values
        | Instance ID  | account   | quantity | price | value   | side  | participant |
        | PU_Long2     | HNKG_6    | 1000     | 51.0  | 51000.0 | LONG  |  HSBC       |

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
        | PU_Long1_Res1    | ACCOUNT | HSBC          | 600             | 1000		  | 30000.0    | 51000.0    | 400          | 210000.0  | 35.0        | HNKG_7   |