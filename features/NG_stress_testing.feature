Feature: Stress testing


  @refdata
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

    # Create Stress Scenario with Multiple Shift Types for Tenors
    Given table "tab3" is created with following values
      | Instance ID | Risk Factor Type | Symbol           | Shift Type | Shift Percentage |
      | te5         | INTEREST_RATE    | NG_RZ_ST_Rate2Y  | RELATIVE   | 0.5              |
      | te6         | INTEREST_RATE    | NG_RZ_ST_Rate5Y  | ABSOLUTE   | 1.1              |
      | te7         | INTEREST_RATE    | NG_RZ_ST_Rate7Y  | ABSOLUTE   | 0.5              |
      | te8         | INTEREST_RATE    | NG_RZ_ST_Rate10Y | RELATIVE   | 1.1              |

    Given instance of entity "Stress Scenarios" is created with following values
      | Instance ID | Stress Scenario Id  | Stress Scenario Name | Shift      |
      | SS3         | NG_RZ_ST_Scenario03 | NG_RZ_ST_Scenario03  | [TAB:tab3] |

    # Create Stress Scenario with Duplicate Tenors with different Shift Types and percentages
    Given table "tab4" is created with following values
      | Instance ID | Risk Factor Type | Symbol          | Shift Type | Shift Percentage |
      | te9         | INTEREST_RATE    | NG_RZ_ST_Rate2Y | RELATIVE   | 0.5              |
      | te10        | INTEREST_RATE    | NG_RZ_ST_Rate5Y | ABSOLUTE   | 2.5              |
      | te11        | INTEREST_RATE    | NG_RZ_ST_Rate2Y | ABSOLUTE   | 4.0              |
      | te12        | INTEREST_RATE    | NG_RZ_ST_Rate5Y | RELATIVE   | 4.0              |

    Given instance of entity "Stress Scenarios" is created with following values
      | Instance ID | Stress Scenario Id  | Stress Scenario Name | Shift      |
      | SS4         | NG_RZ_ST_Scenario04 | NG_RZ_ST_Scenario04  | [TAB:tab4] |

    # Create Stress Scenario with a Tenors which is not a Tenor of IR Curve
    Given instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                   | Size Multiplier | Par Value |
      | Inst_01     | random(NG_RZ_ST_Bond_,4) | 2               | 200       |

    Given table "tab5" is created with following values
      | Instance ID | Risk Factor Type | Symbol           | Shift Type | Shift Percentage |
      | te13        | INTEREST_RATE    | [Inst_01.Symbol] | RELATIVE   | 0.5              |

    Given instance of entity "Stress Scenarios" is created with following values
      | Instance ID | Stress Scenario Id  | Stress Scenario Name | Shift      |
      | SS5         | NG_RZ_ST_Scenario05 | NG_RZ_ST_Scenario05  | [TAB:tab5] |

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

    Given instance "RiskModel1" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id    | Stress Testing  Methodology |
      | RM05        | NG_RZ_ST_Model05 | NG_RZ_ST_Scenario04         |

    Given instance "RiskModel1" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id    | Stress Testing  Methodology |
      | RM06        | NG_RZ_ST_Model06 | NG_RZ_ST_Scenario05         |

    #Risk Model with multiple Scenarios
    Given instance "RiskModel1" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id    | Stress Testing  Methodology                                 |
      | RM07        | NG_RZ_ST_Model07 | NG_RZ_ST_Scenario01,NG_RZ_ST_Scenario02,NG_RZ_ST_Scenario03 |

    #Risk Model without Scenarios
    Given instance "RiskModel1" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id    | Stress Testing  Methodology |
      | RM08        | NG_RZ_ST_Model08 |                             |

  @refdata
  Scenario: Stress testing data setup NG_Updated for another Bond Instrument

    Given instance "USTreasury-Act/Act" of entity "Instruments" is copied with following values
      | Instance ID | Symbol         | ISIN           | Instrument Type |
      | Curve3      | NG_RZ_ST_Cur04 | NG_RZ_ST_Cur04 | CURVES          |

    Given instance "USTreasury10Y-Act/Act" of entity "Instruments" is copied with following values
      | Instance ID | Symbol              | ISIN                | Instrument Type | Tenor | Curve Identifier |
      | Rate1D      | NG_RZ_ST_02_Rate1D  | NG_RZ_ST_02_Rate1D  | SPOT_RATE       | 1D    | [Curve3.Symbol]  |
      | Rate1M      | NG_RZ_ST_02_Rate1M  | NG_RZ_ST_02_Rate1M  | SPOT_RATE       | 1M    | [Curve3.Symbol]  |
      | Rate3M      | NG_RZ_ST_02_Rate3M  | NG_RZ_ST_02_Rate3M  | SPOT_RATE       | 3M    | [Curve3.Symbol]  |
      | Rate6M      | NG_RZ_ST_02_Rate6M  | NG_RZ_ST_02_Rate6M  | SPOT_RATE       | 6M    | [Curve3.Symbol]  |
      | Rate1Y      | NG_RZ_ST_02_Rate1Y  | NG_RZ_ST_02_Rate1Y  | SPOT_RATE       | 1Y    | [Curve3.Symbol]  |
      | Rate2Y      | NG_RZ_ST_02_Rate2Y  | NG_RZ_ST_02_Rate2Y  | SPOT_RATE       | 2Y    | [Curve3.Symbol]  |
      | Rate3Y      | NG_RZ_ST_02_Rate3Y  | NG_RZ_ST_02_Rate3Y  | SPOT_RATE       | 3Y    | [Curve3.Symbol]  |
      | Rate5Y      | NG_RZ_ST_02_Rate5Y  | NG_RZ_ST_02_Rate5Y  | SPOT_RATE       | 5Y    | [Curve3.Symbol]  |
      | Rate7Y      | NG_RZ_ST_02_Rate7Y  | NG_RZ_ST_02_Rate7Y  | SPOT_RATE       | 7Y    | [Curve3.Symbol]  |
      | Rate10Y     | NG_RZ_ST_02_Rate10Y | NG_RZ_ST_02_Rate10Y | SPOT_RATE       | 10Y   | [Curve3.Symbol]  |
      | Rate20Y     | NG_RZ_ST_02_Rate20Y | NG_RZ_ST_02_Rate20Y | SPOT_RATE       | 20Y   | [Curve3.Symbol]  |
      | Rate30Y     | NG_RZ_ST_02_Rate30Y | NG_RZ_ST_02_Rate30Y | SPOT_RATE       | 30Y   | [Curve3.Symbol]  |

    Given "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol              | dataClass | type | value |
      | MRate1D     | NG_RZ_ST_02_Rate1D  | RATE      | LTP  | 0.83  |
      | MRate1M     | NG_RZ_ST_02_Rate1M  | RATE      | LTP  | 0.83  |
      | MRate3M     | NG_RZ_ST_02_Rate3M  | RATE      | LTP  | 1.06  |
      | MRate6M     | NG_RZ_ST_02_Rate6M  | RATE      | LTP  | 1.58  |
      | MRate1Y     | NG_RZ_ST_02_Rate1Y  | RATE      | LTP  | 2.09  |
      | MRate2Y     | NG_RZ_ST_02_Rate2Y  | RATE      | LTP  | 2.55  |
      | MRate3Y     | NG_RZ_ST_02_Rate3Y  | RATE      | LTP  | 2.88  |
      | MRate5Y     | NG_RZ_ST_02_Rate5Y  | RATE      | LTP  | 2.90  |
      | MRate7Y     | NG_RZ_ST_02_Rate7Y  | RATE      | LTP  | 2.95  |
      | MRate10Y    | NG_RZ_ST_02_Rate10Y | RATE      | LTP  | 3.05  |
      | MRate20Y    | NG_RZ_ST_02_Rate20Y | RATE      | LTP  | 3.25  |
      | MRate30Y    | NG_RZ_ST_02_Rate30Y | RATE      | LTP  | 3.35  |

    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
      | Instance ID | Symbol          | ISIN            | Instrument Type | Discount Curve  | Par Value |
      | Bond2       | NG_RZ_ST_Bond02 | NG_RZ_ST_Bond02 | Fixed Rate Bond | [Curve3.Symbol] | 100       |

    Given table "tab1" is created with following values
      | Instance ID | Risk Factor Type | Symbol              | Shift Type | Shift Percentage |
      | te1         | INTEREST_RATE    | NG_RZ_ST_02_Rate30Y | ABSOLUTE   | 1                |
      | te2         | INTEREST_RATE    | NG_RZ_ST_02_Rate10Y | ABSOLUTE   | 1.5              |
      | te3         | INTEREST_RATE    | NG_RZ_ST_02_Rate2Y  | ABSOLUTE   | 0.5              |
      | te4         | INTEREST_RATE    | NG_RZ_ST_02_Rate5Y  | ABSOLUTE   | 1.1              |

    Given instance of entity "Stress Scenarios" is created with following values
      | Instance ID | Stress Scenario Id  | Stress Scenario Name | Shift      |
      | SS1         | NG_RZ_ST_Scenario10 | NG_RZ_ST_Scenario10  | [TAB:tab1] |

    Given instance "RiskModel1" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id    | Stress Testing  Methodology                                 |
      | RM01        | NG_RZ_ST_Model10 | NG_RZ_ST_Scenario10,NG_RZ_ST_Scenario01,NG_RZ_ST_Scenario02 |

    Given table "tab2" is created with following values
      | Instance ID | Risk Factor Type | Symbol              | Shift Type | Shift Percentage |
      | te1         | INTEREST_RATE    | NG_RZ_ST_02_Rate30Y | ABSOLUTE   | 1                |
      | te2         | INTEREST_RATE    | NG_RZ_ST_Rate10Y    | ABSOLUTE   | 1.5              |
      | te3         | INTEREST_RATE    | NG_RZ_ST_02_Rate2Y  | ABSOLUTE   | 0.5              |
      | te4         | INTEREST_RATE    | NG_RZ_ST_Rate5Y     | ABSOLUTE   | 1.1              |

    Given instance of entity "Stress Scenarios" is created with following values
      | Instance ID | Stress Scenario Id  | Stress Scenario Name | Shift      |
      | SS2         | NG_RZ_ST_Scenario11 | NG_RZ_ST_Scenario11  | [TAB:tab2] |

    Given instance "RiskModel1" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id    | Stress Testing  Methodology |
      | RM02        | NG_RZ_ST_Model11 | NG_RZ_ST_Scenario11         |

    # Bond with Different PAR, Expiry Date and Coupon
    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
      | Instance ID | Symbol          | ISIN            | Instrument Type | Discount Curve | Par Value | Coupon | Expiry Date |
      | Bond3       | NG_RZ_ST_Bond03 | NG_RZ_ST_Bond03 | Fixed Rate Bond | NG_RZ_ST_Cur04 | 500       | 2      | 2033-06-07  |

    # Bond with Coupon Frequency -Annual
    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
      | Instance ID | Symbol          | ISIN            | Instrument Type | Discount Curve | Par Value | Coupon | Coupon Frequency |
      | Bond4       | NG_RZ_ST_Bond04 | NG_RZ_ST_Bond04 | Fixed Rate Bond | NG_RZ_ST_Cur04 | 100       | 2      | ANNUAL           |

    # Bond with Coupon Frequency -Monthly
    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
      | Instance ID | Symbol          | ISIN            | Instrument Type | Discount Curve | Par Value | Coupon | Coupon Frequency |
      | Bond5       | NG_RZ_ST_Bond05 | NG_RZ_ST_Bond05 | Fixed Rate Bond | NG_RZ_ST_Cur04 | 100       | 2      | MONTHLY          |

    # Bond with Coupon Frequency -Quarterly
    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
      | Instance ID | Symbol          | ISIN            | Instrument Type | Discount Curve | Par Value | Coupon | Coupon Frequency |
      | Bond6       | NG_RZ_ST_Bond06 | NG_RZ_ST_Bond06 | Fixed Rate Bond | NG_RZ_ST_Cur04 | 100       | 2      | QUARTERLY        |


  @account @done
  Scenario: TC_001 - Account - Change the existing Risk Model

    Given instance "HomeX" of entity "Accounts" is copied with following values
      | Instance ID | Participant | Account Id             | Name               | Risk Model       |
      | Acc01       | RZ_ST_01    | random(NG_RZ_ST_ACC,5) | random(NG_RZ_ST,5) | NG_RZ_ST_Model01 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol          | price | quantity | participant         | notional |
      | POU1        | [Acc01.Account Id] | NG_RZ_ST_Bond01 | 99.0  | 1        | [Acc01.Participant] | 100      |

    Then "Position" messages are filtered by "level,participant,account,symbol" should be
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

  @stressScenario @done
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

  @stressScenario @BRP-791 @fail
  Scenario: TC_003 - Add Multiple shifts with duplicate symbol for a Stress Scenario

    Given instance "HomeX" of entity "Accounts" is copied with following values
      | Instance ID | Participant | Account Id             | Name               | Risk Model       |
      | Acc01       | RZ_ST_01    | random(NG_RZ_ST_ACC,5) | random(NG_RZ_ST,5) | NG_RZ_ST_Model05 |

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
      | Result1     | [Run1.id] | [Acc01.Account Id] | NG_RZ_ST_Scenario04 | current_value(RZ_ST_01,[Acc01.Account Id]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario04) |

  @stressScenario @done
  Scenario: TC_004 - With a symbol which is not a tenor of IR curve for a Stress Scenario

    Given instance "HomeX" of entity "Accounts" is copied with following values
      | Instance ID | Participant | Account Id             | Name               | Risk Model       |
      | Acc01       | RZ_ST_01    | random(NG_RZ_ST_ACC,5) | random(NG_RZ_ST,5) | NG_RZ_ST_Model06 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol          | price | quantity | participant         | notional |
      | POU1        | [Acc01.Account Id] | NG_RZ_ST_Bond01 | 99.0  | 1        | [Acc01.Participant] | 500      |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
      | Instance ID | participant         | account            | level   | symbol          | notional |
      | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | NG_RZ_ST_Bond01 | 500.0    |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId          | currentValue                               | stressedValue                                                   |
      | Result1     | [Run1.id] | [Acc01.Account Id] | NG_RZ_ST_Scenario05 | current_value(RZ_ST_01,[Acc01.Account Id]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario05) |

  @stressScenario @failduetoeditStep-frameworkissue
  Scenario: TC_005 - Change shifts of a Stress Scenario intraday

      # Create Stress Scenario
    Given table "tab1" is created with following values
      | Instance ID | Risk Factor Type | Symbol          | Shift Type | Shift Percentage |
      | te1         | INTEREST_RATE    | NG_RZ_ST_Rate2Y | RELATIVE   | 0.5              |

    And instance of entity "Stress Scenarios" is created with following values
      | Instance ID | Stress Scenario Id           | Stress Scenario Name         | Shift      |
      | SS1         | random(NG_RZ_ST_Scenario_,4) | random(NG_RZ_ST_Scenario_,4) | [TAB:tab1] |

    And instance "RiskModel1" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id             | Stress Testing  Methodology |
      | RM01        | random(NG_RZ_ST_Model_,4) | [SS1.Stress Scenario Id]    |

    # Run first Stress Test
    Given instance "HomeX" of entity "Accounts" is copied with following values
      | Instance ID | Participant | Account Id             | Name               | Risk Model           |
      | Acc01       | RZ_ST_01    | random(NG_RZ_ST_ACC,5) | random(NG_RZ_ST,5) | [RM01.Risk Model Id] |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol          | price | quantity | participant         | notional |
      | POU1        | [Acc01.Account Id] | NG_RZ_ST_Bond01 | 99.0  | 2        | [Acc01.Participant] | 600      |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
      | Instance ID | participant         | account            | level   | symbol          | notional |
      | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | NG_RZ_ST_Bond01 | 600.0    |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId               | currentValue                               | stressedValue                                                        |
      | Result1     | [Run1.id] | [Acc01.Account Id] | [SS1.Stress Scenario Id] | current_value(RZ_ST_01,[Acc01.Account Id]) | stressed_value(RZ_ST_01,[Acc01.Account Id],[SS1.Stress Scenario Id]) |

      # Update the Stress Scenario by adding another Shift
    Given table "tab2" is created with following values
      | Instance ID | Risk Factor Type | Symbol          | Shift Type | Shift Percentage |
      | te2         | INTEREST_RATE    | NG_RZ_ST_Rate2Y | RELATIVE   | 0.5              |
      | te3         | INTEREST_RATE    | NG_RZ_ST_Rate5Y | RELATIVE   | 1.5              |

    Given instance "SS1" of entity "Stress Scenarios" is updated with adding following Shifts
      | Instance ID | Shift      |
      | SS1         | [TAB:tab2] |

     # Run Stress Test again after the Stress Scenario update
    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT02       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run2        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId               | currentValue                               | stressedValue                                                        |
      | Result2     | [Run2.id] | [Acc01.Account Id] | [SS1.Stress Scenario Id] | current_value(RZ_ST_01,[Acc01.Account Id]) | stressed_value(RZ_ST_01,[Acc01.Account Id],[SS1.Stress Scenario Id]) |

     # Update the Stress Scenario by removing a Shift
    Given table "tab3" is created with following values
      | Instance ID | Risk Factor Type | Symbol          | Shift Type | Shift Percentage |
      | te4         | INTEREST_RATE    | NG_RZ_ST_Rate5Y | RELATIVE   | 1.5              |

    Given instance "SS1" of entity "Stress Scenarios" is updated with adding following Shifts
      | Instance ID | Shift      |
      | SS1         | [TAB:tab3] |

     # Run Stress Test again after the Stress Scenario update
    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT03       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run3        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId               | currentValue                               | stressedValue                                                        |
      | Result3     | [Run3.id] | [Acc01.Account Id] | [SS1.Stress Scenario Id] | current_value(RZ_ST_01,[Acc01.Account Id]) | stressed_value(RZ_ST_01,[Acc01.Account Id],[SS1.Stress Scenario Id]) |

  @stressScenario @done
  Scenario: TC_006 - Risk Model with Multiple Stress Test Scenarios

    Given instance "HomeX" of entity "Accounts" is copied with following values
      | Instance ID | Participant | Account Id             | Name               | Risk Model       |
      | Acc01       | RZ_ST_01    | random(NG_RZ_ST_ACC,5) | random(NG_RZ_ST,5) | NG_RZ_ST_Model07 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol          | price | quantity | participant         | notional | side  |
      | POU1        | [Acc01.Account Id] | NG_RZ_ST_Bond01 | 99.0  | 10       | [Acc01.Participant] | 1000     | SHORT |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
      | Instance ID | participant         | account            | level   | symbol          | notional |
      | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | NG_RZ_ST_Bond01 | -1000.0  |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId          | currentValue                               | stressedValue                                                   |
      | Result1     | [Run1.id] | [Acc01.Account Id] | NG_RZ_ST_Scenario01 | current_value(RZ_ST_01,[Acc01.Account Id]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario01) |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId          | currentValue                               | stressedValue                                                   |
      | Result2     | [Run1.id] | [Acc01.Account Id] | NG_RZ_ST_Scenario02 | current_value(RZ_ST_01,[Acc01.Account Id]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario02) |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId          | currentValue                               | stressedValue                                                   |
      | Result3     | [Run1.id] | [Acc01.Account Id] | NG_RZ_ST_Scenario03 | current_value(RZ_ST_01,[Acc01.Account Id]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario03) |

    # Do another Position update and run the second stress Test
    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol          | price | quantity | participant         | notional | side |
      | POU2        | [Acc01.Account Id] | NG_RZ_ST_Bond01 | 99.0  | 5        | [Acc01.Participant] | 500      | LONG |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
      | Instance ID | participant         | account            | level   | symbol          | notional |
      | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | NG_RZ_ST_Bond01 | -500.0   |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT02       | [Acc01.Account Id] |

    Then response of the request "STT02" should be
      | Instance ID |
      | Run2        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId          | currentValue                               | stressedValue                                                   |
      | Result4     | [Run2.id] | [Acc01.Account Id] | NG_RZ_ST_Scenario01 | current_value(RZ_ST_01,[Acc01.Account Id]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario01) |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId          | currentValue                               | stressedValue                                                   |
      | Result5     | [Run2.id] | [Acc01.Account Id] | NG_RZ_ST_Scenario02 | current_value(RZ_ST_01,[Acc01.Account Id]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario02) |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId          | currentValue                               | stressedValue                                                   |
      | Result6     | [Run2.id] | [Acc01.Account Id] | NG_RZ_ST_Scenario03 | current_value(RZ_ST_01,[Acc01.Account Id]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario03) |

  @stressScenario @done
  Scenario: TC_007 - Stress Tests for Multiple Accounts

    Given instance "HomeX" of entity "Accounts" is copied with following values
      | Instance ID | Participant | Account Id             | Name               | Risk Model       |
      | Acc01       | RZ_ST_01    | random(NG_RZ_ST_ACC,5) | random(NG_RZ_ST,5) | NG_RZ_ST_Model07 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol          | price | quantity | participant         | notional | side  |
      | POU1        | [Acc01.Account Id] | NG_RZ_ST_Bond01 | 99.0  | 10       | [Acc01.Participant] | 1000     | SHORT |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
      | Instance ID | participant         | account            | level   | symbol          | notional |
      | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | NG_RZ_ST_Bond01 | -1000.0  |

    Given instance "HomeX" of entity "Accounts" is copied with following values
      | Instance ID | Participant | Account Id             | Name               | Risk Model       |
      | Acc02       | RZ_ST_01    | random(NG_RZ_ST_ACC,5) | random(NG_RZ_ST,5) | NG_RZ_ST_Model07 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol          | price | quantity | participant         | notional | side |
      | POU2        | [Acc02.Account Id] | NG_RZ_ST_Bond01 | 99.0  | 10       | [Acc02.Participant] | 1000     | LONG |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
      | Instance ID | participant         | account            | level   | symbol          | notional |
      | POS_Res2    | [Acc02.Participant] | [Acc02.Account Id] | ACCOUNT | NG_RZ_ST_Bond01 | 1000.0   |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account                               |
      | STT01       | [Acc01.Account Id],[Acc02.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId          | currentValue                               | stressedValue                                                   |
      | Result1     | [Run1.id] | [Acc01.Account Id] | NG_RZ_ST_Scenario01 | current_value(RZ_ST_01,[Acc01.Account Id]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario01) |
      | Result2     | [Run1.id] | [Acc02.Account Id] | NG_RZ_ST_Scenario01 | current_value(RZ_ST_01,[Acc02.Account Id]) | stressed_value(RZ_ST_01,[Acc02.Account Id],NG_RZ_ST_Scenario01) |

  @done
  Scenario: TC_008 - Stress Test for an account which has Positions for Multiple Bonds + Validate Individual Positions

    Given instance "HomeX" of entity "Accounts" is copied with following values
      | Instance ID | Participant | Account Id             | Name               | Risk Model       |
      | Acc01       | RZ_ST_01    | random(NG_RZ_ST_ACC,5) | random(NG_RZ_ST,5) | NG_RZ_ST_Model11 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol          | price | quantity | participant         | notional | side  |
      | POU1        | [Acc01.Account Id] | NG_RZ_ST_Bond01 | 99.0  | 10       | [Acc01.Participant] | 1000     | SHORT |

    Then "Position" messages are filtered by "level,participant,account,symbol" should be
      | Instance ID | participant         | account            | level   | symbol          | notional |
      | POU1_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | NG_RZ_ST_Bond01 | -1000.0  |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol          | price | quantity | participant         | notional | side |
      | POU2        | [Acc01.Account Id] | NG_RZ_ST_Bond02 | 99.0  | 10       | [Acc01.Participant] | 1000     | LONG |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
      | Instance ID | participant         | account            | level   | symbol          | notional |
      | POU2_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | NG_RZ_ST_Bond02 | 1000.0   |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId          | currentValue                               | stressedValue                                                   |
      | Result1     | [Run1.id] | [Acc01.Account Id] | NG_RZ_ST_Scenario11 | current_value(RZ_ST_01,[Acc01.Account Id]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario11) |

    #Verify the Stress Testing for Each Positions
    And "Stress Test Detailed Result" messages are filtered by "runId,accountId,scenarioId,symbol" should be
      | Instance ID | runId     | accountId          | symbol          | scenarioId          | currentValue                                                      | stressValue                                                                            |
      | Result2     | [Run1.id] | [Acc01.Account Id] | NG_RZ_ST_Bond01 | NG_RZ_ST_Scenario11 | current_value(RZ_ST_01,[Acc01.Account Id],[POU1_Res1.positionId]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario11,[POU1_Res1.positionId]) |
      | Result3     | [Run1.id] | [Acc01.Account Id] | NG_RZ_ST_Bond02 | NG_RZ_ST_Scenario11 | current_value(RZ_ST_01,[Acc01.Account Id],[POU2_Res1.positionId]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario11,[POU2_Res1.positionId]) |

  @wip
  Scenario: TC_009 - Stress Test for a Symbols with different Expiry Date Par Value and Coupon

    Given instance "HomeX" of entity "Accounts" is copied with following values
      | Instance ID | Participant | Account Id             | Name               | Risk Model       |
      | Acc01       | RZ_ST_01    | random(NG_RZ_ST_ACC,5) | random(NG_RZ_ST,5) | NG_RZ_ST_Model11 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol          | price | quantity | participant         | notional | side  |
      | POU1        | [Acc01.Account Id] | NG_RZ_ST_Bond01 | 99.0  | 10       | [Acc01.Participant] | 1000     | SHORT |

    Then "Position" messages are filtered by "level,participant,account,symbol" should be
      | Instance ID | participant         | account            | level   | symbol          | notional |
      | POU1_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | NG_RZ_ST_Bond01 | -1000.0  |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol          | price | quantity | participant         | notional | side |
      | POU2        | [Acc01.Account Id] | NG_RZ_ST_Bond03 | 499.0 | 2        | [Acc01.Participant] | 1000     | LONG |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
      | Instance ID | participant         | account            | level   | symbol          | notional |
      | POU2_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | NG_RZ_ST_Bond03 | 1000.0   |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId          | currentValue                               | stressedValue                                                   |
      | Result1     | [Run1.id] | [Acc01.Account Id] | NG_RZ_ST_Scenario11 | current_value(RZ_ST_01,[Acc01.Account Id]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario11) |

    #Verify the Stress Testing for Each Positions
    And "Stress Test Detailed Result" messages are filtered by "runId,accountId,scenarioId,symbol" should be
      | Instance ID | runId     | accountId          | symbol          | scenarioId          | currentValue                                                      | stressValue                                                                            |
      | Result2     | [Run1.id] | [Acc01.Account Id] | NG_RZ_ST_Bond01 | NG_RZ_ST_Scenario11 | current_value(RZ_ST_01,[Acc01.Account Id],[POU1_Res1.positionId]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario11,[POU1_Res1.positionId]) |
      | Result3     | [Run1.id] | [Acc01.Account Id] | NG_RZ_ST_Bond03 | NG_RZ_ST_Scenario11 | current_value(RZ_ST_01,[Acc01.Account Id],[POU2_Res1.positionId]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario11,[POU2_Res1.positionId]) |

  @done
  Scenario: TC_010 - Stress Test for Symbols with different Coupon Frequencies and Day count Conversions

    Given instance "HomeX" of entity "Accounts" is copied with following values
      | Instance ID | Participant | Account Id             | Name               | Risk Model       |
      | Acc01       | RZ_ST_01    | random(NG_RZ_ST_ACC,5) | random(NG_RZ_ST,5) | NG_RZ_ST_Model11 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol          | price | quantity | participant         | notional | side  |
      | POU1        | [Acc01.Account Id] | NG_RZ_ST_Bond04 | 99.0  | 10       | [Acc01.Participant] | 1000     | SHORT |
      | POU2        | [Acc01.Account Id] | NG_RZ_ST_Bond05 | 200.0 | 2        | [Acc01.Participant] | 400      | SHORT |
      | POU3        | [Acc01.Account Id] | NG_RZ_ST_Bond06 | 100.0 | 10       | [Acc01.Participant] | 1000     | SHORT |

    Then "Position" messages are filtered by "level,participant,account,symbol" should be
      | Instance ID | participant         | account            | level   | symbol          | notional |
      | POU1_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | NG_RZ_ST_Bond04 | -1000.0  |
      | POU2_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | NG_RZ_ST_Bond05 | -400.0   |
      | POU3_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | NG_RZ_ST_Bond06 | -1000.0  |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId          | currentValue                               | stressedValue                                                   |
      | Result1     | [Run1.id] | [Acc01.Account Id] | NG_RZ_ST_Scenario11 | current_value(RZ_ST_01,[Acc01.Account Id]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario11) |

    #Verify the Stress Testing for Each Positions
    And "Stress Test Detailed Result" messages are filtered by "runId,accountId,scenarioId,symbol" should be
      | Instance ID | runId     | accountId          | symbol          | scenarioId          | currentValue                                                      | stressValue                                                                            |
      | Result2     | [Run1.id] | [Acc01.Account Id] | NG_RZ_ST_Bond04 | NG_RZ_ST_Scenario11 | current_value(RZ_ST_01,[Acc01.Account Id],[POU1_Res1.positionId]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario11,[POU1_Res1.positionId]) |
      | Result3     | [Run1.id] | [Acc01.Account Id] | NG_RZ_ST_Bond05 | NG_RZ_ST_Scenario11 | current_value(RZ_ST_01,[Acc01.Account Id],[POU2_Res1.positionId]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario11,[POU2_Res1.positionId]) |
      | Result4     | [Run1.id] | [Acc01.Account Id] | NG_RZ_ST_Bond06 | NG_RZ_ST_Scenario11 | current_value(RZ_ST_01,[Acc01.Account Id],[POU3_Res1.positionId]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario11,[POU3_Res1.positionId]) |

    # Change the Business Day Convention in each Symbol ( To have all the Business day Convention Values)
    When instance "NG_RZ_ST_Bond02" of entity "Instruments" is updated with following values
      | Instance ID | Business Day Convention |
      | Updt_01     | MODIFIED_PRECEDING      |

    When instance "NG_RZ_ST_Bond03" of entity "Instruments" is updated with following values
      | Instance ID | Business Day Convention |
      | Updt_02     | DAY_FOLLOWING           |

    When instance "NG_RZ_ST_Bond04" of entity "Instruments" is updated with following values
      | Instance ID | Business Day Convention |
      | Updt_03     | DAY_PRECEDING           |

    When instance "NG_RZ_ST_Bond05" of entity "Instruments" is updated with following values
      | Instance ID | Business Day Convention |
      | Updt_04     | UNADJUSTED              |

    When instance "NG_RZ_ST_Bond06" of entity "Instruments" is updated with following values
      | Instance ID | Business Day Convention |
      | Updt_05     | MODIFIED_FOLLOWING      |

    #Add New Positions
    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol          | price | quantity | participant         | notional | side  |
      | POU4        | [Acc01.Account Id] | NG_RZ_ST_Bond02 | 99.0  | 10       | [Acc01.Participant] | 1000     | SHORT |
      | POU5        | [Acc01.Account Id] | NG_RZ_ST_Bond03 | 99.0  | 10       | [Acc01.Participant] | 1000     | SHORT |
      | POU6        | [Acc01.Account Id] | NG_RZ_ST_Bond04 | 99.0  | 10       | [Acc01.Participant] | 1000     | LONG  |
      | POU7        | [Acc01.Account Id] | NG_RZ_ST_Bond05 | 200.0 | 2        | [Acc01.Participant] | 400      | LONG  |
      | POU8        | [Acc01.Account Id] | NG_RZ_ST_Bond06 | 100.0 | 10       | [Acc01.Participant] | 1000     | LONG  |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
      | Instance ID | participant         | account            | level   | symbol          | notional |
      | POU4_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | NG_RZ_ST_Bond02 | -1000.0  |
      | POU5_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | NG_RZ_ST_Bond03 | -1000.0  |
      | POU6_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | NG_RZ_ST_Bond04 | 0.0      |
      | POU7_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | NG_RZ_ST_Bond05 | 0.0      |
      | POU8_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | NG_RZ_ST_Bond06 | 0.0      |

    # Run another Stress Test after the Instrument modifications
    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT02       | [Acc01.Account Id] |

    Then response of the request "STT02" should be
      | Instance ID |
      | Run2        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId          | currentValue                               | stressedValue                                                   |
      | Result1     | [Run2.id] | [Acc01.Account Id] | NG_RZ_ST_Scenario11 | current_value(RZ_ST_01,[Acc01.Account Id]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario11) |

    #Verify the Stress Testing for Each Positions
    And "Stress Test Detailed Result" messages are filtered by "runId,accountId,scenarioId,symbol" should be
      | Instance ID | runId     | accountId          | symbol          | scenarioId          | currentValue                                                      | stressValue                                                                            |
      | Result2     | [Run2.id] | [Acc01.Account Id] | NG_RZ_ST_Bond04 | NG_RZ_ST_Scenario11 | current_value(RZ_ST_01,[Acc01.Account Id],[POU1_Res1.positionId]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario11,[POU1_Res1.positionId]) |
      | Result3     | [Run2.id] | [Acc01.Account Id] | NG_RZ_ST_Bond05 | NG_RZ_ST_Scenario11 | current_value(RZ_ST_01,[Acc01.Account Id],[POU2_Res1.positionId]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario11,[POU2_Res1.positionId]) |
      | Result4     | [Run2.id] | [Acc01.Account Id] | NG_RZ_ST_Bond06 | NG_RZ_ST_Scenario11 | current_value(RZ_ST_01,[Acc01.Account Id],[POU3_Res1.positionId]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario11,[POU3_Res1.positionId]) |


  @done
  Scenario: TC_011 - Update the attached Discount curve

    Given instance "HomeX" of entity "Accounts" is copied with following values
      | Instance ID | Participant | Account Id             | Name               | Risk Model       |
      | Acc01       | RZ_ST_01    | random(NG_RZ_ST_ACC,5) | random(NG_RZ_ST,5) | NG_RZ_ST_Model01 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol          | price | quantity | participant         | notional |
      | POU1        | [Acc01.Account Id] | NG_RZ_ST_Bond06 | 99.0  | 100       | [Acc01.Participant] | 10000     |

    Then "Position" messages are filtered by "level,participant,account,symbol" should be
      | Instance ID | participant         | account            | level   | symbol          | notional |
      | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | NG_RZ_ST_Bond06 | 10000.0   |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId          | currentValue                               | stressedValue                                                   |
      | Result1     | [Run1.id] | [Acc01.Account Id] | NG_RZ_ST_Scenario01 | current_value(RZ_ST_01,[Acc01.Account Id]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario01) |

    #Update the Discount Curve of the Instrument
    When instance "NG_RZ_ST_Bond06" of entity "Instruments" is updated with following values
      | Instance ID | Discount Curve |
      | Updt_01     | NG_RZ_ST_Cur01      |

    #Run another Stress Test
    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT02       | [Acc01.Account Id] |

    Then response of the request "STT02" should be
      | Instance ID |
      | Run2        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId          | currentValue                               | stressedValue                                                   |
      | Result1     | [Run2.id] | [Acc01.Account Id] | NG_RZ_ST_Scenario01 | current_value(RZ_ST_01,[Acc01.Account Id]) | stressed_value(RZ_ST_01,[Acc01.Account Id],NG_RZ_ST_Scenario01) |


  @fff
  Scenario: ref data f

    Given instance "HomeX" of entity "Accounts" is copied with following values
      | Instance ID | Participant | Account Id             | Name               | Risk Model       |
      | Acc01       | RZ_ST_01    | random(NG_RZ_ST_ACC,5) | random(NG_RZ_ST,5) | NG_RZ_ST_Model11 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol          | price | quantity | participant         | notional | side  |
      | POU1        | [Acc01.Account Id] | NG_RZ_ST_Bond01 | 99.0  | 10       | [Acc01.Participant] | 1000     | SHORT |
      | POU2        | [Acc01.Account Id] | NG_RZ_ST_Bond03 | 499.0 | 2        | [Acc01.Participant] | 1000     | LONG  |

    Then "Position" messages are filtered by "level,participant,account,symbol" should be
      | Instance ID | participant         | account            | level   | symbol          | notional |
      | POU1_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | NG_RZ_ST_Bond01 | -1000.0  |
      | POU2_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | NG_RZ_ST_Bond03 | 1000.0   |
  @sampleforupdates
  Scenario: Update Stress Scenario intraday

      # Create Stress Scenario
    Given table "tab1" is created with following values
      | Instance ID | Risk Factor Type | Symbol          | Shift Type | Shift Percentage |
      | te1         | INTEREST_RATE    | NG_RZ_ST_Rate2Y | RELATIVE   | 0.5              |

    And instance of entity "Stress Scenarios" is created with following values
      | Instance ID | Stress Scenario Id           | Stress Scenario Name         | Shift      |
      | SS1         | random(NG_RZ_ST_Scenario_,4) | random(NG_RZ_ST_Scenario_,4) | [TAB:tab1] |

    And instance "RiskModel1" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id             | Stress Testing  Methodology |
      | RM01        | random(NG_RZ_ST_Model_,4) | [SS1.Stress Scenario Id]    |

    Given table "tab2" is created with following values
      | Instance ID | Risk Factor Type | Symbol          | Shift Type | Shift Percentage |
      | te2         | INTEREST_RATE    | NG_RZ_ST_Rate2Y | RELATIVE   | 0.5              |
      | te3         | INTEREST_RATE    | NG_RZ_ST_Rate5Y | RELATIVE   | 1.5              |

    Given instance "[SS1.Stress Scenario Id]" of entity "Stress Scenarios" is updated with adding following Shifts
      | Instance ID | Shift      |
      | SS1         | [TAB:tab2] |

#    Then "Position" messages are filtered by "level,participant,account" should be
#      | Instance ID | participant | level   | account                                                                    |
#      | POS_Res1    | RZ_ST_01    | ACCOUNT | current_value(RZ_ST_01,RZ_ST_ACC71934)                                     |
#      | POS_Res2    | RZ_ST_01    | ACCOUNT | stressed_value(RZ_ST_01,RZ_ST_ACC71934,RZ_ST_Scenario02)                   |
#      | POS_Res3    | RZ_ST_01    | ACCOUNT | current_value(RZ_ST_01,RZ_ST_ACC71934,[POS1.positionId])                   |
#      | POS_Res4    | RZ_ST_01    | ACCOUNT | stressed_value(RZ_ST_01,RZ_ST_ACC71934,RZ_ST_Scenario02,[POS1.positionId]) |
#    # participant | account > Current value of the Account
#
