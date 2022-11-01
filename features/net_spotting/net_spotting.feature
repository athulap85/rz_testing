Feature: Net Spotting Functional testing

  @wip1
  Scenario: TC_001 Only Position get update for Corporate Ins & no update in Ideal Hedge & DV01 values & par value update
    Given instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                | Participant | Position Key Ids | Type   | Account Currency | Category |
      | TC_001_NP   | random(RZ_NP_ACC_,5) | random(RZ_NP_ACN,6) | RZ_NP_MEM_1 | RZ_NP_IT_1       | MARGIN | USD              | CLIENT   |
    And instance "RZ-Base-Ins-Fixed-01" of entity "Instruments" is copied with following values
      | Instance ID   | Instrument ID | Symbol                   | Expiry Date | Issue Date | First Coupon Date | Next To Last Date | Par Value |
      | TC_GB_INS_001 | INS_003       | random(RZ_NP1_SYM_GB_,3) | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        | 100       |
    And instance "RZ-Base-R-Port-01" of entity "Risk Portfolios" is copied with following values
      | Instance ID | Risk Portfolio Id       | Holding Period | Hedge Instrument       |
      | TC_RISK_001 | random(RZ_NP1_RP_5Y_,3) | 5              | [TC_GB_INS_001.Symbol] |
    And instance "RZ-Base-Ins-Fixed-03" of entity "Instruments" is copied with following values
      | Instance ID   | Instrument ID | Symbol                   | Expiry Date | Risk Portfolio                  | Issue Date | First Coupon Date | Next To Last Date | Par Value |
      | TC_CB_INS_001 | INS_012       | random(RZ_NP1_SYM_CB_,3) | 2027-12-31  | [TC_RISK_001.Risk Portfolio Id] | 2022-03-31 | 2022-04-01        | 2025-12-15        | 100       |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID  | symbol                 | type | value |
      | TC_001_RFU01 | [TC_CB_INS_001.Symbol] | DV01 | 0     |
      | TC_001_RFU02 | [TC_GB_INS_001.Symbol] | DV01 | 0.0   |
    When "Position Update" messages are submitted with following values
      | Instance ID  | account                | symbol                 | quantity | price | value   | side | participant             | notional |
      | TC_001_NP_PU | [TC_001_NP.Account Id] | [TC_CB_INS_001.Symbol] | 600      | 50.0  | 30000.0 | LONG | [TC_001_NP.Participant] | 30000    |
    Then "Position" messages are filtered by "level,account,participant,dv01,idealHedge" should be
      | Instance ID      | symbol                | level   | account                | participant             | dv01 | idealHedge |
      | TC_003_NP_PU_RES | [TC_001_NP_PU.symbol] | ACCOUNT | [TC_001_NP.Account Id] | [TC_001_NP.Participant] | 0.0  | 0.0        |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID  | symbol                 | type | value |
      | TC_001_RFU03 | [TC_CB_INS_001.Symbol] | DV01 | 30    |
      | TC_001_RFU04 | [TC_GB_INS_001.Symbol] | DV01 | 3.5   |
    Then "Position" messages are filtered by "level,account,participant,dv01,idealHedge" should be
      | Instance ID       | symbol                 | level   | account                | participant             | dv01   | idealHedge |
      | TC_003_NP_PU_RES1 | [TC_CB_INS_001.Symbol] | ACCOUNT | [TC_001_NP.Account Id] | [TC_001_NP.Participant] | 9000.0 | -257142.86 |
    Then "Hedge Efficiency" messages are filtered by "account,symbol,hedgeEfficiency" should be
      | Instance ID    | account                | symbol                 | hedgeEfficiency |
      | TC_003_HE_Res1 | [TC_001_NP.Account Id] | [TC_GB_INS_001.Symbol] | 0.0             |
      | TC_003_HE_Res2 | [TC_001_NP.Account Id] | [TC_GB_INS_001.Symbol] | -257142.86      |
    When instance "[TC_CB_INS_001.Symbol]" of entity "Instruments" is updated with following values
      | Instance ID | Par Value |
      | Ins01       | 50        |
    Then "Position" messages are filtered by "level,account,participant,idealHedge" should be
      | Instance ID       | symbol                 | level   | account                | participant             | dv01    | idealHedge |
      | TC_003_NP_PU_RES1 | [TC_CB_INS_001.Symbol] | ACCOUNT | [TC_001_NP.Account Id] | [TC_001_NP.Participant] | 18000.0 | -514285.71 |
    Then "Hedge Efficiency" messages are filtered by "account,symbol,hedgeEfficiency" should be
      | Instance ID    | account                | symbol                 | hedgeEfficiency |
      | TC_003_HE_Res3 | [TC_001_NP.Account Id] | [TC_GB_INS_001.Symbol] | 0.0             |
      | TC_003_HE_Res4 | [TC_001_NP.Account Id] | [TC_GB_INS_001.Symbol] | -257142.86      |
      | TC_003_HE_Res5 | [TC_001_NP.Account Id] | [TC_GB_INS_001.Symbol] | -514285.71      |

  @wip2
  Scenario: TC_002 MD Update for Hedge & Corporate Ins & DV01/Ideal Hedge Calculated
    Given instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id            | Name                  | Participant | Position Key Ids | Type   | Account Currency | Category |
      | TC_002_NP   | random(RZ_NP2_ACC_,3) | random(RZ_NP2_ACN,6 ) | RZ_NP_MEM_1 | RZ_NP_IT_1       | MARGIN | USD              | CLIENT   |
    And instance "RZ-Base-Ins-Fixed-01" of entity "Instruments" is copied with following values
      | Instance ID   | Instrument ID | Symbol                   | Expiry Date | Issue Date | First Coupon Date | Next To Last Date | Par Value |
      | TC_GB_INS_001 | INS_002       | random(RZ_NP2_SYM_GB_,3) | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        | 100       |
    And instance "RZ-Base-R-Port-01" of entity "Risk Portfolios" is copied with following values
      | Instance ID | Risk Portfolio Id       | Holding Period | Hedge Instrument       |
      | TC_RISK_001 | random(RZ_NP2_RP_5Y_,3) | 5              | [TC_GB_INS_001.Symbol] |
    And instance "RZ-Base-Ins-Fixed-03" of entity "Instruments" is copied with following values
      | Instance ID   | Instrument ID | Symbol                   | Expiry Date | Risk Portfolio                  | Issue Date | First Coupon Date | Next To Last Date | Par Value |
      | TC_CB_INS_001 | INS_003       | random(RZ_NP2_SYM_CB_,3) | 2027-12-31  | [TC_RISK_001.Risk Portfolio Id] | 2022-03-31 | 2022-04-01        | 2025-12-15        | 100       |
    When "Position Update" messages are submitted with following values
      | Instance ID  | account                | symbol                 | quantity | price | value   | side | participant             | notional |
      | TC_002_NP_PU | [TC_002_NP.Account Id] | [TC_CB_INS_001.Symbol] | 600      | 50.0  | 30000.0 | LONG | [TC_002_NP.Participant] | 30000    |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID  | symbol                 | type | value |
      | TC_002_RFU01 | [TC_CB_INS_001.Symbol] | DV01 | 25    |
    Then "Position" messages are filtered by "level,participant,account,dv01" should be
      | Instance ID      | symbol                | level   | account                | participant             | dv01   | idealHedge |
      | TC_002_NP_PU_RES | [TC_002_NP_PU.symbol] | ACCOUNT | [TC_002_NP.Account Id] | [TC_002_NP.Participant] | 7500.0 | 0.0        |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID  | symbol                 | type | value |
      | TC_002_RFU02 | [TC_GB_INS_001.Symbol] | DV01 | 2.5   |
    Then "Position" messages are filtered by "level,participant,account,idealHedge" should be
      | Instance ID       | symbol                | level   | account                | participant             | dv01   | idealHedge |
      | TC_002_NP_PU_RES1 | [TC_002_NP_PU.symbol] | ACCOUNT | [TC_002_NP.Account Id] | [TC_002_NP.Participant] | 7500.0 | -300000.0  |
    Then "Hedge Efficiency" messages are filtered by "account,symbol,hedgeEfficiency" should be
      | Instance ID    | account                | symbol                | hedgeEfficiency |
      | TC_002_HE_Res1 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | 0.0             |
      | TC_002_HE_Res2 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | 0.0             |
      | TC_002_HE_Res3 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | -300000.0       |
    When "Position Update" messages are submitted with following values
      | Instance ID   | account                | symbol                 | quantity | price | value  | side | participant             | notional |
      | TC_002_NP_PU2 | [TC_002_NP.Account Id] | [TC_CB_INS_001.Symbol] | 200      | 30.0  | 6000.0 | LONG | [TC_002_NP.Participant] | 6000     |
    Then "Position" messages are filtered by "level,participant,account,dv01,idealHedge" should be
      | Instance ID       | symbol                | level   | account                | participant             | dv01   | idealHedge |
      | TC_002_NP_PU_RES3 | [TC_002_NP_PU.symbol] | ACCOUNT | [TC_002_NP.Account Id] | [TC_002_NP.Participant] | 9000.0 | -360000.0  |
    Then "Hedge Efficiency" messages are filtered by "account,symbol,hedgeEfficiency" should be
      | Instance ID    | account                | symbol                | hedgeEfficiency |
      | TC_002_HE_Res4 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | 0.0             |
      | TC_002_HE_Res5 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | 0.0             |
      | TC_002_HE_Res6 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | -300000.0       |
      | TC_002_HE_Res7 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | -360000.0       |
    When "Position Update" messages are submitted with following values
      | Instance ID   | account                | symbol                 | quantity | price | value  | side  | participant             | notional |
      | TC_002_NP_PU3 | [TC_002_NP.Account Id] | [TC_GB_INS_001.Symbol] | 300      | 30.0  | 9000.0 | SHORT | [TC_002_NP.Participant] | 9000     |
    Then "Hedge Efficiency" messages are filtered by "account,symbol,hedgeEfficiency" should be
      | Instance ID     | account                | symbol                | hedgeEfficiency |
      | TC_002_HE_Res8  | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | 0.0             |
      | TC_002_HE_Res9  | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | 0.0             |
      | TC_002_HE_Res10 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | -300000.0       |
      | TC_002_HE_Res11 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | -360000.0       |
      | TC_002_HE_Res12 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | -351000.0       |
    When "Position Update" messages are submitted with following values
      | Instance ID   | account                | symbol                 | quantity | price | value    | side  | participant             | notional |
      | TC_002_NP_PU4 | [TC_002_NP.Account Id] | [TC_GB_INS_001.Symbol] | 5500     | 70.0  | 385000.0 | SHORT | [TC_002_NP.Participant] | 385000   |
    Then "Hedge Efficiency" messages are filtered by "account,symbol,hedgeEfficiency" should be
      | Instance ID     | account                | symbol                | hedgeEfficiency |
      | TC_002_HE_Res13 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | 0.0             |
      | TC_002_HE_Res14 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | 0.0             |
      | TC_002_HE_Res15 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | -300000.0       |
      | TC_002_HE_Res16 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | -360000.0       |
      | TC_002_HE_Res17 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | -351000.0       |
      | TC_002_HE_Res18 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | 34000.0         |
    When "Position Update" messages are submitted with following values
      | Instance ID   | account                | symbol                 | quantity | price | value  | side  | participant             | notional |
      | TC_002_NP_PU2 | [TC_002_NP.Account Id] | [TC_CB_INS_001.Symbol] | 200      | 25.0  | 5000.0 | SHORT | [TC_002_NP.Participant] | 5000     |
    Then "Position" messages are filtered by "level,participant,account,dv01,idealHedge" should be
      | Instance ID       | symbol                 | level   | account                | participant             | dv01   | idealHedge |
      | TC_002_NP_PU_RES3 | [TC_CB_INS_001.Symbol] | ACCOUNT | [TC_002_NP.Account Id] | [TC_002_NP.Participant] | 7750.0 | -310000.0  |
    Then "Hedge Efficiency" messages are filtered by "account,symbol,hedgeEfficiency" should be
      | Instance ID     | account                | symbol                | hedgeEfficiency |
      | TC_002_HE_Res14 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | 0.0             |
      | TC_002_HE_Res15 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | 0.0             |
      | TC_002_HE_Res16 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | -360000.0       |
      | TC_002_HE_Res17 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | -351000.0       |
      | TC_002_HE_Res18 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | 34000.0         |
      | TC_002_HE_Res19 | [TC_002_NP.Account Id] | [TC_002_RFU02.symbol] | 84000.0         |

  @wip3
  Scenario: TC_003 MD Update for Hedge & Corporate Ins & DV01/Ideal Hedge Calculated multiple times
    Given instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id            | Name                  | Participant | Position Key Ids | Type   | Account Currency | Category |
      | TC_003_NP   | random(RZ_NP3_ACC_,3) | random(RZ_NP3_ACN,6 ) | RZ_NP_MEM_1 | RZ_NP_IT_1       | MARGIN | USD              | CLIENT   |
    And instance "RZ-Base-Ins-Fixed-01" of entity "Instruments" is copied with following values
      | Instance ID   | Instrument ID | Symbol                   | Expiry Date | Issue Date | First Coupon Date | Next To Last Date | Par Value |
      | TC_GB_INS_001 | INS_001       | random(RZ_NP3_SYM_GB_,3) | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        | 100       |
    And instance "RZ-Base-R-Port-01" of entity "Risk Portfolios" is copied with following values
      | Instance ID | Risk Portfolio Id       | Holding Period | Hedge Instrument       |
      | TC_RISK_001 | random(RZ_NP3_RP_5Y_,3) | 5              | [TC_GB_INS_001.Symbol] |
    And instance "RZ-Base-Ins-Fixed-03" of entity "Instruments" is copied with following values
      | Instance ID   | Instrument ID | Symbol                   | Expiry Date | Risk Portfolio                  | Issue Date | First Coupon Date | Next To Last Date | Par Value |
      | TC_CB_INS_001 | INS_002       | random(RZ_NP3_SYM_CB_,3) | 2027-12-31  | [TC_RISK_001.Risk Portfolio Id] | 2022-03-31 | 2022-04-01        | 2025-12-15        | 100       |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID  | symbol                 | type | value |
      | TC_003_RFU01 | [TC_CB_INS_001.Symbol] | DV01 | 40    |
      | TC_003_RFU02 | [TC_GB_INS_001.Symbol] | DV01 | 60    |
    When "Position Update" messages are submitted with following values
      | Instance ID  | account                | symbol                 | quantity | price | value  | side  | participant             | notional |
      | TC_003_NP_PU | [TC_003_NP.Account Id] | [TC_CB_INS_001.Symbol] | 500      | 15.0  | 7500.0 | SHORT | [TC_003_NP.Participant] | 7500     |
    Then "Position" messages are filtered by "level,account,participant,dv01,idealHedge" should be
      | Instance ID       | symbol                | level   | account                | participant             | dv01    | idealHedge |
      | TC_003_NP_PU_RES1 | [TC_003_NP_PU.symbol] | ACCOUNT | [TC_003_NP.Account Id] | [TC_003_NP.Participant] | -3000.0 | 5000.0     |
    Then "Hedge Efficiency" messages are filtered by "account,symbol,hedgeEfficiency" should be
      | Instance ID    | account                | symbol                 | hedgeEfficiency |
      | TC_003_HE_Res1 | [TC_003_NP.Account Id] | [TC_GB_INS_001.Symbol] | 5000.0          |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID  | symbol                 | type | value |
      | TC_003_RFU03 | [TC_CB_INS_001.Symbol] | DV01 | 55    |
    Then "Position" messages are filtered by "level,account,participant,dv01,idealHedge" should be
      | Instance ID       | symbol                | level   | account                | participant             | dv01    | idealHedge |
      | TC_003_NP_PU_RES2 | [TC_003_NP_PU.symbol] | ACCOUNT | [TC_003_NP.Account Id] | [TC_003_NP.Participant] | -4125.0 | 6875.0     |
    Then "Hedge Efficiency" messages are filtered by "account,symbol,hedgeEfficiency" should be
      | Instance ID    | account                | symbol                 | hedgeEfficiency |
      | TC_003_HE_Res2 | [TC_003_NP.Account Id] | [TC_GB_INS_001.Symbol] | 5000.0          |
      | TC_003_HE_Res3 | [TC_003_NP.Account Id] | [TC_GB_INS_001.Symbol] | 6875.0          |
    When "Position Update" messages are submitted with following values
      | Instance ID   | account                | symbol                | quantity | price | value  | side  | participant             | notional |
      | TC_003_NP_PU2 | [TC_003_NP.Account Id] | [TC_003_RFU02.symbol] | 200      | 20.0  | 4000.0 | SHORT | [TC_003_NP.Participant] | 4000     |
    Then "Hedge Efficiency" messages are filtered by "account,symbol,hedgeEfficiency" should be
      | Instance ID    | account                | symbol                 | hedgeEfficiency |
      | TC_003_HE_Res4 | [TC_003_NP.Account Id] | [TC_GB_INS_001.Symbol] | 5000.0          |
      | TC_003_HE_Res5 | [TC_003_NP.Account Id] | [TC_GB_INS_001.Symbol] | 6875.0          |
      | TC_003_HE_Res6 | [TC_003_NP.Account Id] | [TC_GB_INS_001.Symbol] | 10875.0         |
    When "Position Update" messages are submitted with following values
      | Instance ID   | account                | symbol                | quantity | price | value   | side | participant             | notional |
      | TC_003_NP_PU3 | [TC_003_NP.Account Id] | [TC_003_RFU02.symbol] | 1000     | 55.0  | 55000.0 | LONG | [TC_003_NP.Participant] | 55000    |
    Then "Hedge Efficiency" messages are filtered by "account,symbol,hedgeEfficiency" should be
      | Instance ID     | account                | symbol                 | hedgeEfficiency |
      | TC_003_HE_Res7  | [TC_003_NP.Account Id] | [TC_GB_INS_001.Symbol] | 5000.0          |
      | TC_003_HE_Res8  | [TC_003_NP.Account Id] | [TC_GB_INS_001.Symbol] | 6875.0          |
      | TC_003_HE_Res9  | [TC_003_NP.Account Id] | [TC_GB_INS_001.Symbol] | 10875.0         |
      | TC_003_HE_Res10 | [TC_003_NP.Account Id] | [TC_GB_INS_001.Symbol] | -44125.0        |

  @wip4
  Scenario: TC_004 DV01/Ideal Hedge Calculation with single account attached with multiple hedge instruments
    Given instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id            | Name                  | Participant | Position Key Ids | Type   | Account Currency | Category |
      | TC_004_NP   | random(RZ_NP4_ACC_,4) | random(RZ_NP4_ACN,6 ) | RZ_NP_MEM_1 | RZ_NP_IT_1       | MARGIN | USD              | CLIENT   |
    And instance "RZ-Base-Ins-Fixed-01" of entity "Instruments" is copied with following values
      | Instance ID   | Instrument ID | Symbol                   | Expiry Date | Issue Date | First Coupon Date | Next To Last Date | Par Value |
      | TC_GB_INS_004 | INS_003       | random(RZ_NP4_SYM_GB_,3) | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        | 100       |
    And instance "RZ-Base-Ins-Fixed-01" of entity "Instruments" is copied with following values
      | Instance ID   | Instrument ID | Symbol                   | Expiry Date | Issue Date | First Coupon Date | Next To Last Date | Par Value |
      | TC_GB_INS_005 | INS_004       | random(RZ_NP4_SYM_GB_,4) | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        | 100       |
    And instance "RZ-Base-R-Port-01" of entity "Risk Portfolios" is copied with following values
      | Instance ID | Risk Portfolio Id       | Holding Period | Hedge Instrument       |
      | TC_RISK_004 | random(RZ_NP4_RP_5Y_,3) | 5              | [TC_GB_INS_004.Symbol] |
    And instance "RZ-Base-R-Port-01" of entity "Risk Portfolios" is copied with following values
      | Instance ID | Risk Portfolio Id       | Holding Period | Hedge Instrument       |
      | TC_RISK_005 | random(RZ_NP4_RP_5Y_,4) | 5              | [TC_GB_INS_005.Symbol] |
    And instance "RZ-Base-Ins-Fixed-03" of entity "Instruments" is copied with following values
      | Instance ID   | Instrument ID | Symbol                   | Expiry Date | Risk Portfolio                  | Issue Date | First Coupon Date | Next To Last Date | Par Value |
      | TC_CB_INS_004 | INS_012       | random(RZ_NP4_SYM_CB_,3) | 2027-12-31  | [TC_RISK_004.Risk Portfolio Id] | 2022-03-31 | 2022-04-01        | 2025-12-15        | 100       |
    And instance "RZ-Base-Ins-Fixed-03" of entity "Instruments" is copied with following values
      | Instance ID   | Instrument ID | Symbol                   | Expiry Date | Risk Portfolio                  | Issue Date | First Coupon Date | Next To Last Date | Par Value |
      | TC_CB_INS_005 | INS_013       | random(RZ_NP4_SYM_CB_,4) | 2027-12-31  | [TC_RISK_005.Risk Portfolio Id] | 2022-03-31 | 2022-04-01        | 2025-12-15        | 100       |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID  | symbol                 | type | value |
      | TC_004_RFU01 | [TC_CB_INS_004.Symbol] | DV01 | 25    |
      | TC_004_RFU02 | [TC_GB_INS_004.Symbol] | DV01 | 2.5   |
    When "Position Update" messages are submitted with following values
      | Instance ID  | account                | symbol                 | quantity | price | value   | side | participant             | notional |
      | TC_004_NP_PU | [TC_004_NP.Account Id] | [TC_CB_INS_004.Symbol] | 600      | 50.0  | 30000.0 | LONG | [TC_004_NP.Participant] | 30000    |
    Then "Position" messages are filtered by "level,participant,account,symbol,dv01,idealHedge" should be
      | Instance ID      | symbol                | level   | account                | participant             | dv01   | idealHedge |
      | TC_004_NP_PU_RES | [TC_004_NP_PU.symbol] | ACCOUNT | [TC_004_NP.Account Id] | [TC_004_NP.Participant] | 7500.0 | -300000.0  |
    Then "Hedge Efficiency" messages are filtered by "account,symbol,hedgeEfficiency" should be
      | Instance ID    | account                | symbol                 | hedgeEfficiency |
      | TC_004_HE_Res1 | [TC_004_NP.Account Id] | [TC_GB_INS_004.Symbol] | -300000.0       |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID  | symbol                 | type | value |
      | TC_004_RFU03 | [TC_CB_INS_005.Symbol] | DV01 | 40    |
      | TC_004_RFU04 | [TC_GB_INS_005.Symbol] | DV01 | 60    |
    When "Position Update" messages are submitted with following values
      | Instance ID   | account                | symbol                 | quantity | price | value  | side  | participant             | notional |
      | TC_004_NP_PU2 | [TC_004_NP.Account Id] | [TC_CB_INS_005.Symbol] | 500      | 15.0  | 7500.0 | SHORT | [TC_004_NP.Participant] | 7500     |
    Then "Position" messages are filtered by "level,account,participant,symbol,dv01,idealHedge" should be
      | Instance ID       | symbol                 | level   | account                | participant             | dv01    | idealHedge |
      | TC_004_NP_PU_RES1 | [TC_004_NP_PU2.symbol] | ACCOUNT | [TC_004_NP.Account Id] | [TC_004_NP.Participant] | -3000.0 | 5000.0     |
    Then "Hedge Efficiency" messages are filtered by "account,symbol,hedgeEfficiency" should be
      | Instance ID     | account                | symbol                 | hedgeEfficiency |
      | TC_004_HE_Res4  | [TC_004_NP.Account Id] | [TC_GB_INS_004.Symbol] | -300000.0       |
      | TC_004_HE_Res5  | [TC_004_NP.Account Id] | [TC_GB_INS_004.Symbol] | -300000.0       |
      | TC_004_HE_Res6  | [TC_004_NP.Account Id] | [TC_GB_INS_004.Symbol] | -300000.0       |
      | TC_004_HE_Res7  | [TC_004_NP.Account Id] | [TC_GB_INS_004.Symbol] | -300000.0       |
      | TC_004_HE_Res10 | [TC_004_NP.Account Id] | [TC_GB_INS_005.Symbol] | 5000.0          |
    When "Position Update" messages are submitted with following values
      | Instance ID   | account                | symbol                 | quantity | price | value   | side | participant             | notional |
      | TC_004_NP_PU3 | [TC_004_NP.Account Id] | [TC_CB_INS_004.Symbol] | 800      | 50.0  | 40000.0 | LONG | [TC_004_NP.Participant] | 40000    |
    Then "Position" messages are filtered by "level,participant,account,symbol,dv01,idealHedge" should be
      | Instance ID       | symbol                | level   | account                | participant             | dv01    | idealHedge |
      | TC_004_NP_PU_RES2 | [TC_004_NP_PU.symbol] | ACCOUNT | [TC_004_NP.Account Id] | [TC_004_NP.Participant] | 17500.0 | -700000.0  |
    Then "Hedge Efficiency" messages are filtered by "account,symbol,hedgeEfficiency" should be
      | Instance ID     | account                | symbol                 | hedgeEfficiency |
      | TC_004_HE_Res10 | [TC_004_NP.Account Id] | [TC_GB_INS_004.Symbol] | -300000.0       |
      | TC_004_HE_Res11 | [TC_004_NP.Account Id] | [TC_GB_INS_004.Symbol] | -300000.0       |
      | TC_004_HE_Res12 | [TC_004_NP.Account Id] | [TC_GB_INS_004.Symbol] | -300000.0       |
      | TC_004_HE_Res13 | [TC_004_NP.Account Id] | [TC_GB_INS_004.Symbol] | -300000.0       |
      | TC_004_HE_Res14 | [TC_004_NP.Account Id] | [TC_GB_INS_004.Symbol] | -700000.0       |
      | TC_004_HE_Res17 | [TC_004_NP.Account Id] | [TC_GB_INS_005.Symbol] | 5000.0          |
      | TC_004_HE_Res18 | [TC_004_NP.Account Id] | [TC_GB_INS_005.Symbol] | 5000.0          |

  @wip5
  Scenario: TC_005 Multiple Corporate Ins attached to Hedge Ins & DV01/Ideal Hedge Calculated
    Given instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id            | Name                  | Participant | Position Key Ids | Type   | Account Currency | Category |
      | TC_005_NP   | random(RZ_NP5_ACC_,4) | random(RZ_NP5_ACN,6 ) | RZ_NP_MEM_1 | RZ_NP_IT_1       | MARGIN | USD              | CLIENT   |
    And instance "RZ-Base-Ins-Fixed-01" of entity "Instruments" is copied with following values
      | Instance ID   | Instrument ID | Symbol                   | Expiry Date | Issue Date | First Coupon Date | Next To Last Date | Par Value |
      | TC_GB_INS_001 | INS_001       | random(RZ_NP5_SYM_GB_,3) | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        | 100       |
    And instance "RZ-Base-R-Port-01" of entity "Risk Portfolios" is copied with following values
      | Instance ID | Risk Portfolio Id       | Holding Period | Hedge Instrument       |
      | TC_RISK_001 | random(RZ_NP5_RP_5Y_,3) | 5              | [TC_GB_INS_001.Symbol] |
    And instance "RZ-Base-Ins-Fixed-03" of entity "Instruments" is copied with following values
      | Instance ID   | Instrument ID | Symbol                    | Expiry Date | Risk Portfolio                  | Issue Date | First Coupon Date | Next To Last Date | Par Value |
      | TC_CB_INS_001 | INS_002       | random(RZ_NP5_SYM_CB1_,3) | 2027-12-31  | [TC_RISK_001.Risk Portfolio Id] | 2022-03-31 | 2022-04-01        | 2025-12-15        | 100       |
    And instance "RZ-Base-Ins-Fixed-03" of entity "Instruments" is copied with following values
      | Instance ID   | Instrument ID | Symbol                    | Expiry Date | Risk Portfolio                  | Issue Date | First Coupon Date | Next To Last Date | Par Value |
      | TC_CB_INS_002 | INS_003       | random(RZ_NP5_SYM_CB2_,3) | 2027-12-31  | [TC_RISK_001.Risk Portfolio Id] | 2022-03-31 | 2022-04-01        | 2025-12-15        | 100       |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID  | symbol                 | type | value |
      | TC_005_RFU01 | [TC_CB_INS_001.Symbol] | DV01 | 40    |
      | TC_005_RFU02 | [TC_CB_INS_002.Symbol] | DV01 | 50    |
      | TC_005_RFU03 | [TC_GB_INS_001.Symbol] | DV01 | 60    |
    When "Position Update" messages are submitted with following values
      | Instance ID  | account                | symbol                 | quantity | price | value  | side  | participant             | notional |
      | TC_005_NP_PU | [TC_005_NP.Account Id] | [TC_CB_INS_001.Symbol] | 500      | 15.0  | 7500.0 | SHORT | [TC_005_NP.Participant] | 7500     |
    Then "Position" messages are filtered by "level,account,participant,dv01,idealHedge" should be
      | Instance ID       | symbol                | level   | account                | participant             | dv01    | idealHedge |
      | TC_005_NP_PU_RES1 | [TC_005_NP_PU.symbol] | ACCOUNT | [TC_005_NP.Account Id] | [TC_005_NP.Participant] | -3000.0 | 5000.0     |
    Then "Hedge Efficiency" messages are filtered by "account,symbol,hedgeEfficiency" should be
      | Instance ID    | account                | symbol                 | hedgeEfficiency |
      | TC_005_HE_Res1 | [TC_005_NP.Account Id] | [TC_GB_INS_001.Symbol] | 5000.0          |
    When "Position Update" messages are submitted with following values
      | Instance ID   | account                | symbol                 | quantity | price | value   | side  | participant             | notional |
      | TC_005_NP_PU1 | [TC_005_NP.Account Id] | [TC_CB_INS_002.Symbol] | 600      | 40.0  | 24000.0 | SHORT | [TC_005_NP.Participant] | 24000    |
    Then "Position" messages are filtered by "level,account,participant,dv01,idealHedge" should be
      | Instance ID       | symbol                 | level   | account                | participant             | dv01     | idealHedge |
      | TC_005_NP_PU_RES2 | [TC_005_NP_PU1.symbol] | ACCOUNT | [TC_005_NP.Account Id] | [TC_005_NP.Participant] | -12000.0 | 20000.0    |
    Then "Hedge Efficiency" messages are filtered by "account,symbol,hedgeEfficiency" should be
      | Instance ID    | account                | symbol                 | hedgeEfficiency |
      | TC_005_HE_Res2 | [TC_005_NP.Account Id] | [TC_GB_INS_001.Symbol] | 5000.0          |
      | TC_005_HE_Res3 | [TC_005_NP.Account Id] | [TC_GB_INS_001.Symbol] | 25000.0         |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID  | symbol                 | type | value |
      | TC_005_RFU04 | [TC_CB_INS_001.Symbol] | DV01 | 50    |
    Then "Position" messages are filtered by "level,account,participant,dv01,idealHedge" should be
      | Instance ID       | symbol                | level   | account                | participant             | dv01    | idealHedge |
      | TC_005_NP_PU_RES3 | [TC_005_RFU04.symbol] | ACCOUNT | [TC_005_NP.Account Id] | [TC_005_NP.Participant] | -3750.0 | 6250.0     |
    Then "Hedge Efficiency" messages are filtered by "account,symbol,hedgeEfficiency" should be
      | Instance ID    | account                | symbol                 | hedgeEfficiency |
      | TC_005_HE_Res4 | [TC_005_NP.Account Id] | [TC_GB_INS_001.Symbol] | 5000.0          |
      | TC_005_HE_Res5 | [TC_005_NP.Account Id] | [TC_GB_INS_001.Symbol] | 25000.0         |
      | TC_005_HE_Res6 | [TC_005_NP.Account Id] | [TC_GB_INS_001.Symbol] | 26250.0         |
    When "Position Update" messages are submitted with following values
      | Instance ID   | account                | symbol                 | quantity | price | value   | side | participant             | notional |
      | TC_005_NP_PU2 | [TC_005_NP.Account Id] | [TC_CB_INS_002.Symbol] | 1000     | 40.0  | 40000.0 | LONG | [TC_005_NP.Participant] | 40000    |
    Then "Position" messages are filtered by "level,account,participant,dv01,idealHedge" should be
      | Instance ID       | symbol                 | level   | account                | participant             | dv01   | idealHedge |
      | TC_005_NP_PU_RES4 | [TC_005_NP_PU2.symbol] | ACCOUNT | [TC_005_NP.Account Id] | [TC_005_NP.Participant] | 8000.0 | -13333.33  |
    Then "Hedge Efficiency" messages are filtered by "account,symbol,hedgeEfficiency" should be
      | Instance ID     | account                | symbol                 | hedgeEfficiency |
      | TC_005_HE_Res7  | [TC_005_NP.Account Id] | [TC_GB_INS_001.Symbol] | 5000.0          |
      | TC_005_HE_Res8  | [TC_005_NP.Account Id] | [TC_GB_INS_001.Symbol] | 25000.0         |
      | TC_005_HE_Res9  | [TC_005_NP.Account Id] | [TC_GB_INS_001.Symbol] | 26250.0         |
      | TC_005_HE_Res10 | [TC_005_NP.Account Id] | [TC_GB_INS_001.Symbol] | -7083.33        |

  @wip6
  Scenario: TC_006 get multiple MD Update for Hedge & Corporate Ins & DV01/Ideal Hedge Calculated
    Given instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id            | Name                  | Participant | Position Key Ids | Type   | Account Currency | Category |
      | TC_006_NP   | random(RZ_NP6_ACC_,6) | random(RZ_NP6_ACN,6 ) | RZ_NP_MEM_1 | RZ_NP_IT_1       | MARGIN | USD              | CLIENT   |
    And instance "RZ-Base-Ins-Fixed-01" of entity "Instruments" is copied with following values
      | Instance ID   | Instrument ID | Symbol                   | Expiry Date | Issue Date | First Coupon Date | Next To Last Date | Par Value |
      | TC_GB_INS_001 | INS_001       | random(RZ_NP6_SYM_GB_,3) | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        | 100       |
    And instance "RZ-Base-R-Port-01" of entity "Risk Portfolios" is copied with following values
      | Instance ID | Risk Portfolio Id       | Holding Period | Hedge Instrument       |
      | TC_RISK_001 | random(RZ_NP6_RP_5Y_,3) | 5              | [TC_GB_INS_001.Symbol] |
    And instance "RZ-Base-Ins-Fixed-03" of entity "Instruments" is copied with following values
      | Instance ID   | Instrument ID | Symbol                   | Expiry Date | Risk Portfolio                  | Issue Date | First Coupon Date | Next To Last Date | Par Value |
      | TC_CB_INS_001 | INS_002       | random(RZ_NP6_SYM_CB_,3) | 2027-12-31  | [TC_RISK_001.Risk Portfolio Id] | 2022-03-31 | 2022-04-01        | 2025-12-15        | 100       |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID  | symbol                 | type | value |
      | TC_003_RFU01 | [TC_CB_INS_001.Symbol] | DV01 | 10    |
      | TC_003_RFU02 | [TC_CB_INS_001.Symbol] | DV01 | 20    |
      | TC_003_RFU03 | [TC_CB_INS_001.Symbol] | DV01 | 40    |
      | TC_003_RFU04 | [TC_GB_INS_001.Symbol] | DV01 | 10    |
      | TC_003_RFU05 | [TC_GB_INS_001.Symbol] | DV01 | 20    |
      | TC_003_RFU06 | [TC_GB_INS_001.Symbol] | DV01 | 60    |
    When "Position Update" messages are submitted with following values
      | Instance ID  | account                | symbol                 | quantity | price | value  | side  | participant             | notional |
      | TC_006_NP_PU | [TC_006_NP.Account Id] | [TC_CB_INS_001.Symbol] | 500      | 15.0  | 7500.0 | SHORT | [TC_006_NP.Participant] | 7500     |
    Then "Position" messages are filtered by "level,account,participant,dv01,idealHedge" should be
      | Instance ID       | symbol                | level   | account                | participant             | dv01    | idealHedge |
      | TC_006_NP_PU_RES1 | [TC_006_NP_PU.symbol] | ACCOUNT | [TC_006_NP.Account Id] | [TC_006_NP.Participant] | -3000.0 | 5000.0     |
    Then "Hedge Efficiency" messages are filtered by "account,symbol,hedgeEfficiency" should be
      | Instance ID    | account                | symbol                 | hedgeEfficiency |
      | TC_006_HE_Res1 | [TC_006_NP.Account Id] | [TC_GB_INS_001.Symbol] | 5000.0          |
