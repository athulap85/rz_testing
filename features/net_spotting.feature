Feature: Net Spotting Functional testing

  Scenario: TC_001 Only Position get update for Corporate Ins & no update in Ideal Hedge & DV01 values & par value update
    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id     | Name                 | Participant | Position Key Ids | Type   | Account Currency | Category |
      | TC_001_NP   | RZ_NP_ACC_1022 | random(RZ_NP_ACN,6 ) | RZ_NP_MEM_1 | RZ_NP_IT_1       | MARGIN | USD              | CLIENT   |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID  | symbol          | type | value |
      | TC_001_RFU01 | RZ_NP_SYM_CB_12 | DV01 | 0     |
      | TC_001_RFU02 | RZ_NP_SYM_GB_11 | DV01 | 0.0   |
    When "Position Update" messages are submitted with following values
      | Instance ID  | account                | symbol          | quantity | price | value   | side | participant             | notional |
      | TC_001_NP_PU | [TC_001_NP.Account Id] | RZ_NP_SYM_CB_12 | 600      | 50.0  | 30000.0 | LONG | [TC_001_NP.Participant] | 30000    |
    Then "Position" messages are filtered by "level,account,participant,dv01" should be
      | Instance ID      | symbol                | level   | account                | participant             | dv01 | idealHedge |
      | TC_003_NP_PU_RES | [TC_001_NP_PU.symbol] | ACCOUNT | [TC_001_NP.Account Id] | [TC_001_NP.Participant] | 0.0  | 0.0        |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID  | symbol          | type | value |
      | TC_001_RFU03 | RZ_NP_SYM_CB_12 | DV01 | 30    |
      | TC_001_RFU04 | RZ_NP_SYM_GB_11 | DV01 | 3.5   |
    Then "Position" messages are filtered by "level,account,participant,dv01" should be
      | Instance ID       | symbol          | level   | account                | participant             | dv01   | idealHedge          |
      | TC_003_NP_PU_RES1 | RZ_NP_SYM_CB_12 | ACCOUNT | [TC_001_NP.Account Id] | [TC_001_NP.Participant] | 9000.0 | -257142.85714285713 |
    Then "Hedge Efficiency" messages are filtered by "account,symbol" should be
      | Instance ID    | account                | symbol          | hedgeEfficiency     |
      | TC_003_HE_Res1 | [TC_001_NP.Account Id] | RZ_NP_SYM_GB_11 | 0.0                 |
      | TC_003_HE_Res2 | [TC_001_NP.Account Id] | RZ_NP_SYM_GB_11 | -257142.85714285713 |
    When instance "RZ_NP_SYM_CB_12" of entity "Instruments" is updated with following values
      | Instance ID | Par Value |
      | Ins01       | 50        |
    Then "Position" messages are filtered by "level,account,participant" should be
      | Instance ID       | symbol          | level   | account                | participant             | dv01    | idealHedge         |
      | TC_003_NP_PU_RES1 | RZ_NP_SYM_CB_12 | ACCOUNT | [TC_001_NP.Account Id] | [TC_001_NP.Participant] | 18000.0 | -514285.7142857143 |
    Then "Hedge Efficiency" messages are filtered by "account,symbol" should be
      | Instance ID    | account                | symbol          | hedgeEfficiency    |
      | TC_003_HE_Res3 | [TC_001_NP.Account Id] | RZ_NP_SYM_GB_11 | 0.0                |
      | TC_003_HE_Res4 | [TC_001_NP.Account Id] | RZ_NP_SYM_GB_11 | -257142.86         |
      | TC_003_HE_Res5 | [TC_001_NP.Account Id] | RZ_NP_SYM_GB_11 | -514285.7142857143 |

  Scenario: TC_002 MD Update for Hedge & Corporate Ins & DV01/Ideal Hedge Calculated
    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id    | Name                 | Participant | Position Key Ids | Type   | Account Currency | Category |
      | TC_002_NP   | RZ_NP_ACC_508 | random(RZ_NP_ACN,6 ) | RZ_NP_MEM_1 | RZ_NP_IT_1       | MARGIN | USD              | CLIENT   |
    When "Position Update" messages are submitted with following values
      | Instance ID  | account                | symbol          | quantity | price | value   | side | participant             | notional |
      | TC_002_NP_PU | [TC_002_NP.Account Id] | RZ_NP_SYM_CB_11 | 600      | 50.0  | 30000.0 | LONG | [TC_002_NP.Participant] | 30000    |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID  | symbol          | type | value |
      | TC_002_RFU01 | RZ_NP_SYM_CB_11 | DV01 | 25    |
    Then "Position" messages are filtered by "level,participant,account" should be
      | Instance ID      | symbol                | level   | account                | participant             | dv01   | idealHedge |
      | TC_002_NP_PU_RES | [TC_002_NP_PU.symbol] | ACCOUNT | [TC_002_NP.Account Id] | [TC_002_NP.Participant] | 7500.0 | 0.0        |
  #  -----  TO DO -----------
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID  | symbol          | type | value |
      | TC_002_RFU02 | RZ_NP_SYM_GB_10 | DV01 | 2.5   |
    Then "Position" messages are filtered by "level,participant,account" should be
      | Instance ID       | symbol                | level   | account                | participant             | dv01   | idealHedge |
      | TC_002_NP_PU_RES1 | [TC_002_NP_PU.symbol] | ACCOUNT | [TC_002_NP.Account Id] | [TC_002_NP.Participant] | 7500.0 | 0.0        |
    Then "Hedge Efficiency" messages are filtered by "account,symbol" should be
      | Instance ID    | account                | symbol                | hedgeEfficiency |
      | TC_002_HE_Res1 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | 0.0             |
    When "Position Update" messages are submitted with following values
      | Instance ID   | account                | symbol          | quantity | price | value  | side | participant             | notional |
      | TC_002_NP_PU2 | [TC_002_NP.Account Id] | RZ_NP_SYM_CB_11 | 200      | 30.0  | 6000.0 | LONG | [TC_002_NP.Participant] | 6000     |
    Then "Position" messages are filtered by "level,participant,account,dv01" should be
      | Instance ID       | symbol                | level   | account                | participant             | dv01 | idealHedge |
      | TC_002_NP_PU_RES3 | [TC_002_NP_PU.symbol] | ACCOUNT | [TC_002_NP.Account Id] | [TC_002_NP.Participant] | 9000 | -360000.0  |
    Then "Hedge Efficiency" messages are filtered by "account,symbol" should be
      | Instance ID    | account                    | symbol                | hedgeEfficiency |
      | TC_002_HE_Res2 | [TC_002_NP_PU2.Account Id] | [TC_002_RFU02.symbol] | 0.0             |
      | TC_002_HE_Res3 | [TC_002_NP_PU2.Account Id] | [TC_002_RFU02.symbol] | 0.0             |
      | TC_002_HE_Res4 | [TC_002_NP_PU2.Account Id] | [TC_002_RFU02.symbol] | -360000.0       |
    When "Position Update" messages are submitted with following values
      | Instance ID   | account                | symbol          | quantity | price | value  | side  | participant             | notional |
      | TC_002_NP_PU3 | [TC_002_NP.Account Id] | RZ_NP_SYM_GB_10 | 300      | 30.0  | 9000.0 | SHORT | [TC_002_NP.Participant] | 9000     |
    Then "Hedge Efficiency" messages are filtered by "account,symbol" should be
      | Instance ID    | account                | symbol                | hedgeEfficiency |
      | TC_002_HE_Res5 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | 0.0             |
      | TC_002_HE_Res6 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | 0.0             |
      | TC_002_HE_Res7 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | -360000.0       |
      | TC_002_HE_Res8 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | -351000.0       |
    When "Position Update" messages are submitted with following values
      | Instance ID   | account                | symbol          | quantity | price | value    | side  | participant             | notional |
      | TC_002_NP_PU4 | [TC_002_NP.Account Id] | RZ_NP_SYM_GB_10 | 5500     | 70.0  | 385000.0 | SHORT | [TC_002_NP.Participant] | 385000   |
    Then "Hedge Efficiency" messages are filtered by "account,symbol" should be
      | Instance ID     | account                | symbol                | hedgeEfficiency |
      | TC_002_HE_Res9  | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | 0.0             |
      | TC_002_HE_Res10 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | 0.0             |
      | TC_002_HE_Res11 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | -360000.0       |
      | TC_002_HE_Res12 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | -351000.0       |
      | TC_002_HE_Res13 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | 34000.0         |
    When "Position Update" messages are submitted with following values
      | Instance ID   | account                | symbol          | quantity | price | value  | side  | participant             | notional |
      | TC_002_NP_PU2 | [TC_002_NP.Account Id] | RZ_NP_SYM_CB_11 | 200      | 25.0  | 5000.0 | SHORT | [TC_002_NP.Participant] | 5000     |
    Then "Position" messages are filtered by "level,participant,account,dv01" should be
      | Instance ID       | symbol          | level   | account                | participant             | dv01 | idealHedge |
      | TC_002_NP_PU_RES3 | RZ_NP_SYM_CB_11 | ACCOUNT | [TC_002_NP.Account Id] | [TC_002_NP.Participant] | 7750 | -310000.0  |
    Then "Hedge Efficiency" messages are filtered by "account,symbol" should be
      | Instance ID     | account                | symbol                | hedgeEfficiency |
      | TC_002_HE_Res14 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | 0.0             |
      | TC_002_HE_Res15 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | 0.0             |
      | TC_002_HE_Res16 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | -360000.0       |
      | TC_002_HE_Res17 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | -351000.0       |
      | TC_002_HE_Res18 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | 34000.0         |
      | TC_002_HE_Res19 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | 84000.0         |

  Scenario: TC_003 MD Update for Hedge & Corporate Ins & DV01/Ideal Hedge Calculated multiple times
    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id    | Name                 | Participant | Position Key Ids | Type   | Account Currency | Category |
      | TC_003_NP   | RZ_NP_ACC_036 | random(RZ_NP_ACN,6 ) | RZ_NP_MEM_1 | RZ_NP_IT_1       | MARGIN | USD              | CLIENT   |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID  | symbol          | type | value |
      | TC_003_RFU01 | RZ_NP_SYM_CB_5  | DV01 | 40    |
      | TC_003_RFU02 | RZ_NP_SYM_GB_05 | DV01 | 60    |
    When "Position Update" messages are submitted with following values
      | Instance ID  | account                | symbol         | quantity | price | value  | side  | participant             | notional |
      | TC_003_NP_PU | [TC_003_NP.Account Id] | RZ_NP_SYM_CB_5 | 500      | 15.0  | 7500.0 | SHORT | [TC_003_NP.Participant] | 7500     |
    Then "Position" messages are filtered by "level,account,participant" should be
      | Instance ID       | symbol                | level   | account                | participant             | dv01    | idealHedge |
      | TC_003_NP_PU_RES1 | [TC_003_NP_PU.symbol] | ACCOUNT | [TC_003_NP.Account Id] | [TC_003_NP.Participant] | -3000.0 | 5000.0     |
    Then "Hedge Efficiency" messages are filtered by "account,symbol" should be
      | Instance ID    | account                | symbol          | hedgeEfficiency |
      | TC_003_HE_Res1 | [TC_003_NP.Account Id] | RZ_NP_SYM_GB_05 | 5000.0          |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID  | symbol         | type | value |
      | TC_003_RFU03 | RZ_NP_SYM_CB_5 | DV01 | 55    |
    Then "Position" messages are filtered by "level,account,participant,dv01" should be
      | Instance ID       | symbol                | level   | account                | participant             | dv01    | idealHedge |
      | TC_003_NP_PU_RES2 | [TC_003_NP_PU.symbol] | ACCOUNT | [TC_003_NP.Account Id] | [TC_003_NP.Participant] | -4125.0 | 6875.0     |
    Then "Hedge Efficiency" messages are filtered by "account,symbol" should be
      | Instance ID    | account                | symbol          | hedgeEfficiency |
      | TC_003_HE_Res2 | [TC_003_NP.Account Id] | RZ_NP_SYM_GB_05 | 5000.0          |
      | TC_003_HE_Res3 | [TC_003_NP.Account Id] | RZ_NP_SYM_GB_05 | 6875.0          |
    When "Position Update" messages are submitted with following values
      | Instance ID   | account                | symbol                | quantity | price | value  | side  | participant             | notional |
      | TC_003_NP_PU2 | [TC_003_NP.Account Id] | [TC_003_RFU02.symbol] | 200      | 20.0  | 4000.0 | SHORT | [TC_003_NP.Participant] | 4000     |
    Then "Hedge Efficiency" messages are filtered by "account,symbol" should be
      | Instance ID    | account                | symbol          | hedgeEfficiency |
      | TC_003_HE_Res4 | [TC_003_NP.Account Id] | RZ_NP_SYM_GB_05 | 5000.0          |
      | TC_003_HE_Res5 | [TC_003_NP.Account Id] | RZ_NP_SYM_GB_05 | 6875.0          |
      | TC_003_HE_Res6 | [TC_003_NP.Account Id] | RZ_NP_SYM_GB_05 | 10875.0         |
    When "Position Update" messages are submitted with following values
      | Instance ID   | account                | symbol                | quantity | price | value   | side | participant             | notional |
      | TC_003_NP_PU3 | [TC_003_NP.Account Id] | [TC_003_RFU02.symbol] | 1000     | 55.0  | 55000.0 | LONG | [TC_003_NP.Participant] | 55000    |
    Then "Hedge Efficiency" messages are filtered by "account,symbol" should be
      | Instance ID     | account                | symbol          | hedgeEfficiency |
      | TC_003_HE_Res7  | [TC_003_NP.Account Id] | RZ_NP_SYM_GB_05 | 5000.0          |
      | TC_003_HE_Res8  | [TC_003_NP.Account Id] | RZ_NP_SYM_GB_05 | 6875.0          |
      | TC_003_HE_Res9  | [TC_003_NP.Account Id] | RZ_NP_SYM_GB_05 | 10875.0         |
      | TC_003_HE_Res10 | [TC_003_NP.Account Id] | RZ_NP_SYM_GB_05 | -44125.0        |

  Scenario: TC_004 DV01/Ideal Hedge Calculation with single account attached with multiple hedge instruments
    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id    | Name                 | Participant | Position Key Ids | Type   | Account Currency | Category |
      | TC_004_NP   | RZ_NP_ACC_101 | random(RZ_NP_ACN,6 ) | RZ_NP_MEM_1 | RZ_NP_IT_1       | MARGIN | USD              | CLIENT   |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID  | symbol          | type | value |
      | TC_004_RFU01 | RZ_NP_SYM_CB_6  | DV01 | 25    |
      | TC_004_RFU02 | RZ_NP_SYM_GB_06 | DV01 | 2.5   |
    When "Position Update" messages are submitted with following values
      | Instance ID  | account                | symbol         | quantity | price | value   | side | participant             | notional |
      | TC_004_NP_PU | [TC_004_NP.Account Id] | RZ_NP_SYM_CB_6 | 600      | 50.0  | 30000.0 | LONG | [TC_004_NP.Participant] | 30000    |
    Then "Position" messages are filtered by "level,participant,account" should be
      | Instance ID      | symbol                | level   | account                | participant             | dv01   | idealHedge |
      | TC_004_NP_PU_RES | [TC_004_NP_PU.symbol] | ACCOUNT | [TC_004_NP.Account Id] | [TC_004_NP.Participant] | 7500.0 | -300000.0  |
    Then "Hedge Efficiency" messages are filtered by "account,symbol" should be
      | Instance ID    | account                | symbol          | hedgeEfficiency |
      | TC_004_HE_Res1 | [TC_004_NP.Account Id] | RZ_NP_SYM_GB_06 | -300000.0       |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID  | symbol          | type | value |
      | TC_004_RFU03 | RZ_NP_SYM_CB_7  | DV01 | 40    |
      | TC_004_RFU04 | RZ_NP_SYM_GB_07 | DV01 | 60    |
    When "Position Update" messages are submitted with following values
      | Instance ID   | account                | symbol         | quantity | price | value  | side  | participant             | notional |
      | TC_004_NP_PU2 | [TC_004_NP.Account Id] | RZ_NP_SYM_CB_7 | 500      | 15.0  | 7500.0 | SHORT | [TC_004_NP.Participant] | 7500     |
    Then "Position" messages are filtered by "level,account,participant,dv01" should be
      | Instance ID       | symbol                 | level   | account                | participant             | dv01    | idealHedge |
      | TC_004_NP_PU_RES1 | [TC_004_NP_PU2.symbol] | ACCOUNT | [TC_004_NP.Account Id] | [TC_004_NP.Participant] | -3000.0 | 5000.0     |
    Then "Hedge Efficiency" messages are filtered by "account,symbol" should be
      | Instance ID    | account                | symbol          | hedgeEfficiency |
      | TC_004_HE_Res2 | [TC_004_NP.Account Id] | RZ_NP_SYM_GB_07 | 0.0             |
      | TC_004_HE_Res3 | [TC_004_NP.Account Id] | RZ_NP_SYM_GB_07 | 5000.0          |
    When "Position Update" messages are submitted with following values
      | Instance ID   | account                | symbol         | quantity | price | value   | side | participant             | notional |
      | TC_004_NP_PU3 | [TC_004_NP.Account Id] | RZ_NP_SYM_CB_6 | 800      | 50.0  | 40000.0 | LONG | [TC_004_NP.Participant] | 40000    |
    Then "Position" messages are filtered by "level,participant,account,symbol" should be
      | Instance ID       | symbol                | level   | account                | participant             | dv01    | idealHedge |
      | TC_004_NP_PU_RES2 | [TC_004_NP_PU.symbol] | ACCOUNT | [TC_004_NP.Account Id] | [TC_004_NP.Participant] | 17500.0 | -700000.0  |
    Then "Hedge Efficiency" messages are filtered by "account,symbol" should be
      | Instance ID    | account                | symbol          | hedgeEfficiency |
      | TC_004_HE_Res4 | [TC_004_NP.Account Id] | RZ_NP_SYM_GB_06 | -700000.0       |

  Scenario: TC_005 Multiple Corporate Ins attached to Hedge Ins & DV01/Ideal Hedge Calculated
    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id    | Name                 | Participant | Position Key Ids | Type   | Account Currency | Category |
      | TC_005_NP   | RZ_NP_ACC_208 | random(RZ_NP_ACN,6 ) | RZ_NP_MEM_1 | RZ_NP_IT_1       | MARGIN | USD              | CLIENT   |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID  | symbol          | type | value |
      | TC_005_RFU01 | RZ_NP_SYM_CB_8  | DV01 | 40    |
      | TC_005_RFU02 | RZ_NP_SYM_CB_9  | DV01 | 50    |
      | TC_005_RFU03 | RZ_NP_SYM_GB_08 | DV01 | 60    |
    When "Position Update" messages are submitted with following values
      | Instance ID  | account                | symbol         | quantity | price | value  | side  | participant             | notional |
      | TC_005_NP_PU | [TC_005_NP.Account Id] | RZ_NP_SYM_CB_8 | 500      | 15.0  | 7500.0 | SHORT | [TC_005_NP.Participant] | 7500     |
    Then "Position" messages are filtered by "level,account,participant,dv01" should be
      | Instance ID       | symbol                | level   | account                | participant             | dv01    | idealHedge |
      | TC_005_NP_PU_RES1 | [TC_005_NP_PU.symbol] | ACCOUNT | [TC_005_NP.Account Id] | [TC_005_NP.Participant] | -3000.0 | 5000.0     |
    Then "Hedge Efficiency" messages are filtered by "account,symbol" should be
      | Instance ID    | account                | symbol          | hedgeEfficiency |
      | TC_005_HE_Res1 | [TC_005_NP.Account Id] | RZ_NP_SYM_GB_08 | 5000.0          |
    When "Position Update" messages are submitted with following values
      | Instance ID   | account                | symbol         | quantity | price | value   | side  | participant             | notional |
      | TC_005_NP_PU1 | [TC_005_NP.Account Id] | RZ_NP_SYM_CB_9 | 600      | 40.0  | 24000.0 | SHORT | [TC_005_NP.Participant] | 24000    |
    Then "Position" messages are filtered by "level,account,participant,dv01" should be
      | Instance ID       | symbol                 | level   | account                | participant             | dv01     | idealHedge |
      | TC_005_NP_PU_RES2 | [TC_005_NP_PU1.symbol] | ACCOUNT | [TC_005_NP.Account Id] | [TC_005_NP.Participant] | -12000.0 | 20000.0    |
    Then "Hedge Efficiency" messages are filtered by "account,symbol" should be
      | Instance ID    | account                | symbol          | hedgeEfficiency |
      | TC_005_HE_Res2 | [TC_005_NP.Account Id] | RZ_NP_SYM_GB_08 | 5000.0          |
      | TC_005_HE_Res3 | [TC_005_NP.Account Id] | RZ_NP_SYM_GB_08 | 25000.0         |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID  | symbol         | type | value |
      | TC_005_RFU04 | RZ_NP_SYM_CB_8 | DV01 | 50    |
    Then "Position" messages are filtered by "level,account,participant,dv01" should be
      | Instance ID       | symbol                | level   | account                | participant             | dv01    | idealHedge |
      | TC_005_NP_PU_RES3 | [TC_005_RFU04.symbol] | ACCOUNT | [TC_005_NP.Account Id] | [TC_005_NP.Participant] | -3750.0 | 6250.0     |
    Then "Hedge Efficiency" messages are filtered by "account,symbol" should be
      | Instance ID    | account                | symbol          | hedgeEfficiency |
      | TC_005_HE_Res4 | [TC_005_NP.Account Id] | RZ_NP_SYM_GB_08 | 5000.0          |
      | TC_005_HE_Res5 | [TC_005_NP.Account Id] | RZ_NP_SYM_GB_08 | 25000.0         |
      | TC_005_HE_Res6 | [TC_005_NP.Account Id] | RZ_NP_SYM_GB_08 | 26250.0         |
    When "Position Update" messages are submitted with following values
      | Instance ID   | account                | symbol         | quantity | price | value   | side | participant             | notional |
      | TC_005_NP_PU2 | [TC_005_NP.Account Id] | RZ_NP_SYM_CB_9 | 1000     | 40.0  | 40000.0 | LONG | [TC_005_NP.Participant] | 40000    |
    Then "Position" messages are filtered by "level,account,participant,dv01" should be
      | Instance ID       | symbol                 | level   | account                | participant             | dv01   | idealHedge |
      | TC_005_NP_PU_RES4 | [TC_005_NP_PU2.symbol] | ACCOUNT | [TC_005_NP.Account Id] | [TC_005_NP.Participant] | 8000.0 | -13333.33  |
    Then "Hedge Efficiency" messages are filtered by "account,symbol" should be
      | Instance ID     | account                | symbol          | hedgeEfficiency |
      | TC_005_HE_Res7  | [TC_005_NP.Account Id] | RZ_NP_SYM_GB_08 | 5000.0          |
      | TC_005_HE_Res8  | [TC_005_NP.Account Id] | RZ_NP_SYM_GB_08 | 25000.0         |
      | TC_005_HE_Res9  | [TC_005_NP.Account Id] | RZ_NP_SYM_GB_08 | 26250.0         |
      | TC_005_HE_Res10 | [TC_005_NP.Account Id] | RZ_NP_SYM_GB_08 | -7083.33        |
