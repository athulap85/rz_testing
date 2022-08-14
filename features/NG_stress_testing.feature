Feature: Stress testing

  Scenario: Stress testing data setup NG_Updated

    Given instance "USTreasury-Act/Act" of entity "Instruments" is copied with following values
      | Instance ID | Symbol         | ISIN           | Instrument Type |
      | Curve1      | NG_RZ_ST_Cur01 | NG_RZ_ST_Cur01 | CURVES          |

    And instance "USTreasury10Y-Act/Act" of entity "Instruments" is copied with following values
      | Instance ID | Symbol           | ISIN             | Instrument Type | Tenor | Curve Identifier |
      | Rate1D      | NG_RZ_ST_Rate1D  | NG_RZ_ST_Rate1D  | SPOT_RATE       | 1D    | [Curve1.Symbol]  |
      | Rate1M      | NG_RZ_ST_Rate1M  | NG_RZ_ST_Rate1M  | SPOT_RATE       | 1M    | [Curve1.Symbol]  |
      | Rate3M      | NG_RZ_ST_Rate3M  | NG_RZ_ST_Rate3M  | SPOT_RATE       | 3M    | [Curve1.Symbol]  |
      | Rate6M      | NG_RZ_ST_Rate6M  | NG_RZ_ST_Rate6M  | SPOT_RATE       | 6M    | [Curve1.Symbol]  |
      | Rate1Y      | NG_RZ_ST_Rate1Y  | NG_RZ_ST_Rate1Y  | SPOT_RATE       | 1Y    | [Curve1.Symbol]  |
      | Rate2Y      | NG_RZ_ST_Rate2Y  | NG_RZ_ST_Rate2Y  | SPOT_RATE       | 2Y    | [Curve1.Symbol]  |
      | Rate3Y      | NG_RZ_ST_Rate3Y  | NG_RZ_ST_Rate3Y  | SPOT_RATE       | 3Y    | [Curve1.Symbol]  |
      | Rate5Y      | NG_RZ_ST_Rate5Y  | NG_RZ_ST_Rate5Y  | SPOT_RATE       | 5Y    | [Curve1.Symbol]  |
      | Rate7Y      | NG_RZ_ST_Rate7Y  | NG_RZ_ST_Rate7Y  | SPOT_RATE       | 7Y    | [Curve1.Symbol]  |
      | Rate10Y     | NG_RZ_ST_Rate10Y | NG_RZ_ST_Rate10Y | SPOT_RATE       | 10Y   | [Curve1.Symbol]  |
      | Rate20Y     | NG_RZ_ST_Rate20Y | NG_RZ_ST_Rate20Y | SPOT_RATE       | 20Y   | [Curve1.Symbol]  |
      | Rate30Y     | NG_RZ_ST_Rate30Y | NG_RZ_ST_Rate30Y | SPOT_RATE       | 30Y   | [Curve1.Symbol]  |

    Given "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | dataClass | type | value |
      | MRate1D     | NG_RZ_ST_Rate1D  | RATE      | LTP  | 0.83  |
      | MRate1M     | NG_RZ_ST_Rate1M  | RATE      | LTP  | 0.83  |
      | MRate3M     | NG_RZ_ST_Rate3M  | RATE      | LTP  | 1.06  |
      | MRate6M     | NG_RZ_ST_Rate6M  | RATE      | LTP  | 1.58  |
      | MRate1Y     | NG_RZ_ST_Rate1Y  | RATE      | LTP  | 2.09  |
      | MRate2Y     | NG_RZ_ST_Rate2Y  | RATE      | LTP  | 2.55  |
      | MRate3Y     | NG_RZ_ST_Rate3Y  | RATE      | LTP  | 2.88  |
      | MRate5Y     | NG_RZ_ST_Rate5Y  | RATE      | LTP  | 2.90  |
      | MRate7Y     | NG_RZ_ST_Rate7Y  | RATE      | LTP  | 2.95  |
      | MRate10Y    | NG_RZ_ST_Rate10Y | RATE      | LTP  | 3.05  |
      | MRate20Y    | NG_RZ_ST_Rate20Y | RATE      | LTP  | 3.25  |
      | MRate30Y    | NG_RZ_ST_Rate30Y | RATE      | LTP  | 3.35  |

    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
      | Instance ID | Symbol          | ISIN            | Instrument Type | Discount Curve  | Par Value |
      | Bond1       | NG_RZ_ST_Bond01 | NG_RZ_ST_Bond01 | Fixed Rate Bond | [Curve1.Symbol] | 100       |

    Given instance "HSBC" of entity "Participants" is copied with following values
      | Instance ID | Participant Id  |
      | Part01      | NG_RZ_ST_Firm01 |

    Given table "tab1" is created with following values
      | Instance ID | Risk Factor Type | Symbol           | Shift Type | Shift Percentage |
      | te1         | INTEREST_RATE    | NG_RZ_ST_Rate30Y | ABSOLUTE   | 1                |
      | te2         | INTEREST_RATE    | NG_RZ_ST_Rate10Y | ABSOLUTE   | 1.5              |

    Given instance of entity "Stress Scenarios" is created with following values
      | Instance ID | Stress Scenario Id  | Stress Scenario Name | Shift      |
      | SS1         | NG_RZ_ST_Scenario01 | NG_RZ_ST_Scenario01  | [TAB:tab1] |

    Given table "tab2" is created with following values
      | Instance ID | Risk Factor Type | Symbol          | Shift Type | Shift Percentage |
      | te3         | INTEREST_RATE    | NG_RZ_ST_Rate2Y | ABSOLUTE   | 0.5              |
      | te4         | INTEREST_RATE    | NG_RZ_ST_Rate5Y | ABSOLUTE   | 1.1              |

    Given instance of entity "Stress Scenarios" is created with following values
      | Instance ID | Stress Scenario Id  | Stress Scenario Name | Shift      |
      | SS2         | NG_RZ_ST_Scenario02 | NG_RZ_ST_Scenario02  | [TAB:tab2] |

    Given table "tab3" is created with following values
      | Instance ID | Risk Factor Type | Symbol          | Shift Type | Shift Percentage |
      | te5         | INTEREST_RATE    | NG_RZ_ST_Rate2Y | RELATIVE   | 0.5              |
      | te6         | INTEREST_RATE    | NG_RZ_ST_Rate5Y | ABSOLUTE   | 1.1              |
      | te7         | INTEREST_RATE    | NG_RZ_ST_Rate7Y | ABSOLUTE   | 0.5              |
      | te8         | INTEREST_RATE    | NG_RZ_ST_Rate10Y | RELATIVE   | 1.1              |

    Given instance of entity "Stress Scenarios" is created with following values
      | Instance ID | Stress Scenario Id  | Stress Scenario Name | Shift      |
      | SS3         | NG_RZ_ST_Scenario03 | NG_RZ_ST_Scenario03  | [TAB:tab3] |

    Given instance "RiskModel1" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id    | Stress Testing  Methodology |
      | RM01        | NG_RZ_ST_Model01 | NG_RZ_ST_Scenario01         |

    Given instance "RiskModel1" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id    | Stress Testing  Methodology             |
      | RM02        | NG_RZ_ST_Model02 | NG_RZ_ST_Scenario01,NG_RZ_ST_Scenario02 |

    Given instance "RiskModel1" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id    | Stress Testing  Methodology |
      | RM03        | NG_RZ_ST_Model03 | NG_RZ_ST_Scenario02         |

    Given instance "RiskModel1" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id    | Stress Testing  Methodology |
      | RM04        | NG_RZ_ST_Model04 | NG_RZ_ST_Scenario03         |

  @account
  Scenario: TC_001 - Account - Change the existing Risk Model

    Given instance "HomeX" of entity "Accounts" is copied with following values
      | Instance ID | Participant | Account Id             | Name               | Risk Model       |
      | Acc01       | RZ_ST_01    | random(NG_RZ_ST_ACC,5) | random(NG_RZ_ST,5) | NG_RZ_ST_Model01 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol          | price | quantity | participant         | notional |
      | POU1        | [Acc01.Account Id] | NG_RZ_ST_Bond01 | 99.0  | 1        | [Acc01.Participant] | 100      |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
      | Instance ID | participant         | account            | level   | symbol          | notional |
      | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | NG_RZ_ST_Bond01 | 100.0    |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId          | currentValue                               | stressedValue                                                   |
      | Result1     | [Run1.id] | [Acc01.Account Id] | NG_RZ_ST_Scenario01 | current_value(RZ_ST_01,[Acc01.Account Id]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario01) |

    # stress result impact upon a account's risk model change
    Given instance "[Acc01.Account Id]" of entity "Accounts" is updated with following values
      | Instance ID | Risk Model       |
      | Acc02       | NG_RZ_ST_Model03 |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT02       | [Acc01.Account Id] |

    Then response of the request "STT02" should be
      | Instance ID |
      | Run2        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId          | currentValue                               | stressedValue                                                   |
      | Result2     | [Run2.id] | [Acc01.Account Id] | NG_RZ_ST_Scenario02 | current_value(RZ_ST_01,[Acc01.Account Id]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario02) |

  @stressScenario
  Scenario: TC_002 - Stress Scenario with relative Shift Type

    Given instance "HomeX" of entity "Accounts" is copied with following values
      | Instance ID | Participant | Account Id             | Name               | Risk Model       |
      | Acc01       | RZ_ST_01    | random(NG_RZ_ST_ACC,5) | random(NG_RZ_ST,5) | NG_RZ_ST_Model04 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol          | price | quantity | participant         | notional |
      | POU1        | [Acc01.Account Id] | NG_RZ_ST_Bond01 | 99.0  | 1        | [Acc01.Participant] | 100      |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
      | Instance ID | participant         | account            | level   | symbol          | notional |
      | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | NG_RZ_ST_Bond01 | 100.0    |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId          | currentValue                               | stressedValue                                                   |
      | Result1     | [Run1.id] | [Acc01.Account Id] | NG_RZ_ST_Scenario03 | current_value(RZ_ST_01,[Acc01.Account Id]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario03) |


#
#    Then "Position" messages are filtered by "level,participant,account" should be
#      | Instance ID | participant | level   | account                                                                    |
#      | POS_Res1    | RZ_ST_01    | ACCOUNT | current_value(RZ_ST_01,RZ_ST_ACC71934)                                     |
#      | POS_Res2    | RZ_ST_01    | ACCOUNT | stressed_value(RZ_ST_01,RZ_ST_ACC71934,RZ_ST_Scenario02)                   |
#      | POS_Res3    | RZ_ST_01    | ACCOUNT | current_value(RZ_ST_01,RZ_ST_ACC71934,[POS1.positionId])                   |
#      | POS_Res4    | RZ_ST_01    | ACCOUNT | stressed_value(RZ_ST_01,RZ_ST_ACC71934,RZ_ST_Scenario02,[POS1.positionId]) |
#    # participant | account > Current value of the Account
#
  @1D
  Scenario: 1D updat

#    Given instance "USTreasury10Y-Act/Act" of entity "Instruments" is copied with following values
#      | Instance ID | Symbol          | ISIN            | Instrument Type | Tenor | Curve Identifier |
#      | Rate1D      | NG_RZ_ST_Rate1D | NG_RZ_ST_Rate1D | SPOT_RATE       | 1D    | NG_RZ_ST_Cur01   |
#
#    Given "Realtime Risk Factor Update" messages are submitted with following values
#      | Instance ID | symbol          | dataClass | type | value |
#      | MRate1D     | NG_RZ_ST_Rate1D | RATE      | LTP  | 0.83  |

#   Given table "tab3" is created with following values
#      | Instance ID | Risk Factor Type | Symbol          | Shift Type | Shift Percentage |
#      | te5         | INTEREST_RATE    | NG_RZ_ST_Rate2Y | RELATIVE   | 0.5              |
#      | te6         | INTEREST_RATE    | NG_RZ_ST_Rate5Y | ABSOLUTE   | 1.1              |
#      | te7         | INTEREST_RATE    | NG_RZ_ST_Rate7Y | ABSOLUTE   | 0.5              |
#      | te8         | INTEREST_RATE    | NG_RZ_ST_Rate10Y | RELATIVE   | 1.1              |
#
#    Given instance of entity "Stress Scenarios" is created with following values
#      | Instance ID | Stress Scenario Id  | Stress Scenario Name | Shift      |
#      | SS3         | NG_RZ_ST_Scenario03 | NG_RZ_ST_Scenario03  | [TAB:tab3] |

#    Given instance "RiskModel1" of entity "Risk Models" is copied with following values
#      | Instance ID | Risk Model Id    | Stress Testing  Methodology |
#      | RM04        | NG_RZ_ST_Model04 | NG_RZ_ST_Scenario03         |

        Given instance "HomeX" of entity "Accounts" is copied with following values
      | Instance ID | Participant | Account Id             | Name               | Risk Model       |
      | Acc01       | RZ_ST_01    | random(NG_RZ_ST_ACCN,5) | random(NG_RZ_ST,5) | NG_RZ_ST_Model-N |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol          | price | quantity | participant         | notional |
      | POU1        | [Acc01.Account Id] | NG_RZ_ST_Bond01 | 99.0  | 1        | [Acc01.Participant] | 100      |
