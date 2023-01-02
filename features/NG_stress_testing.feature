Feature: Stress testing


  @refdata
  Scenario: Stress testing data setup NG_Updated

    Given instance "RZ-Base-Ins-Curv-01" of entity "Instruments" is copied with following values
      | Instance ID | Symbol      | ISIN        | Instrument Type |
      | Curve1      | RZ_ST_Cur01 | RZ_ST_Cur01 | CURVES          |

    And instance "RZ-Base-Ins-Spot-01" of entity "Instruments" is copied with following values
      | Instance ID | Symbol        | ISIN          | Instrument Type | Tenor | Curve Identifier |
      | Rate1D      | RZ_ST_Rate1D  | RZ_ST_Rate1D  | SPOT_RATE       | 1D    | [Curve1.Symbol]  |
      | Rate1M      | RZ_ST_Rate1M  | RZ_ST_Rate1M  | SPOT_RATE       | 1M    | [Curve1.Symbol]  |
      | Rate3M      | RZ_ST_Rate3M  | RZ_ST_Rate3M  | SPOT_RATE       | 3M    | [Curve1.Symbol]  |
      | Rate6M      | RZ_ST_Rate6M  | RZ_ST_Rate6M  | SPOT_RATE       | 6M    | [Curve1.Symbol]  |
      | Rate1Y      | RZ_ST_Rate1Y  | RZ_ST_Rate1Y  | SPOT_RATE       | 1Y    | [Curve1.Symbol]  |
      | Rate2Y      | RZ_ST_Rate2Y  | RZ_ST_Rate2Y  | SPOT_RATE       | 2Y    | [Curve1.Symbol]  |
      | Rate3Y      | RZ_ST_Rate3Y  | RZ_ST_Rate3Y  | SPOT_RATE       | 3Y    | [Curve1.Symbol]  |
      | Rate5Y      | RZ_ST_Rate5Y  | RZ_ST_Rate5Y  | SPOT_RATE       | 5Y    | [Curve1.Symbol]  |
      | Rate7Y      | RZ_ST_Rate7Y  | RZ_ST_Rate7Y  | SPOT_RATE       | 7Y    | [Curve1.Symbol]  |
      | Rate10Y     | RZ_ST_Rate10Y | RZ_ST_Rate10Y | SPOT_RATE       | 10Y   | [Curve1.Symbol]  |
      | Rate20Y     | RZ_ST_Rate20Y | RZ_ST_Rate20Y | SPOT_RATE       | 20Y   | [Curve1.Symbol]  |
      | Rate30Y     | RZ_ST_Rate30Y | RZ_ST_Rate30Y | SPOT_RATE       | 30Y   | [Curve1.Symbol]  |

    Given "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol        | dataClass | type | value |
      | MRate1D     | RZ_ST_Rate1D  | RATE      | LTP  | 0.83  |
      | MRate1M     | RZ_ST_Rate1M  | RATE      | LTP  | 0.83  |
      | MRate3M     | RZ_ST_Rate3M  | RATE      | LTP  | 1.06  |
      | MRate6M     | RZ_ST_Rate6M  | RATE      | LTP  | 1.58  |
      | MRate1Y     | RZ_ST_Rate1Y  | RATE      | LTP  | 2.09  |
      | MRate2Y     | RZ_ST_Rate2Y  | RATE      | LTP  | 2.55  |
      | MRate3Y     | RZ_ST_Rate3Y  | RATE      | LTP  | 2.88  |
      | MRate5Y     | RZ_ST_Rate5Y  | RATE      | LTP  | 2.90  |
      | MRate7Y     | RZ_ST_Rate7Y  | RATE      | LTP  | 2.95  |
      | MRate10Y    | RZ_ST_Rate10Y | RATE      | LTP  | 3.05  |
      | MRate20Y    | RZ_ST_Rate20Y | RATE      | LTP  | 3.25  |
      | MRate30Y    | RZ_ST_Rate30Y | RATE      | LTP  | 3.35  |

    Given instance "RZ-Base-Ins-Fixed-01" of entity "Instruments" is copied with following values
      | Instance ID | Symbol       | ISIN         | Instrument Type | Discount Curve  | Par Value |
      | Bond1       | RZ_ST_Bond01 | RZ_ST_Bond01 | Fixed Rate Bond | [Curve1.Symbol] | 100       |

    Given instance "RZ-Base-Firm-1" of entity "Participants" is copied with following values
      | Instance ID | Participant Id |
      | Part01      | RZ_ST_Firm01   |

    Given table "tab1" is created with following values
      | Instance ID | Risk Factor Type | Symbol        | Shift Type | Shift Percentage |
      | te1         | INTEREST_RATE    | RZ_ST_Rate30Y | ABSOLUTE   | 1                |
      | te2         | INTEREST_RATE    | RZ_ST_Rate1Y  | ABSOLUTE   | 1.5              |

    Given instance of entity "Stress Scenarios" is created with following values
      | Instance ID | Stress Scenario Id | Stress Scenario Name | Shift      |
      | SS1         | RZ_ST_Scenario01   | RZ_ST_Scenario01     | [TAB:tab1] |

    Given table "tab2" is created with following values
      | Instance ID | Risk Factor Type | Symbol       | Shift Type | Shift Percentage |
      | te3         | INTEREST_RATE    | RZ_ST_Rate2Y | ABSOLUTE   | 0.5              |
      | te4         | INTEREST_RATE    | RZ_ST_Rate5Y | ABSOLUTE   | 1.1              |

    Given instance of entity "Stress Scenarios" is created with following values
      | Instance ID | Stress Scenario Id | Stress Scenario Name | Shift      |
      | SS2         | RZ_ST_Scenario02   | RZ_ST_Scenario02     | [TAB:tab2] |

    # Create Stress Scenario with Multiple Shift Types for Tenors
    Given table "tab3" is created with following values
      | Instance ID | Risk Factor Type | Symbol        | Shift Type | Shift Percentage |
      | te5         | INTEREST_RATE    | RZ_ST_Rate2Y  | RELATIVE   | 0.5              |
      | te6         | INTEREST_RATE    | RZ_ST_Rate5Y  | ABSOLUTE   | 1.1              |
      | te7         | INTEREST_RATE    | RZ_ST_Rate7Y  | ABSOLUTE   | 0.5              |
      | te8         | INTEREST_RATE    | RZ_ST_Rate10Y | RELATIVE   | 1.1              |

    Given instance of entity "Stress Scenarios" is created with following values
      | Instance ID | Stress Scenario Id | Stress Scenario Name | Shift      |
      | SS3         | RZ_ST_Scenario03   | RZ_ST_Scenario03     | [TAB:tab3] |

    # Create Stress Scenario with Duplicate Tenors with different Shift Types and percentages
    Given table "tab4" is created with following values
      | Instance ID | Risk Factor Type | Symbol       | Shift Type | Shift Percentage |
      | te9         | INTEREST_RATE    | RZ_ST_Rate2Y | RELATIVE   | 0.5              |
      | te10        | INTEREST_RATE    | RZ_ST_Rate5Y | ABSOLUTE   | 2.5              |
      | te11        | INTEREST_RATE    | RZ_ST_Rate2Y | ABSOLUTE   | 4.0              |
      | te12        | INTEREST_RATE    | RZ_ST_Rate5Y | RELATIVE   | 4.0              |

    Given instance of entity "Stress Scenarios" is created with following values
      | Instance ID | Stress Scenario Id | Stress Scenario Name | Shift      |
      | SS4         | RZ_ST_Scenario04   | RZ_ST_Scenario04     | [TAB:tab4] |

    # Create Stress Scenario with a Tenors which is not a Tenor of IR Curve
    Given instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                | Size Multiplier | Par Value |
      | Inst_01     | random(RZ_ST_Bond_,4) | 2               | 200       |

    Given table "tab5" is created with following values
      | Instance ID | Risk Factor Type | Symbol           | Shift Type | Shift Percentage |
      | te13        | INTEREST_RATE    | [Inst_01.Symbol] | RELATIVE   | 0.5              |

    Given instance of entity "Stress Scenarios" is created with following values
      | Instance ID | Stress Scenario Id | Stress Scenario Name | Shift      |
      | SS5         | RZ_ST_Scenario05   | RZ_ST_Scenario05     | [TAB:tab5] |

    Given instance "RZ-Base-RModel-01" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id | Stress Testing  Methodology |
      | RM01        | RZ_ST_Model01 | RZ_ST_Scenario01            |

    Given instance "RZ-Base-RModel-01" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id | Stress Testing  Methodology       |
      | RM02        | RZ_ST_Model02 | RZ_ST_Scenario01,RZ_ST_Scenario02 |

    Given instance "RZ-Base-RModel-01" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id | Stress Testing  Methodology |
      | RM03        | RZ_ST_Model03 | RZ_ST_Scenario02            |

    Given instance "RZ-Base-RModel-01" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id | Stress Testing  Methodology |
      | RM04        | RZ_ST_Model04 | RZ_ST_Scenario03            |

    Given instance "RZ-Base-RModel-01" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id | Stress Testing  Methodology |
      | RM05        | RZ_ST_Model05 | RZ_ST_Scenario04            |

    Given instance "RZ-Base-RModel-01" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id | Stress Testing  Methodology |
      | RM06        | RZ_ST_Model06 | RZ_ST_Scenario05            |

    #Risk Model with multiple Scenarios
    Given instance "RZ-Base-RModel-01" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id | Stress Testing  Methodology                        |
      | RM07        | RZ_ST_Model07 | RZ_ST_Scenario01,RZ_ST_Scenario02,RZ_ST_Scenario03 |

    #Risk Model without Scenarios
    Given instance "RZ-Base-RModel-01" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id | Stress Testing  Methodology |
      | RM08        | RZ_ST_Model08 |                             |

  @refdata
  Scenario: Stress testing data setup NG_Updated for another Bond Instrument

    Given instance "RZ-Base-Ins-Curv-01" of entity "Instruments" is copied with following values
      | Instance ID | Symbol      | ISIN        | Instrument Type |
      | Curve3      | RZ_ST_Cur04 | RZ_ST_Cur04 | CURVES          |

    Given instance "RZ-Base-Ins-Spot-01" of entity "Instruments" is copied with following values
      | Instance ID | Symbol           | ISIN             | Instrument Type | Tenor | Curve Identifier |
      | Rate1D      | RZ_ST_02_Rate1D  | RZ_ST_02_Rate1D  | SPOT_RATE       | 1D    | [Curve3.Symbol]  |
      | Rate1M      | RZ_ST_02_Rate1M  | RZ_ST_02_Rate1M  | SPOT_RATE       | 1M    | [Curve3.Symbol]  |
      | Rate3M      | RZ_ST_02_Rate3M  | RZ_ST_02_Rate3M  | SPOT_RATE       | 3M    | [Curve3.Symbol]  |
      | Rate6M      | RZ_ST_02_Rate6M  | RZ_ST_02_Rate6M  | SPOT_RATE       | 6M    | [Curve3.Symbol]  |
      | Rate1Y      | RZ_ST_02_Rate1Y  | RZ_ST_02_Rate1Y  | SPOT_RATE       | 1Y    | [Curve3.Symbol]  |
      | Rate2Y      | RZ_ST_02_Rate2Y  | RZ_ST_02_Rate2Y  | SPOT_RATE       | 2Y    | [Curve3.Symbol]  |
      | Rate3Y      | RZ_ST_02_Rate3Y  | RZ_ST_02_Rate3Y  | SPOT_RATE       | 3Y    | [Curve3.Symbol]  |
      | Rate5Y      | RZ_ST_02_Rate5Y  | RZ_ST_02_Rate5Y  | SPOT_RATE       | 5Y    | [Curve3.Symbol]  |
      | Rate7Y      | RZ_ST_02_Rate7Y  | RZ_ST_02_Rate7Y  | SPOT_RATE       | 7Y    | [Curve3.Symbol]  |
      | Rate10Y     | RZ_ST_02_Rate10Y | RZ_ST_02_Rate10Y | SPOT_RATE       | 10Y   | [Curve3.Symbol]  |
      | Rate20Y     | RZ_ST_02_Rate20Y | RZ_ST_02_Rate20Y | SPOT_RATE       | 20Y   | [Curve3.Symbol]  |
      | Rate30Y     | RZ_ST_02_Rate30Y | RZ_ST_02_Rate30Y | SPOT_RATE       | 30Y   | [Curve3.Symbol]  |

    Given "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | dataClass | type | value |
      | MRate1D     | RZ_ST_02_Rate1D  | RATE      | LTP  | 2.83  |
      | MRate1M     | RZ_ST_02_Rate1M  | RATE      | LTP  | 2.83  |
      | MRate3M     | RZ_ST_02_Rate3M  | RATE      | LTP  | 4.06  |
      | MRate6M     | RZ_ST_02_Rate6M  | RATE      | LTP  | 4.58  |
      | MRate1Y     | RZ_ST_02_Rate1Y  | RATE      | LTP  | 8.09  |
      | MRate2Y     | RZ_ST_02_Rate2Y  | RATE      | LTP  | 8.55  |
      | MRate3Y     | RZ_ST_02_Rate3Y  | RATE      | LTP  | 8.88  |
      | MRate5Y     | RZ_ST_02_Rate5Y  | RATE      | LTP  | 8.90  |
      | MRate7Y     | RZ_ST_02_Rate7Y  | RATE      | LTP  | 8.95  |
      | MRate10Y    | RZ_ST_02_Rate10Y | RATE      | LTP  | 10.05 |
      | MRate20Y    | RZ_ST_02_Rate20Y | RATE      | LTP  | 10.25 |
      | MRate30Y    | RZ_ST_02_Rate30Y | RATE      | LTP  | 10.35 |

    Given instance "RZ-Base-Ins-Fixed-01" of entity "Instruments" is copied with following values
      | Instance ID | Symbol       | ISIN         | Instrument Type | Discount Curve  | Par Value |
      | Bond2       | RZ_ST_Bond02 | RZ_ST_Bond02 | Fixed Rate Bond | [Curve3.Symbol] | 100       |

    Given table "tab1" is created with following values
      | Instance ID | Risk Factor Type | Symbol           | Shift Type | Shift Percentage |
      | te1         | INTEREST_RATE    | RZ_ST_02_Rate30Y | ABSOLUTE   | 1                |
      | te2         | INTEREST_RATE    | RZ_ST_02_Rate10Y | ABSOLUTE   | 1.5              |
      | te3         | INTEREST_RATE    | RZ_ST_02_Rate2Y  | ABSOLUTE   | 0.5              |
      | te4         | INTEREST_RATE    | RZ_ST_02_Rate5Y  | ABSOLUTE   | 1.1              |

    Given instance of entity "Stress Scenarios" is created with following values
      | Instance ID | Stress Scenario Id | Stress Scenario Name | Shift      |
      | SS1         | RZ_ST_Scenario10   | RZ_ST_Scenario10     | [TAB:tab1] |

    Given instance "RZ-Base-RModel-01" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id | Stress Testing  Methodology                        |
      | RM01        | RZ_ST_Model10 | RZ_ST_Scenario10,RZ_ST_Scenario01,RZ_ST_Scenario02 |

    Given table "tab2" is created with following values
      | Instance ID | Risk Factor Type | Symbol           | Shift Type | Shift Percentage |
      | te1         | INTEREST_RATE    | RZ_ST_02_Rate30Y | ABSOLUTE   | 1                |
      | te2         | INTEREST_RATE    | RZ_ST_Rate10Y    | ABSOLUTE   | 1.5              |
      | te3         | INTEREST_RATE    | RZ_ST_02_Rate2Y  | ABSOLUTE   | 0.5              |
      | te4         | INTEREST_RATE    | RZ_ST_Rate5Y     | ABSOLUTE   | 1.1              |

    Given instance of entity "Stress Scenarios" is created with following values
      | Instance ID | Stress Scenario Id | Stress Scenario Name | Shift      |
      | SS2         | RZ_ST_Scenario11   | RZ_ST_Scenario11     | [TAB:tab2] |

    Given instance "RZ-Base-RModel-01" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id | Stress Testing  Methodology |
      | RM02        | RZ_ST_Model11 | RZ_ST_Scenario11            |

    # Bond with Different PAR, Expiry Date and Coupon
    Given instance "RZ-Base-Ins-Fixed-01" of entity "Instruments" is copied with following values
      | Instance ID | Symbol       | ISIN         | Instrument Type | Discount Curve | Par Value | Coupon | Expiry Date |
      | Bond3       | RZ_ST_Bond03 | RZ_ST_Bond03 | Fixed Rate Bond | RZ_ST_Cur04    | 500       | 2      | 2033-06-07  |

    # Bond with Coupon Frequency -Annual
    Given instance "RZ-Base-Ins-Fixed-01" of entity "Instruments" is copied with following values
      | Instance ID | Symbol       | ISIN         | Instrument Type | Discount Curve | Par Value | Coupon | Coupon Frequency |
      | Bond4       | RZ_ST_Bond04 | RZ_ST_Bond04 | Fixed Rate Bond | RZ_ST_Cur04    | 100       | 2      | ANNUAL           |

    # Bond with Coupon Frequency -Monthly
    Given instance "RZ-Base-Ins-Fixed-01" of entity "Instruments" is copied with following values
      | Instance ID | Symbol       | ISIN         | Instrument Type | Discount Curve | Par Value | Coupon | Coupon Frequency |
      | Bond5       | RZ_ST_Bond05 | RZ_ST_Bond05 | Fixed Rate Bond | RZ_ST_Cur04    | 100       | 2      | MONTHLY          |

    # Bond with Coupon Frequency -Quarterly
    Given instance "RZ-Base-Ins-Fixed-01" of entity "Instruments" is copied with following values
      | Instance ID | Symbol       | ISIN         | Instrument Type | Discount Curve | Par Value | Coupon | Coupon Frequency |
      | Bond6       | RZ_ST_Bond06 | RZ_ST_Bond06 | Fixed Rate Bond | RZ_ST_Cur04    | 100       | 2      | QUARTERLY        |

  @account @done
  Scenario: TC_001 - Account - Change the existing Risk Model

    Given instance "RZ-Base-Acc-02" of entity "Accounts" is copied with following values
      | Instance ID | Participant  | Account Id          | Name            | Risk Model    |
      | Acc01       | RZ_ST_Firm01 | random(RZ_ST_ACC,5) | random(RZ_ST,5) | RZ_ST_Model01 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol       | price | quantity | participant         | notional |
      | POU1        | [Acc01.Account Id] | RZ_ST_Bond01 | 99.0  | 1        | [Acc01.Participant] | 100      |

    Then "Position" messages are filtered by "level,participant,account,symbol" should be
      | Instance ID | participant         | account            | level   | symbol       | notional |
      | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond01 | 100.0    |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result1     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Scenario01 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario01) |

    # stress result impact upon a account's risk model change
    Given instance "[Acc01.Account Id]" of entity "Accounts" is updated with following values
      | Instance ID | Risk Model    |
      | Acc02       | RZ_ST_Model03 |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT02       | [Acc01.Account Id] |

    Then response of the request "STT02" should be
      | Instance ID |
      | Run2        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result2     | [Run2.id] | [Acc01.Account Id] | RZ_ST_Scenario02 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario02) |

  @stressScenario @done
  Scenario: TC_002 - Stress Scenario with relative Shift Type

    Given instance "RZ-Base-Acc-02" of entity "Accounts" is copied with following values
      | Instance ID | Participant  | Account Id          | Name            | Risk Model    |
      | Acc01       | RZ_ST_Firm01 | random(RZ_ST_ACC,5) | random(RZ_ST,5) | RZ_ST_Model04 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol       | price | quantity | participant         | notional |
      | POU1        | [Acc01.Account Id] | RZ_ST_Bond01 | 99.0  | 1        | [Acc01.Participant] | 100      |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
      | Instance ID | participant         | account            | level   | symbol       | notional |
      | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond01 | 100.0    |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result1     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Scenario03 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario03) |

  @stressScenario @BRP-791
  Scenario: TC_003 - Add Multiple shifts with duplicate symbol for a Stress Scenario

    Given instance "RZ-Base-Acc-02" of entity "Accounts" is copied with following values
      | Instance ID | Participant  | Account Id          | Name            | Risk Model    |
      | Acc01       | RZ_ST_Firm01 | random(RZ_ST_ACC,5) | random(RZ_ST,5) | RZ_ST_Model05 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol       | price | quantity | participant         | notional |
      | POU1        | [Acc01.Account Id] | RZ_ST_Bond01 | 99.0  | 1        | [Acc01.Participant] | 100      |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
      | Instance ID | participant         | account            | level   | symbol       | notional |
      | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond01 | 100.0    |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result1     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Scenario04 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario04) |

  @stressScenario @done
  Scenario: TC_004 - With a symbol which is not a tenor of IR curve for a Stress Scenario

    Given instance "RZ-Base-Acc-02" of entity "Accounts" is copied with following values
      | Instance ID | Participant  | Account Id          | Name            | Risk Model    |
      | Acc01       | RZ_ST_Firm01 | random(RZ_ST_ACC,5) | random(RZ_ST,5) | RZ_ST_Model06 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol       | price | quantity | participant         | notional |
      | POU1        | [Acc01.Account Id] | RZ_ST_Bond01 | 99.0  | 1        | [Acc01.Participant] | 100      |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
      | Instance ID | participant         | account            | level   | symbol       | notional |
      | POU1_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond01 | 100.0    |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result1     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Scenario05 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario05) |

  @gettingfailedinstep10
  Scenario: TC_005 - Change shifts of a Stress Scenario intraday

    # Create Stress Scenario
    Given table "tab1" is created with following values
      | Instance ID | Risk Factor Type | Symbol       | Shift Type | Shift Percentage |
      | te1         | INTEREST_RATE    | RZ_ST_Rate2Y | RELATIVE   | 0.5              |

    And instance of entity "Stress Scenarios" is created with following values
      | Instance ID | Stress Scenario Id        | Stress Scenario Name      | Shift      |
      | SS1         | random(RZ_ST_Scenario_,4) | random(RZ_ST_Scenario_,4) | [TAB:tab1] |

    And instance "RZ-Base-RModel-01" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id          | Stress Testing  Methodology |
      | RM01        | random(RZ_ST_Model_,4) | [SS1.Stress Scenario Id]    |

  # Run first Stress Test
    Given instance "RZ-Base-Acc-02" of entity "Accounts" is copied with following values
      | Instance ID | Participant  | Account Id          | Name            | Risk Model           |
      | Acc01       | RZ_ST_Firm01 | random(RZ_ST_ACC,5) | random(RZ_ST,5) | [RM01.Risk Model Id] |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol       | price | quantity | participant         | notional |
      | POU1        | [Acc01.Account Id] | RZ_ST_Bond01 | 99.0  | 2        | [Acc01.Participant] | 200      |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
      | Instance ID | participant         | account            | level   | symbol       | notional |
      | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond01 | 200.0    |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId               | currentValue                                   | stressedValue                                                            |
      | Result1     | [Run1.id] | [Acc01.Account Id] | [SS1.Stress Scenario Id] | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],[SS1.Stress Scenario Id]) |

    # Update the Stress Scenario by adding another Shift
    Given table "tab2" is created with following values
      | Instance ID | Risk Factor Type | Symbol       | Shift Type | Shift Percentage |
      | te2         | INTEREST_RATE    | RZ_ST_Rate2Y | RELATIVE   | 0.5              |
      | te3         | INTEREST_RATE    | RZ_ST_Rate5Y | RELATIVE   | 1.5              |

    Given instance "SS1" of entity "Stress Scenarios" is updated with following values
      | Instance ID | Shift      | Stress Scenario Id       |
      | SS2         | [TAB:tab2] | [SS1.Stress Scenario Id] |

   # Run Stress Test again after the Stress Scenario update
    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT02       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run2        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId               | currentValue                                   | stressedValue                                                            |
      | Result2     | [Run2.id] | [Acc01.Account Id] | [SS1.Stress Scenario Id] | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],[SS1.Stress Scenario Id]) |

   # Update the Stress Scenario by removing a Shift
    Given table "tab3" is created with following values
      | Instance ID | Risk Factor Type | Symbol       | Shift Type | Shift Percentage |
      | te4         | INTEREST_RATE    | RZ_ST_Rate5Y | RELATIVE   | 1.5              |

    Given instance "SS1" of entity "Stress Scenarios" is updated with following values
      | Instance ID | Shift      |
      | SS3         | [TAB:tab3] |

   # Run Stress Test again after the Stress Scenario update
    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT03       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run3        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId               | currentValue                                   | stressedValue                                                            |
      | Result3     | [Run3.id] | [Acc01.Account Id] | [SS1.Stress Scenario Id] | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],[SS1.Stress Scenario Id]) |

  @stressScenario @done
  Scenario: TC_006 - Risk Model with Multiple Stress Test Scenarios

    Given instance "RZ-Base-Acc-02" of entity "Accounts" is copied with following values
      | Instance ID | Participant  | Account Id          | Name            | Risk Model    |
      | Acc01       | RZ_ST_Firm01 | random(RZ_ST_ACC,5) | random(RZ_ST,5) | RZ_ST_Model07 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol       | price | quantity | participant         | notional | side  |
      | POU1        | [Acc01.Account Id] | RZ_ST_Bond01 | 99.0  | 10       | [Acc01.Participant] | 1000     | SHORT |

    Then "Position" messages are filtered by "level,participant,account,symbol" should be
      | Instance ID | participant         | account            | level   | symbol       | notional |
      | POU1_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond01 | -1000.0  |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result1     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Scenario01 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario01) |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result2     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Scenario02 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario02) |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result3     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Scenario03 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario03) |

    # Do another Position update and run the second stress Test
    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol       | price | quantity | participant         | notional | side |
      | POU2        | [Acc01.Account Id] | RZ_ST_Bond01 | 99.0  | 5        | [Acc01.Participant] | 500      | LONG |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
      | Instance ID | participant         | account            | level   | symbol       | notional |
      | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond01 | -500.0   |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT02       | [Acc01.Account Id] |

    Then response of the request "STT02" should be
      | Instance ID |
      | Run2        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result4     | [Run2.id] | [Acc01.Account Id] | RZ_ST_Scenario01 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario01) |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result5     | [Run2.id] | [Acc01.Account Id] | RZ_ST_Scenario02 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario02) |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result6     | [Run2.id] | [Acc01.Account Id] | RZ_ST_Scenario03 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario03) |

  @stressScenario @done
  Scenario: TC_007 - Stress Tests for Multiple Accounts

    Given instance "RZ-Base-Acc-02" of entity "Accounts" is copied with following values
      | Instance ID | Participant  | Account Id          | Name            | Risk Model    |
      | Acc01       | RZ_ST_Firm01 | random(RZ_ST_ACC,5) | random(RZ_ST,5) | RZ_ST_Model07 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol       | price | quantity | participant         | notional | side  |
      | POU1        | [Acc01.Account Id] | RZ_ST_Bond01 | 99.0  | 10       | [Acc01.Participant] | 1000     | SHORT |

    Then "Position" messages are filtered by "level,participant,account,symbol" should be
      | Instance ID | participant         | account            | level   | symbol       | notional |
      | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond01 | -1000.0  |

    Given instance "RZ-Base-Acc-02" of entity "Accounts" is copied with following values
      | Instance ID | Participant  | Account Id          | Name            | Risk Model    |
      | Acc02       | RZ_ST_Firm01 | random(RZ_ST_ACC,5) | random(RZ_ST,5) | RZ_ST_Model07 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol       | price | quantity | participant         | notional | side |
      | POU2        | [Acc02.Account Id] | RZ_ST_Bond01 | 99.0  | 10       | [Acc02.Participant] | 1000     | LONG |

    Then "Position" messages are filtered by "level,participant,account,symbol" should be
      | Instance ID | participant         | account            | level   | symbol       | notional |
      | POS_Res2    | [Acc02.Participant] | [Acc02.Account Id] | ACCOUNT | RZ_ST_Bond01 | 1000.0   |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account                               |
      | STT01       | [Acc01.Account Id],[Acc02.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result1     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Scenario01 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario01) |
      | Result2     | [Run1.id] | [Acc02.Account Id] | RZ_ST_Scenario01 | current_value(RZ_ST_Firm01,[Acc02.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc02.Account Id],RZ_ST_Scenario01) |

  @done
  Scenario: TC_008 - Stress Test for an account which has Positions for Multiple Bonds + Validate Individual Positions

    Given instance "RZ-Base-Acc-02" of entity "Accounts" is copied with following values
      | Instance ID | Participant  | Account Id          | Name            | Risk Model    |
      | Acc01       | RZ_ST_Firm01 | random(RZ_ST_ACC,5) | random(RZ_ST,5) | RZ_ST_Model11 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol       | price | quantity | participant         | notional | side  |
      | POU1        | [Acc01.Account Id] | RZ_ST_Bond01 | 99.0  | 10       | [Acc01.Participant] | 1000     | SHORT |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
      | Instance ID | participant         | account            | level   | symbol       | notional |
      | POU1_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond01 | -1000.0  |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol       | price | quantity | participant         | notional | side |
      | POU2        | [Acc01.Account Id] | RZ_ST_Bond02 | 99.0  | 10       | [Acc01.Participant] | 1000     | LONG |

    Then "Position" messages are filtered by "level,participant,account,symbol" should be
      | Instance ID | participant         | account            | level   | symbol       | notional |
      | POU2_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond02 | 1000.0   |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result1     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Scenario11 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario11) |

    #Verify the Stress Testing for Each Positions
    And "Stress Test Detailed Result" messages are filtered by "runId,accountId,scenarioId,symbol" should be
      | Instance ID | runId     | accountId          | symbol       | scenarioId       | currentValue                                                          | stressValue                                                                             |
      | Result2     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Bond01 | RZ_ST_Scenario11 | current_value(RZ_ST_Firm01,[Acc01.Account Id],[POU1_Res1.positionId]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario11,[POU1_Res1.positionId]) |
      | Result3     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Bond02 | RZ_ST_Scenario11 | current_value(RZ_ST_Firm01,[Acc01.Account Id],[POU2_Res1.positionId]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario11,[POU2_Res1.positionId]) |

  @wip1
  Scenario: TC_009 - Stress Test for a Symbols with different Expiry Date Par Value and Coupon

    Given instance "RZ-Base-Acc-02" of entity "Accounts" is copied with following values
      | Instance ID | Participant  | Account Id          | Name            | Risk Model    |
      | Acc01       | RZ_ST_Firm01 | random(RZ_ST_ACC,5) | random(RZ_ST,5) | RZ_ST_Model11 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol       | price | quantity | participant         | notional | side |
      | POU1        | [Acc01.Account Id] | RZ_ST_Bond01 | 99.0  | 10       | [Acc01.Participant] | 1000.0   | LONG |

    Then "Position" messages are filtered by "level,participant,account,symbol" should be
      | Instance ID | participant         | account            | level   | symbol       | notional |
      | POU1_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond01 | 1000.0   |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol       | price | quantity | participant         | notional | side |
      | POU2        | [Acc01.Account Id] | RZ_ST_Bond03 | 499.0 | 2        | [Acc01.Participant] | 1000     | LONG |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
      | Instance ID | participant         | account            | level   | symbol       | notional |
      | POU2_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond03 | 1000.0   |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result1     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Scenario11 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario11) |

    #Verify the Stress Testing for Each Positions
    And "Stress Test Detailed Result" messages are filtered by "runId,accountId,scenarioId,symbol" should be
      | Instance ID | runId     | accountId          | symbol       | scenarioId       | currentValue                                                          | stressValue                                                                             |
      | Result2     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Bond01 | RZ_ST_Scenario11 | current_value(RZ_ST_Firm01,[Acc01.Account Id],[POU1_Res1.positionId]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario11,[POU1_Res1.positionId]) |
      | Result3     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Bond03 | RZ_ST_Scenario11 | current_value(RZ_ST_Firm01,[Acc01.Account Id],[POU2_Res1.positionId]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario11,[POU2_Res1.positionId]) |

  @done
  Scenario: TC_010 - Stress Test for Symbols with different Coupon Frequencies and Day count Conversions

    Given instance "RZ-Base-Acc-02" of entity "Accounts" is copied with following values
      | Instance ID | Participant  | Account Id          | Name            | Risk Model    |
      | Acc01       | RZ_ST_Firm01 | random(RZ_ST_ACC,5) | random(RZ_ST,5) | RZ_ST_Model11 |

    Then instance "[Acc01.Account Id]" of entity "Accounts" should be
      | Instance ID | Name         |
      | Acc01_Res1  | [Acc01.Name] |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol       | price | quantity | participant         | notional | side  |
      | POU1        | [Acc01.Account Id] | RZ_ST_Bond04 | 99.0  | 10       | [Acc01.Participant] | 1000     | SHORT |
      | POU2        | [Acc01.Account Id] | RZ_ST_Bond05 | 200.0 | 2        | [Acc01.Participant] | 400      | SHORT |
      | POU3        | [Acc01.Account Id] | RZ_ST_Bond06 | 100.0 | 10       | [Acc01.Participant] | 1000     | SHORT |

    Then "Position" messages are filtered by "level,participant,account,symbol" should be
      | Instance ID | participant         | account            | level   | symbol       | notional |
      | POU1_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond04 | -1000.0  |
      | POU2_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond05 | -400.0   |
      | POU3_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond06 | -1000.0  |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result1     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Scenario11 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario11) |

    #Verify the Stress Testing for Each Positions
    And "Stress Test Detailed Result" messages are filtered by "runId,accountId,scenarioId,symbol" should be
      | Instance ID | runId     | accountId          | symbol       | scenarioId       | currentValue                                                                       | stressValue                                                                                          |
      | Result2     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Bond04 | RZ_ST_Scenario11 | current_value(RZ_ST_Firm01,[Acc01.Account Id],[POU1_Res1.positionId])              | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario11,[POU1_Res1.positionId]) |
      | Result3     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Bond05 | RZ_ST_Scenario11 | current_value(RZ_ST_Firm01,[Acc01.Account Id],[POU2_Res1.positionId])              | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario11,[POU2_Res1.positionId])              |
      | Result4     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Bond06 | RZ_ST_Scenario11 | current_value(RZ_ST_Firm01,[Acc01.Account Id],[POU3_Res1.positionId])              | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario11,[POU3_Res1.positionId])              |

    # Change the Business Day Convention in each Symbol ( To have all the Business day Convention Values)
    When instance "RZ_ST_Bond02" of entity "Instruments" is updated with following values
      | Instance ID | Business Day Convention |
      | Updt_01     | MODIFIED_PRECEDING      |

    When instance "RZ_ST_Bond03" of entity "Instruments" is updated with following values
      | Instance ID | Business Day Convention |
      | Updt_02     | DAY_FOLLOWING           |

    When instance "RZ_ST_Bond04" of entity "Instruments" is updated with following values
      | Instance ID | Business Day Convention |
      | Updt_03     | DAY_PRECEDING           |

    When instance "RZ_ST_Bond05" of entity "Instruments" is updated with following values
      | Instance ID | Business Day Convention |
      | Updt_04     | UNADJUSTED              |

    When instance "RZ_ST_Bond06" of entity "Instruments" is updated with following values
      | Instance ID | Business Day Convention |
      | Updt_05     | MODIFIED_FOLLOWING      |

    #Add New Positions
    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol       | price | quantity | participant         | notional | side  |
      | POU4        | [Acc01.Account Id] | RZ_ST_Bond02 | 99.0  | 10       | [Acc01.Participant] | 1000     | SHORT |
      | POU5        | [Acc01.Account Id] | RZ_ST_Bond03 | 99.0  | 10       | [Acc01.Participant] | 1000     | SHORT |
      | POU6        | [Acc01.Account Id] | RZ_ST_Bond04 | 99.0  | 10       | [Acc01.Participant] | 1000     | LONG  |
      | POU7        | [Acc01.Account Id] | RZ_ST_Bond05 | 200.0 | 2        | [Acc01.Participant] | 400      | LONG  |
      | POU8        | [Acc01.Account Id] | RZ_ST_Bond06 | 100.0 | 10       | [Acc01.Participant] | 1000     | LONG  |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
      | Instance ID | participant         | account            | level   | symbol       | notional |
      | POU4_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond02 | -1000.0  |
      | POU5_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond03 | -1000.0  |
      | POU6_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond04 | 0.0      |
      | POU7_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond05 | 0.0      |
      | POU8_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond06 | 0.0      |

    # Run another Stress Test after the Instrument modifications
    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT02       | [Acc01.Account Id] |

    Then response of the request "STT02" should be
      | Instance ID |
      | Run2        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result1     | [Run2.id] | [Acc01.Account Id] | RZ_ST_Scenario11 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario11) |

    #Verify the Stress Testing for Each Positions
    And "Stress Test Detailed Result" messages are filtered by "runId,accountId,scenarioId,symbol" should be
      | Instance ID | runId     | accountId          | symbol       | scenarioId       | currentValue                                                          | stressValue                                                                             |
      | Result2     | [Run2.id] | [Acc01.Account Id] | RZ_ST_Bond04 | RZ_ST_Scenario11 | current_value(RZ_ST_Firm01,[Acc01.Account Id],[POU1_Res1.positionId]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario11,[POU1_Res1.positionId]) |
      | Result3     | [Run2.id] | [Acc01.Account Id] | RZ_ST_Bond05 | RZ_ST_Scenario11 | current_value(RZ_ST_Firm01,[Acc01.Account Id],[POU2_Res1.positionId]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario11,[POU2_Res1.positionId]) |
      | Result4     | [Run2.id] | [Acc01.Account Id] | RZ_ST_Bond06 | RZ_ST_Scenario11 | current_value(RZ_ST_Firm01,[Acc01.Account Id],[POU3_Res1.positionId]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario11,[POU3_Res1.positionId]) |

  @done
  Scenario: TC_011 - Change the attached Discount curve Intraday

    Given instance "RZ-Base-Acc-02" of entity "Accounts" is copied with following values
      | Instance ID | Participant  | Account Id          | Name            | Risk Model    |
      | Acc01       | RZ_ST_Firm01 | random(RZ_ST_ACC,5) | random(RZ_ST,5) | RZ_ST_Model04 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol       | price | quantity | participant         | notional |
      | POU1        | [Acc01.Account Id] | RZ_ST_Bond06 | 100.0 | 100      | [Acc01.Participant] | 10000    |

    Then "Position" messages are filtered by "level,participant,account,symbol" should be
      | Instance ID | participant         | account            | level   | symbol       | notional |
      | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond06 | 10000.0  |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result1     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Scenario03 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario03) |

    #Update the Discount Curve of the Instrument( Initially it had RZ_ST_Cur04 and now changing into RZ_ST_Cur01)
    When instance "RZ_ST_Bond06" of entity "Instruments" is updated with following values
      | Instance ID | Discount Curve |
      | Updt_01     | RZ_ST_Cur01    |

    #Run another Stress Test
    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT02       | [Acc01.Account Id] |

    Then response of the request "STT02" should be
      | Instance ID |
      | Run2        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result2     | [Run2.id] | [Acc01.Account Id] | RZ_ST_Scenario03 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario03) |

  @wips
  Scenario: TC_012 - Remove the attached Discount curve Intraday

    Given instance "RZ-Base-Acc-02" of entity "Accounts" is copied with following values
      | Instance ID | Participant  | Account Id          | Name            | Risk Model    |
      | Acc01       | RZ_ST_Firm01 | random(RZ_ST_ACC,5) | random(RZ_ST,5) | RZ_ST_Model04 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol       | price | quantity | participant         | notional |
      | POU1        | [Acc01.Account Id] | RZ_ST_Bond06 | 100.0 | 100      | [Acc01.Participant] | 10000    |

    Then "Position" messages are filtered by "level,participant,account,symbol" should be
      | Instance ID | participant         | account            | level   | symbol       | notional |
      | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond06 | 10000.0  |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol       | price | quantity | participant         | notional |
      | POU2        | [Acc01.Account Id] | RZ_ST_Bond06 | 100.0 | 10       | [Acc01.Participant] | 1000     |

    Then "Position" messages are filtered by "level,participant,account,symbol" should be
      | Instance ID | participant         | account            | level   | symbol       | notional |
      | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond06 | 11000.0  |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result1     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Scenario03 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario03) |

    #Remove the Discount Curve of the Instrument( Initially it had RZ_ST_Cur04 and now changing into Null)
    When instance "RZ_ST_Bond06" of entity "Instruments" is updated with following values
      | Instance ID | Discount Curve |
      | Updt_01     |                |

    #Run another Stress Test
    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT02       | [Acc01.Account Id] |

    Then response of the request "STT02" should be
      | Instance ID |
      | Run2        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result2     | [Run2.id] | [Acc01.Account Id] | RZ_ST_Scenario03 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario03) |

  @SteppedBond
  Scenario: TC_013 - Stress Test for Stepped Coupon Bonds

    Given instance "RZ-Base-Acc-02" of entity "Accounts" is copied with following values
      | Instance ID | Participant  | Account Id          | Name            | Risk Model    |
      | Acc01       | RZ_ST_Firm01 | random(RZ_ST_ACC,5) | random(RZ_ST,5) | RZ_ST_Model07 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol                 | price | quantity | participant         | notional | side  |
      | POU1        | [Acc01.Account Id] | RZ-Base-Ins-Stepped-01 | 450.0 | 10       | [Acc01.Participant] | 4500     | SHORT |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
      | Instance ID | participant         | account            | level   | symbol        | notional |
      | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | [POU1.symbol] | -4500.0  |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result1     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Scenario01 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario01) |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result2     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Scenario02 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario02) |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result3     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Scenario03 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario03) |

    # Do another Position update and run the second stress Test
    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol        | price | quantity | participant         | notional | side |
      | POU2        | [Acc01.Account Id] | [POU1.symbol] | 450.0 | 10       | [Acc01.Participant] | 4500     | LONG |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
      | Instance ID | participant         | account            | level   | symbol        | notional |
      | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | [POU2.symbol] | 0.0      |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT02       | [Acc01.Account Id] |

    Then response of the request "STT02" should be
      | Instance ID |
      | Run2        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result4     | [Run2.id] | [Acc01.Account Id] | RZ_ST_Scenario01 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario01) |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result5     | [Run2.id] | [Acc01.Account Id] | RZ_ST_Scenario02 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario02) |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result6     | [Run2.id] | [Acc01.Account Id] | RZ_ST_Scenario03 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario03) |

  @ZeroCouponBond
  Scenario: TC_014 - Stress Test for Zero Coupon Bonds

    Given instance "RZ-Base-Acc-02" of entity "Accounts" is copied with following values
      | Instance ID | Participant  | Account Id          | Name            | Risk Model    |
      | Acc01       | RZ_ST_Firm01 | random(RZ_ST_ACC,5) | random(RZ_ST,5) | RZ_ST_Model07 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol                    | price | quantity | participant         | notional | side  |
      | POU1        | [Acc01.Account Id] | RZ-Base-Ins-ZeroCoupon-01 | 450.0 | 10       | [Acc01.Participant] | 4500     | SHORT |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
      | Instance ID | participant         | account            | level   | symbol        | notional |
      | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | [POU1.symbol] | -4500.0  |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result1     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Scenario01 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario01) |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result2     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Scenario02 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario02) |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result3     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Scenario03 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario03) |

    # Do another Position update and run the second stress Test
    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol        | price | quantity | participant         | notional | side |
      | POU2        | [Acc01.Account Id] | [POU1.symbol] | 450.0 | 10       | [Acc01.Participant] | 4500     | LONG |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
      | Instance ID | participant         | account            | level   | symbol        | notional |
      | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | [POU2.symbol] | 0.0      |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT02       | [Acc01.Account Id] |

    Then response of the request "STT02" should be
      | Instance ID |
      | Run2        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result4     | [Run2.id] | [Acc01.Account Id] | RZ_ST_Scenario01 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario01) |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result5     | [Run2.id] | [Acc01.Account Id] | RZ_ST_Scenario02 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario02) |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result6     | [Run2.id] | [Acc01.Account Id] | RZ_ST_Scenario03 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario03) |

  @done
    # Creating This Sinkable Bond should be added into reference Data. Stress Test step is getting failed.SSinking Bonds- Stress Test Failed sent mail to Ravin "Sinking Bonds- Stress Test Failed"
  Scenario: TC_015 - Change the attached Discount curve Intraday for Fixed Rate Sinking Bond

    Given instance "RZ-Base-Acc-02" of entity "Accounts" is copied with following values
      | Instance ID | Participant  | Account Id          | Name            | Risk Model    |
      | Acc01       | RZ_ST_Firm01 | random(RZ_ST_ACC,5) | random(RZ_ST,5) | RZ_ST_Model04 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol                    | price | quantity | participant         | notional |side |
      | POU1        | [Acc01.Account Id] | RZ-Base-Ins-Fixed-Sink-01 | 100.0 | 100      | [Acc01.Participant] | 10000    |LONG |

    Then "Position" messages are filtered by "level,participant,account,symbol" should be
      | Instance ID | participant         | account            | level   | symbol                    | notional |
      | POU1_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ-Base-Ins-Fixed-Sink-01 | 10000.0  |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result1     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Scenario03 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario03) |

    #Update the Discount Curve of the Instrument( Initially it had RZ_ST_Cur04 and now changing into RZ_ST_Cur01)
    When instance "RZ-Base-Ins-Fixed-Sink-01" of entity "Instruments" is updated with following values
      | Instance ID | Discount Curve |
      | Updt_01     | RZ_ST_Cur01    |

    #Run another Stress Test
    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT02       | [Acc01.Account Id] |

    Then response of the request "STT02" should be
      | Instance ID |
      | Run2        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result2     | [Run2.id] | [Acc01.Account Id] | RZ_ST_Scenario03 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario03) |


      @d
  Scenario: TC_016 - Fixed Rate sinking Bond

    Given instance "RZ-Base-Acc-02" of entity "Accounts" is copied with following values
      | Instance ID | Participant  | Account Id          | Name            | Risk Model    |
      | Acc01       | RZ_ST_Firm01 | random(RZ_ST_ACC,5) | random(RZ_ST,5) | RZ_ST_Model04 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol            |  quantity | participant         | notional |
      | POU1        | [Acc01.Account Id] | RZ_ST_Sync_Bond01 |  100      | [Acc01.Participant] | 10000    |

    Then "Position" messages are filtered by "level,participant,account,symbol" should be
      | Instance ID | participant         | account            | level   | symbol       | notional |
      | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | [POU1.symbol] | 10000.0  |

    When "Stress Test" messages are submitted with following values
      | Instance ID | account            |
      | STT01       | [Acc01.Account Id] |

    Then response of the request "STT01" should be
      | Instance ID |
      | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
      | Instance ID | runId     | accountId          | scenarioId       | currentValue                                   | stressedValue                                                    |
      | Result1     | [Run1.id] | [Acc01.Account Id] | RZ_ST_Scenario03 | current_value(RZ_ST_Firm01,[Acc01.Account Id]) | stressed_value(RZ_ST_Firm01,[Acc01.Account Id],RZ_ST_Scenario03) |





















































  @fff
  Scenario: ref data f

    Given instance "RZ-Base-Acc-02" of entity "Accounts" is copied with following values
      | Instance ID | Participant  | Account Id          | Name            | Risk Model    |
      | Acc01       | RZ_ST_Firm01 | random(RZ_ST_ACC,5) | random(RZ_ST,5) | RZ_ST_Model11 |

    When "Position Update" messages are submitted with following values
      | Instance ID | account            | symbol       | price | quantity | participant         | notional | side  |
      | POU1        | [Acc01.Account Id] | RZ_ST_Bond01 | 99.0  | 10       | [Acc01.Participant] | 1000     | SHORT |
      | POU2        | [Acc01.Account Id] | RZ_ST_Bond03 | 499.0 | 2        | [Acc01.Participant] | 1000     | LONG  |

    Then "Position" messages are filtered by "level,participant,account,symbol" should be
      | Instance ID | participant         | account            | level   | symbol       | notional |
      | POU1_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond01 | -1000.0  |
      | POU2_Res1   | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT | RZ_ST_Bond03 | 1000.0   |

  @sampleforupdates
  Scenario: Update Stress Scenario intraday

      # Create Stress Scenario
    Given table "tab1" is created with following values
      | Instance ID | Risk Factor Type | Symbol       | Shift Type | Shift Percentage |
      | te1         | INTEREST_RATE    | RZ_ST_Rate2Y | RELATIVE   | 0.5              |

    And instance of entity "Stress Scenarios" is created with following values
      | Instance ID | Stress Scenario Id        | Stress Scenario Name      | Shift      |
      | SS1         | random(RZ_ST_Scenario_,4) | random(RZ_ST_Scenario_,4) | [TAB:tab1] |

    And instance "RZ-Base-RModel-01" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id          | Stress Testing  Methodology |
      | RM01        | random(RZ_ST_Model_,4) | [SS1.Stress Scenario Id]    |

    Given table "tab2" is created with following values
      | Instance ID | Risk Factor Type | Symbol       | Shift Type | Shift Percentage |
      | te2         | INTEREST_RATE    | RZ_ST_Rate2Y | RELATIVE   | 0.5              |
      | te3         | INTEREST_RATE    | RZ_ST_Rate5Y | RELATIVE   | 1.5              |

    Given instance "[SS1.Stress Scenario Id]" of entity "Stress Scenarios" is updated with adding following Shifts
      | Instance ID | Shift      |
      | SS1         | [TAB:tab2] |

#    Then "Position" messages are filtered by "level,participant,account" should be
#      | Instance ID | participant | level   | account                                                                    |
#      | POS_Res1    | RZ_ST_Firm01    | ACCOUNT | current_value(RZ_ST_Firm01,RZ_ST_ACC71934)                                     |
#      | POS_Res2    | RZ_ST_Firm01    | ACCOUNT | stressed_value(RZ_ST_Firm01,RZ_ST_ACC71934,RZ_ST_Scenario02)                   |
#      | POS_Res3    | RZ_ST_Firm01    | ACCOUNT | current_value(RZ_ST_Firm01,RZ_ST_ACC71934,[POS1.positionId])                   |
#      | POS_Res4    | RZ_ST_Firm01    | ACCOUNT | stressed_value(RZ_ST_Firm01,RZ_ST_ACC71934,RZ_ST_Scenario02,[POS1.positionId]) |
#    # participant | account > Current value of the Account
#
  @instrumentcreation
  Scenario: Instrument Creation

    Given instance of entity "Instruments" is created with following values

      | Instance ID | Symbol                   | Asset Class | Instrument Type     | Expiry Date              | First Coupon Date       | Next To Last Date        | Display ID | Size Multiplier | Price Multiplier | Currency | Price And Quantity Type | Par Value | Coupon | Coupon Frequency | Issue Date              | Business Day Convention | Day Count Convention       | Compounding Type | Discount Curve | Status |
      | Inst 01     | random(RZ_ST_Stepped_,4) | RATES       | STEPPED_COUPON_BOND | date(today+20Y,%Y-%m-%d) | date(today+2m,%Y-%m-%d) | date(today+19Y,%Y-%m-%d) | SYMBOL     | 1               | 1                | USD      | PER_UNIT                | 500       | 2      | SEMI_ANNUAL      | date(today+1d,%Y-%m-%d) | UNADJUSTED              | ACTUAL_DIVIDED_ACTUAL_ISDA | COMPOUNDED       | RZ_ST_Cur04    | ACTIVE |
    # Stepped Bond Coupon Date | Stepped Bond Coupon Rate |
    # date(today+2Y,%Y-%m-%d), date(today+5Y,%Y-%m-%d)       | 2,3                      |

    Then instance "[Inst 01.Symbol]" of entity "Instruments" should be
      | Instance ID | Symbol           | Expiry Date            |
      | Curr03      | [Inst 01.Symbol] | [Inst 01.Expiry Date ] |
