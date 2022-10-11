Feature: Stress testing


  Scenario: Stress testing data setup

    Given instance "RZ-Base-Ins-Curv-01" of entity "Instruments" is copied with following values
    | Instance ID | Symbol      | ISIN        | Instrument Type |
    | Curve1      | RZ_ST_Cur01 | RZ_ST_Cur01 | CURVES          |

    And instance "RZ-Base-Ins-Spot-01" of entity "Instruments" is copied with following values
    | Instance ID | Symbol        | ISIN          | Instrument Type | Tenor    | Curve Identifier |
    | Rate1M      | RZ_ST_Rate1M  | RZ_ST_Rate1M  | SPOT_RATE       | 1M       | [Curve1.Symbol]  |
    | Rate3M      | RZ_ST_Rate3M  | RZ_ST_Rate3M  | SPOT_RATE       | 3M       | [Curve1.Symbol]  |
    | Rate6M      | RZ_ST_Rate6M  | RZ_ST_Rate6M  | SPOT_RATE       | 6M       | [Curve1.Symbol]  |
    | Rate1Y      | RZ_ST_Rate1Y  | RZ_ST_Rate1Y  | SPOT_RATE       | 1Y       | [Curve1.Symbol]  |
    | Rate2Y      | RZ_ST_Rate2Y  | RZ_ST_Rate2Y  | SPOT_RATE       | 2Y       | [Curve1.Symbol]  |
    | Rate3Y      | RZ_ST_Rate3Y  | RZ_ST_Rate3Y  | SPOT_RATE       | 3Y       | [Curve1.Symbol]  |
    | Rate5Y      | RZ_ST_Rate5Y  | RZ_ST_Rate5Y  | SPOT_RATE       | 5Y       | [Curve1.Symbol]  |
    | Rate7Y      | RZ_ST_Rate7Y  | RZ_ST_Rate7Y  | SPOT_RATE       | 7Y       | [Curve1.Symbol]  |
    | Rate10Y     | RZ_ST_Rate10Y | RZ_ST_Rate10Y | SPOT_RATE       | 10Y      | [Curve1.Symbol]  |
    | Rate20Y     | RZ_ST_Rate20Y | RZ_ST_Rate20Y | SPOT_RATE       | 20Y      | [Curve1.Symbol]  |
    | Rate30Y     | RZ_ST_Rate30Y | RZ_ST_Rate30Y | SPOT_RATE       | 30Y      | [Curve1.Symbol]  |

    Given "Realtime Risk Factor Update" messages are submitted with following values
    | Instance ID  | symbol        | dataClass |  type   | value   |
    | MRate1M      | RZ_ST_Rate1M  | RATE      |  LTP    | 0.83    |
    | MRate3M      | RZ_ST_Rate3M  | RATE      |  LTP    | 1.06    |
    | MRate6M      | RZ_ST_Rate6M  | RATE      |  LTP    | 1.58	   |
    | MRate1Y      | RZ_ST_Rate1Y  | RATE      |  LTP    | 2.09    |
    | MRate2Y      | RZ_ST_Rate2Y  | RATE      |  LTP    | 2.55    |
    | MRate3Y      | RZ_ST_Rate3Y  | RATE      |  LTP    | 2.88    |
    | MRate5Y      | RZ_ST_Rate5Y  | RATE      |  LTP    | 2.90    |
    | MRate7Y      | RZ_ST_Rate7Y  | RATE      |  LTP    | 2.95    |
    | MRate10Y     | RZ_ST_Rate10Y | RATE      |  LTP    | 3.05    |
    | MRate20Y     | RZ_ST_Rate20Y | RATE      |  LTP    | 3.25    |
    | MRate30Y     | RZ_ST_Rate30Y | RATE      |  LTP    | 3.35    |

    Given instance "RZ-Base-Ins-Fixed-01" of entity "Instruments" is copied with following values
    | Instance ID | Symbol       | ISIN         | Instrument Type | Discount Curve   |
    | Bond1       | RZ_ST_Bond01 | RZ_ST_Bond01 | Fixed Rate Bond | [Curve1.Symbol]  |

    Given instance "RZ-Base-Firm-1" of entity "Participants" is copied with following values
    | Instance ID| Participant Id   |
    | Part01     | RZ_ST_Firm01     |

    Given table "tab1" is created with following values
    | Instance ID | Risk Factor Type    | Symbol        | Shift Type | Shift Percentage |
    | te1         | INTEREST_RATE       | RZ_ST_Rate30Y | ABSOLUTE   | 1                |
    | te2         | INTEREST_RATE       | RZ_ST_Rate10Y | ABSOLUTE   | 1.5              |

    Given instance of entity "Stress Scenarios" is created with following values
    | Instance ID | Stress Scenario Id | Stress Scenario Name | Shift      |
    | SS1         | RZ_ST_Scenario01   | RZ_ST_Scenario01     | [TAB:tab1] |

    Given table "tab2" is created with following values
    | Instance ID | Risk Factor Type    | Symbol        | Shift Type | Shift Percentage |
    | te3         | INTEREST_RATE       | RZ_ST_Rate2Y  | ABSOLUTE   | 0.5              |
    | te4         | INTEREST_RATE       | RZ_ST_Rate5Y  | ABSOLUTE   | 1.1              |

    Given instance of entity "Stress Scenarios" is created with following values
    | Instance ID | Stress Scenario Id | Stress Scenario Name | Shift      |
    | SS2         | RZ_ST_Scenario02   | RZ_ST_Scenario02     | [TAB:tab2] |

    Given instance "RZ-Base-RModel-01" of entity "Risk Models" is copied with following values
    | Instance ID | Risk Model Id  | Stress Testing  Methodology |
    | RM01        | RZ_ST_Model01  | RZ_ST_Scenario01            |

    Given instance "RZ-Base-RModel-01" of entity "Risk Models" is copied with following values
    | Instance ID | Risk Model Id  | Stress Testing  Methodology       |
    | RM02        | RZ_ST_Model02  | RZ_ST_Scenario01,RZ_ST_Scenario02 |

    Given instance "RZ-Base-RModel-01" of entity "Risk Models" is copied with following values
    | Instance ID | Risk Model Id  | Stress Testing  Methodology    |
    | RM03        | RZ_ST_Model03  | RZ_ST_Scenario02               |


  Scenario: Stress testing - account related

    Given instance "RZ-Base-Acc-02" of entity "Accounts" is copied with following values
    | Instance ID | Participant   | Account Id          | Name            | Risk Model      |
    | Acc01       | RZ_ST_01      | random(RZ_ST_ACC,5) | random(RZ_ST,5) | RZ_ST_Model01   |

    When "Position Update" messages are submitted with following values
    | Instance ID | account            | symbol       | price | participant         | notional |
    | POU1        | [Acc01.Account Id] | RZ_ST_Bond01 | 99.0  | [Acc01.Participant] | 200      |

    Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
    | Instance ID | participant         | account            | level     | symbol       | notional |
    | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT   | RZ_ST_Bond01 | 200.0    |

    When "Stress Test" messages are submitted with following values
    | Instance ID | account             |
    | STT01       | [Acc01.Account Id]  |

    Then response of the request "STT01" should be
    | Instance ID |
    | Run1        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
    | Instance ID | runId      | accountId          | scenarioId       | currentValue | stressedValue | stressedPnL |
    | Result1     | [Run1.id]  | [Acc01.Account Id] | RZ_ST_Scenario01 | 91.52        | 91.23         | -0.29       |


    # stress result impact upon a account's risk model change
    Given instance "[Acc01.Account Id]" of entity "Accounts" is updated with following values
    | Instance ID  | Risk Model      |
    | Acc02        | RZ_ST_Model03   |

    When "Stress Test" messages are submitted with following values
    | Instance ID | account             |
    | STT02       | [Acc01.Account Id]  |

    Then response of the request "STT02" should be
    | Instance ID |
    | Run2        |

    And "Stress Test Result" messages are filtered by "runId,accountId,scenarioId" should be
    | Instance ID | runId      | accountId          | scenarioId       | currentValue | stressedValue | stressedPnL |
    | Result2     | [Run2.id]  | [Acc01.Account Id] | RZ_ST_Scenario02 | 91.52        | 89.02         | -2.5       |





  Scenario: Interest curve testing

    When "Realtime Risk Factor Update" messages are submitted with following values
    | Instance ID  | symbol        | dataClass |  type   | value   |
    | MRate10Y     | RZ_ST_Rate10Y | RATE      |  LTP    | 3.07    |
    | MRate20Y     | RZ_ST_Rate20Y | RATE      |  LTP    | 3.27    |

    Then "Realtime Interest Curve Value" messages are filtered by "curveIdentifier,tenor,ltp" should be
    | Instance ID | curveIdentifier | tenor | ltp  |
    | IC03        | RZ_ST_Cur01     | 10Y   | 3.07 |
    | IC04        | RZ_ST_Cur01     | 20Y   | 3.27 |

    When "Realtime Risk Factor Update" messages are submitted with following values
    | Instance ID  | symbol        | dataClass |  type   | value   |
    | MRate10Y     | RZ_ST_Rate10Y | RATE      |  LTP    | 3.05    |
    | MRate20Y     | RZ_ST_Rate20Y | RATE      |  LTP    | 3.25    |

    Then "Realtime Interest Curve Value" messages are filtered by "curveIdentifier,tenor,ltp" should be
    | Instance ID | curveIdentifier | tenor | ltp  |
    | IC03        | RZ_ST_Cur01     | 10Y   | 3.05 |
    | IC04        | RZ_ST_Cur01     | 20Y   | 3.25 |

    @wip
  Scenario: Interest curve testing temp

    Given instance "RZ-Base-Ins-Spot-01" of entity "Instruments" is copied with following values
    | Instance ID | Symbol        | ISIN          | Instrument Type | Tenor    | Curve Identifier |
    | Rate2M      | RZ_ST_Rate2M  | RZ_ST_Rate2M  | SPOT_RATE       | 2M       | RZ_ST_Cur01      |
    | Rate100Y    | RZ_ST_Rate100Y| RZ_ST_Rate100Y| SPOT_RATE       | 100Y     | RZ_ST_Cur01      |

    When "Realtime Risk Factor Update" messages are submitted with following values
    | Instance ID  | symbol         | dataClass |  type   | value   |
    | MRate10Y     | RZ_ST_Rate2M   | RATE      |  LTP    | 0.83    |
    | MRate100Y    | RZ_ST_Rate100Y | RATE      |  LTP    | 3.40    |








