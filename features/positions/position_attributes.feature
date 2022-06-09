Feature: Position Attributes

  @done
  Scenario: TC_001 Validating Position Key  and position id exists

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_IT_01      |

    When "Position Update" messages are submitted with following values
      | Instance ID  | symbol              | quantity | price | side  | participant          | type   | account             | notional | Position Key Id |
      | PosUpdate_01 | RZ_PT_Inst_Bond_001 | 1000     | 50.0  | SHORT | [Acc_01.Participant] | MARGIN | [Acc_01.Account Id] | 50000    | 1               |

    Then "Position" messages are filtered by "level,account,participant" should be
      | Instance ID       | symbol                | level   | account                | participant                | type   | shortPosition | netPosition | positionKey | positionId |
      | PosUpdate_01_Res1 | [PosUpdate_01.symbol] | ACCOUNT | [PosUpdate_01.account] | [PosUpdate_01.participant] | MARGIN | 1000.0        | -1000.0     | NOT_EMPTY   | NOT_EMPTY  |

    Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted

  @fail
  #Assertion Failed: Cannot find a field with name [couponSchedule] in the entity [Instruments]
  Scenario: TC_002 Validating Symbol for Floating Rate Bond

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_IT_01      |

    And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Instrument Type    | Symbol                    |
      | Inst_01     | FLOATING_RATE_BOND | random(RZ_PT_Inst_Bond,2) |

    When "Position Update" messages are submitted with following values
      | Instance ID  | symbol           | quantity | price | side  | participant          | type   | account             | notional |
      | PosUpdate_01 | [Inst_01.Symbol] | 1000     | 50.0  | SHORT | [Acc_01.Participant] | MARGIN | [Acc_01.Account Id] | 50000    |

    Then "Position" messages are filtered by "level,account,participant" should be
      | Instance ID       | symbol                | level   | account                | participant                | type   | shortPosition | netPosition | positionKey |
      | PosUpdate_01_Res1 | [PosUpdate_01.symbol] | ACCOUNT | [PosUpdate_01.account] | [PosUpdate_01.participant] | MARGIN | 1000.0        | -1000.0     | NOT_EMPTY   |

    Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted
    Given instance "[Inst_01.Symbol]" of entity "Instruments" is deleted

  @done
  Scenario: TC_003 Validating Currency ( Bonds with different currencies)

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_IT_01      |

    And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                    | Currency |
      | Inst_01     | random(RZ_PT_Inst_Bond,2) | GBP      |

    When "Position Update" messages are submitted with following values
      | Instance ID  | symbol           | quantity | price | side  | participant          | type   | account             | notional | market | currency |
      | PosUpdate_01 | [Inst_01.Symbol] | 1000     | 50.0  | SHORT | [Acc_01.Participant] | MARGIN | [Acc_01.Account Id] | 50000    | XNAS   | GBP      |

    Then "Position" messages are filtered by "level,account,participant,shortPosition" should be
      | Instance ID       | symbol                | level   | account                | participant                | type   | shortPosition | netPosition | currency                |
      | PosUpdate_01_Res2 | [PosUpdate_01.symbol] | ACCOUNT | [PosUpdate_01.account] | [PosUpdate_01.participant] | MARGIN | 1000.0        | -1000.0     | [PosUpdate_01.currency] |

    When "Position Update" messages are submitted with following values
      | Instance ID  | symbol           | quantity | price | side  | participant          | type   | account             | notional | currency |
      | PosUpdate_02 | [Inst_01.Symbol] | 1000     | 50.0  | SHORT | [Acc_01.Participant] | MARGIN | [Acc_01.Account Id] | 50000    | USD      |

    Then "Position" messages are filtered by "level,account,participant,currency" should be
      | Instance ID       | symbol                | level   | account                | participant                | type   | shortPosition | netPosition | currency                |
      | PosUpdate_02_Res1 | [PosUpdate_02.symbol] | ACCOUNT | [PosUpdate_02.account] | [PosUpdate_02.participant] | MARGIN | 1000.0        | -1000.0     | [PosUpdate_02.currency] |

    Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted
    Given instance "[Inst_01.Symbol]" of entity "Instruments" is deleted

  @done
  Scenario: TC_004 Validating Settlement Date

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_IT_01      |

    When "Position Update" messages are submitted with following values
      | Instance ID  | symbol              | quantity | price | side  | participant          | type   | account             | notional | settlementDate                |
      | PosUpdate_01 | RZ_PT_Inst_Bond_001 | 1000     | 50.0  | SHORT | [Acc_01.Participant] | MARGIN | [Acc_01.Account Id] | 50000    | 2022-06-20T00:00:00.000+00:00 |

    Then "Position" messages are filtered by "level,account,participant,symbol" should be
      | Instance ID       | symbol                | level   | account                | participant                | type   | shortPosition | netPosition | settlementDate                |
      | PosUpdate_01_Res1 | [PosUpdate_01.symbol] | ACCOUNT | [PosUpdate_01.account] | [PosUpdate_01.participant] | MARGIN | 1000.0        | -1000.0     | [PosUpdate_01.settlementDate] |

    Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted

  @done
  Scenario: TC_005 Validating Markets ( Position Updates added with different Markets)

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_IT_01      |

    When "Position Update" messages are submitted with following values
      | Instance ID  | symbol              | quantity | price | side  | participant          | type   | account             | notional | market |
      | PosUpdate_01 | RZ_PT_Inst_Bond_001 | 1000     | 50.0  | SHORT | [Acc_01.Participant] | MARGIN | [Acc_01.Account Id] | 50000    | XNAS   |

    Then "Position" messages are filtered by "level,account,participant,shortPosition,market" should be
      | Instance ID | symbol                | level   | account                | participant                | type   | shortPosition | market                |
      | Acc_01_Res1 | [PosUpdate_01.symbol] | ACCOUNT | [PosUpdate_01.account] | [PosUpdate_01.participant] | MARGIN | 1000.0        | [PosUpdate_01.market] |

    When "Position Update" messages are submitted with following values
      | Instance ID  | symbol              | quantity | price | side  | participant          | type   | account             | notional | market |
      | PosUpdate_02 | RZ_PT_Inst_Bond_002 | 1000     | 50.0  | SHORT | [Acc_01.Participant] | MARGIN | [Acc_01.Account Id] | 500000   | CME    |

    Then "Position" messages are filtered by "level,account,participant,shortPosition,market" should be
      | Instance ID       | symbol                | level   | account                | participant                | type   | shortPosition | market                |
      | PosUpdate_02_Res1 | [PosUpdate_02.symbol] | ACCOUNT | [PosUpdate_02.account] | [PosUpdate_02.participant] | MARGIN | 1000.0        | [PosUpdate_02.market] |

    Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted

  @done
  Scenario: TC_006 Validate Values in Long position ( longPosition,longValue, notional, average Price )

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_IT_01      |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol              | type | value |
      | MD1         | RZ_PT_Inst_Bond_001 | AI   | 2.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
      | Instance ID | symbol       | ai  |
      | MD1_Res1    | [MD1.symbol] | 2.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value   | side | participant          | notional |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 6000     | 5.0   | 30000.0 | LONG | [Acc_01.Participant] | 30000    |

    Then "Position" messages are filtered by "level,participant,account" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | account                | avgPrice | notional |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 6000.0       | 2100.0    | 6000.0      | 2100.0   | [PosUpdate_01.account] | 0.35     | 30000.0  |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value   | side | participant          | notional |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 4000     | 4.0   | 16000.0 | LONG | [Acc_01.Participant] | 16000    |

    Then "Position" messages are filtered by "level,participant,account,longPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | account                | avgPrice | notional |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 10000.0      | 3060.0    | 10000.0     | 3060.0   | [PosUpdate_02.account] | 0.306    | 46000.0  |

    Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted

  @done
  Scenario: TC_007 Validate values in Short Position (shortPosition, shortValue, Average price, notional )

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_IT_01      |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol              | type | value | currency |
      | MD1         | RZ_PT_Inst_Bond_001 | AI   | 2.0   | USD      |
      | MD2         | RZ_PT_Inst_Bond_001 | LTP  | 45.0  | USD      |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
      | Instance ID | symbol       | ai  |
      | MD1_Res1    | [MD1.symbol] | 2.0 |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD1_Res2    | [MD2.symbol] | 45.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value   | side  | participant          | notional |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 600      | 50.0  | 30000.0 | SHORT | [Acc_01.Participant] | 30000    |

    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 600.0         | 15600.0    | -600.0      | -15600.0 | 26.0     | [PosUpdate_01.account] | -30000.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value   | side  | participant          | notional |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 1000     | 51.0  | 51000.0 | SHORT | [Acc_01.Participant] | 51000    |

    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 1600.0        | 42630.0    | -1600.0     | -42630.0 | 26.64375 | [PosUpdate_02.account] | -81000.0 |

    Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted

  @fail
     #Assertion Failed: Cannot find a field with name [couponSchedule] in the entity [Instruments]
  Scenario: TC_008 Validate MTM Value when LTP is empty and updated before the next position update

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_IT_01      |

    And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol              |
      | Inst_01     | (RZ_PT_Inst_Bond,2) |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD1         | [Inst_01.Symbol] | AI   | 15.0  |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
      | Instance ID | symbol           | ai   |
      | MD1_Res1    | [Inst_01.symbol] | 15.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol           | quantity | price | value   | side  | participant          | notional |
      | PosUpdate_01 | [Acc_01.Account Id] | [Inst_01.Symbol] | 1000     | 60.0  | 60000.0 | SHORT | [Acc_01.Participant] | 100000   |

    Then "Position" messages are filtered by "level,participant,account,mtmValue" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | notional |
      | PosUpdate_01_Res2 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 1000.0        | 75000.0    | -1000.0     | -75000.0 | 75.0     | [PosUpdate_01.account] | -15000.0 | 100000.0 |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD2         | [Inst_01.Symbol] | LTP  | 75.0  |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol           | ltp  |
      | MD2_res1    | [Inst_01.Symbol] | 75.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol           | quantity | price | value   | side  | participant          | notional |
      | PosUpdate_02 | [Acc_01.Account Id] | [Inst_01.Symbol] | 1000     | 60.0  | 60000.0 | SHORT | [Acc_01.Participant] | 100000   |

    Then "Position" messages are filtered by "level,participant,account,shortPosition,mtmValue" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue  | avgPrice | account                | mtmValue  | notional |
      | PosUpdate_02_Res2 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 2000.0        | 150000.0   | -2000.0     | -150000.0 | 75.0     | [PosUpdate_02.account] | -180000.0 | 100000.0 |

    Given instance "[Acc_01.Account Id] " of entity "Accounts" is deleted
    Given instance "[Inst_01.Symbol]" of entity "Instruments" is deleted

  @fail
     #Assertion Failed: Cannot find a field with name [couponSchedule] in the entity [Instruments]
  Scenario: TC_009 Validate MTM Value when AI is empty and updated

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_IT_01      |

    And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     |
      | Inst_01     | random(RZ_PT_Inst_Bond_,2) |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD1         | [Inst_01.Symbol] | LTP  | 55.0  |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp |
      | MD1_Res1    | [MD1.symbol] | 2.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol           | quantity | price | value   | side  | participant          | notional |
      | PosUpdate_01 | [Acc_01.Account Id] | [Inst_01.Symbol] | 1000     | 60.0  | 60000.0 | SHORT | [Acc_01.Participant] | 60000    |

    Then "Position" messages are filtered by "level,participant,account,avgPrice,mtmValue" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | notional |
      | PosUpdate_01_Res2 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 1000.0        | 36000.0    | -1000.0     | -36000.0 | 36.0     | [PosUpdate_01.account] | -36000.0 | 60000.0  |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD2         | [Inst_01.Symbol] | AI   | 15.0  |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
      | Instance ID | symbol       | ai   |
      | MD1_Res1    | [MD1.symbol] | 15.0 |

    And "Position" messages are filtered by "level,participant,account,shortPosition,avgPrice,mtmValue" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | notional |
      | PosUpdate_01_Res3 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 1000.0        | 45000.0    | -1000.0     | -45000.0 | 45.0     | [PosUpdate_01.account] | -70000.0 | 60000.0  |

    Given instance "[Acc_01.Account Id] " of entity "Accounts" is deleted
    Given instance "[Inst_01.Symbol]" of entity "Instruments" is deleted

  @done1
  Scenario: TC_010 Validate MTM Value when LTP is empty and updated

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_IT_01      |

    And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     |
      | Inst_01     | random(RZ_PT_Inst_Bond_,2) |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD1         | [Inst_01.Symbol] | AI   | 25.0  |
      | MD2         | [Inst_01.Symbol] | LTP  | 0.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
      | Instance ID | symbol       | ai   |
      | MD1_Res1    | [MD1.symbol] | 25.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value   | side  | participant          | notional |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 1000     | 60.0  | 60000.0 | SHORT | [Acc_01.Participant] | 60000    |

    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | notional |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 1000.0        | 51000.0    | -1000.0     | -51000.0 | 51.0     | [PosUpdate_01.account] | -25000.0 | -60000.0 |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | type | value |
      | MD3         | [MD1.symbol] | LTP  | 65.0  |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD3_Res1    | [MD3.symbol] | 65.0 |

    Then "Position" messages are filtered by "level,participant,account,shortPosition,shortValue,mtmValue" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | notional |
      | PosUpdate_01_Res2 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 1000.0        | 51000.0    | -1000.0     | -51000.0 | 51.0     | [PosUpdate_01.account] | -90000.0 | 60000.0  |

    Given instance "[Acc_01.Account Id] " of entity "Accounts" is deleted
    Given instance "[TC_014_Inst.Symbol]" of entity "Instruments" is deleted

  @done
  Scenario: TC_011 Validate Realized MTM Value, Unrealized MTM Value, Unrealized MTM % when Long Position < Short Position , Long Position = Short Position  and Long Position > Short Position

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol              | type | value  |
      | MD1         | RZ_PT_Inst_Bond_003 | LTP  | 1000.0 |
      | MD2         | RZ_PT_Inst_Bond_003 | AI   |        |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp    |
      | MD1_Res1    | [MD1.symbol] | 1000.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value    | side | participant          | notional |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 1000     | 900.0 | 900000.0 | LONG | [Acc_01.Participant] | 900000   |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue  | avgPrice | account                | mtmValue  | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 1000.0       | 8100000.0 | 1000.0      | 8100000.0 | 8100.0   | [PosUpdate_01.account] | 2000000.0 | 0.0              | -6100000.0         | -75.30864197530865      | 900000.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value    | side  | participant          | notional |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 500      | 800.0 | 400000.0 | SHORT | [Acc_01.Participant] | 400000   |

    Then "Position" messages are filtered by "level,participant,account,shortPosition,mtmValue,unrealizedMtmValue" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | longPosition | longValue | netPosition | netValue  | avgPrice | account                | mtmValue  | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 500.0         | 3200000.0  | 1000.0       | 8100000.0 | 500.0       | 4900000.0 | 9800.0   | [PosUpdate_02.account] | 1000000.0 | -850000.0        | -3900000.0         | -79.59183673469387      | 400000.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value    | side  | participant          | notional |
      | PosUpdate_03 | [Acc_01.Account Id] | [MD1.symbol] | 500      | 800.0 | 400000.0 | SHORT | [Acc_01.Participant] | 400000   |

    Then "Position" messages are filtered by "level,participant,account,shortPosition,mtmValue,unrealizedMtmValue" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | longPosition | longValue | netPosition | netValue  | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional |
      | PosUpdate_03_Res1 | ACCOUNT | [PosUpdate_03.participant] | [PosUpdate_03.symbol] | 1000.0        | 6400000.0  | 1000.0       | 8100000.0 | 0.0         | 1700000.0 | 0.0      | [PosUpdate_03.account] | 0.0      | 1700000.0        | -1700000.0         | -100.0                  | 0.0      |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value    | side  | participant          | notional |
      | PosUpdate_04 | [Acc_01.Account Id] | [MD1.symbol] | 500      | 800.0 | 400000.0 | SHORT | [Acc_01.Participant] | 400000   |

    Then "Position" messages are filtered by "level,participant,account,shortPosition,mtmValue,unrealizedMtmValue" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | longPosition | longValue | netPosition | netValue   | avgPrice | account                | mtmValue   | realizedMtmValue | unrealizedMtmValue | notional  | unrealizedMtmPercentage |
      | PosUpdate_04_Res1 | ACCOUNT | [PosUpdate_04.participant] | [PosUpdate_04.symbol] | 1500.0        | 9600000.0  | 1000.0       | 8100000.0 | -500.0      | -1500000.0 | 3000.0   | [PosUpdate_04.account] | -1000000.0 | 1700000.0        | 500000.0           | -400000.0 | 33.33333333333333       |

  @done2
  Scenario: TC_012 Validate Priority of the Position Key applies ( For the accounts with multiple Keys -If specific key is available, then it applies. If not default Key applies)

    Given "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol              | type | value  |
      | MD1         | RZ_PT_Inst_Bond_003 | LTP  | 1000.0 |
      | MD2         | RZ_PT_Inst_Bond_003 | AI   | 50.00  |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp    |
      | MD1_Res1    | [MD1.symbol] | 1000.0 |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
      | Instance ID | symbol       | ai   |
      | MD1_Res2    | [MD1.symbol] | 50.0 |

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_01,RZ_PT_PK_02 |
    # added position for Market CME
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value   | side | participant | notional | currency | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 100      | 900.0 | 90000.0 | LONG | RZ-PT-01    | 90000    | USD      | CME    |

    Then  "Position" messages are filtered by "level,participant,account,symbol" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedInterest | ai   | market                |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 100.0        | 855000.0  | 100.0       | 855000.0 | 8550.0   | [PosUpdate_01.account] | 210000.0 | 0.0              | -645000.0          | -75.43859649122807      | 90000.0  | USD      | 45000.0         | 50.0 | [PosUpdate_01.market] |

    # added position for Market CCCAGG ( Seperate Position Created since RZ_PT_PK_01 is applicable )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value    | side | participant | notional | currency | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 150      | 900.0 | 135000.0 | LONG | RZ-PT-01    | 135000   | USD      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue  | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | ai   | market                |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 150.0        | 1282500.0 | 150.0       | 1282500.0 | 8550.0   | [PosUpdate_02.account] | 315000.0 | 0.0              | -967500.0          | -75.43859649122807      | 135000.0 | 675000.0        | 50.0 | [PosUpdate_02.market] |

    # added position for Market  CCCAGG ( Position is aggregated since RZ_PT_PK_01 is applicable )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value   | side | participant | notional | currency | market |
      | PosUpdate_03 | [Acc_01.Account Id] | [MD1.symbol] | 100      | 900.0 | 90000.0 | LONG | RZ-PT-01    | 90000    | USD      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue  | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | market                |
      | PosUpdate_03_Res1 | ACCOUNT | [PosUpdate_03.participant] | [PosUpdate_03.symbol] | 200.0        | 1710000.0 | 200.0       | 1710000.0 | 8550.0   | [PosUpdate_03.account] | 380000.0 | 0.0              | -1330000.0         | -77.77777778            | 180000.0 | 90000.0         | [PosUpdate_02.market] |

    Given "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol              | type | value |
      | MD3         | RZ_PT_Inst_Bond_004 | LTP  | 900.0 |
      | MD4         | RZ_PT_Inst_Bond_004 | AI   |       |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp   |
      | MD3_Res1    | [MD3.symbol] | 900.0 |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
      | Instance ID | symbol       | ai  |
      | MD3_Res2    | [MD3.symbol] | 0.0 |
    # added position for Market CME
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | market |
      | PosUpdate_04 | [Acc_01.Account Id] | [MD3.symbol] | 10       | 900.0 | 9000.0 | LONG | RZ-PT-01    | 9000     | GBP      | CME    |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | market                |
      | PosUpdate_04_Res1 | ACCOUNT | [PosUpdate_04.participant] | [PosUpdate_04.symbol] | 10.0         | 81450.0   | 10.0        | 81450.0  | 900.0    | [PosUpdate_04.account] | 18100.0  | 0.0              | -63350.0           | -77.77777778            | 9000.0   | 450.0           | [PosUpdate_04.market] |

    # added position for Market CCCAGG( Position is aggregated since RZ_PT_PK_02 is applicable )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | market |
      | PosUpdate_05 | [Acc_01.Account Id] | [MD3.symbol] | 10       | 900.0 | 9000.0 | LONG | RZ-PT-01    | 9000     | GBP      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | market |
      | PosUpdate_05_Res1 | ACCOUNT | [PosUpdate_05.participant] | [PosUpdate_05.symbol] | 20.0         | 162900.0  | 200.0       | 162900.0 | 900.0    | [PosUpdate_05.account] | 36200.0  | 0.0              | -126700.0          | -77.77777778.0          | 18000.0  | 900.0           |        |

  @done @key
  Scenario: TC_013 Validate Priority of the Position Key applies ( For the accounts with multiple Keys -If multiples keys eligible,priority will consider.)

    Given "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol              | type | value |
      | MD1         | RZ_PT_Inst_Bond_003 | LTP  | 100.0 |
      | MD2         | RZ_PT_Inst_Bond_003 | AI   | 5.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp   |
      | MD1_Res1    | [MD1.symbol] | 100.0 |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
      | Instance ID | symbol       | ai  |
      | MD1_Res2    | [MD1.symbol] | 5.0 |

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_03,RZ_PT_PK_02 |

    # added position for with a Expiry Date
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side | participant | notional | currency | expiryDate                    |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | LONG | RZ-PT-01    | 900      | USD      | 2022-04-23T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,symbol" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedInterest | ai  | expiryDate                |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0         | 855.0     | 10.0        | 855.0    | 85.5     | [PosUpdate_01.account] | 2100.0   | 0.0              | 1245.0             | 145.61403508771932      | 900.0    | USD      | 45.0            | 5.0 | [PosUpdate_01.expiryDate] |

    # added position for with different Expiry Date (Position is aggregated since RZ_PT_PK_03 is applicable )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | expiryDate                    |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1282.5 | LONG | RZ-PT-01    | 1350     | USD      | 2022-05-23T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,symbol" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | ai  | expiryDate |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 25.0         | 2137.5    | 25.0        | 2137.5   | 85.5     | [PosUpdate_02.account] | 5250.0   | 0.0              | 3112.5             | 145.61403508771932      | 2250.0   | 112.5           | 5.0 |            |

  @wipe @key
  Scenario: TC_014 Validate default Key applies if there is no eligible keys attached to the Account

    Given "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol              | type | value |
      | MD1         | RZ_PT_Inst_Bond_003 | LTP  | 80.0  |
      | MD2         | RZ_PT_Inst_Bond_003 | AI   | 5.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD1_Res1    | [MD1.symbol] | 80.0 |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
      | Instance ID | symbol       | ai  |
      | MD1_Res2    | [MD1.symbol] | 5.0 |

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_04      |

     # added position for with an Expiry Date
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side | participant | notional | currency | market | expiryDate                    |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | LONG | RZ-PT-01    | 900      | USD      | CCCAGG | 2022-04-23T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedInterest | ai  |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0         | 855.0     | 10.0        | 855.0    | 85.5     | [PosUpdate_01.account] | 1700.0   | 0.0              | 845.0              | 98.83040935672514       | 900.0    | USD      | 45.0            | 5.0 |

    # added position for with a different Expiry Date(Position is aggregated since Default is applicable )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | market | expiryDate                    |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1282.5 | LONG | RZ-PT-01    | 1350     | USD      | CCCAGG | 2022-05-23T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | ai  | expiryDate | market                |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 25.0         | 1282.5    | 25.0        | 1282.5   | 85.5     | [PosUpdate_02.account] | 4250.0   | 0.0              | 2112.5             | 98.83040935672514       | 2250.0   | 112.5           | 5.0 |            | [PosUpdate_02.market] |

    # added position for with a different Market(Position is aggregated since Default is applicable )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | market |
      | PosUpdate_03 | [Acc_01.Account Id] | [MD1.symbol] | 12       | 90.0  | 1026.0 | LONG | RZ-PT-01    | 1080     | USD      | CME    |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | ai  | expiryDate | market |
      | PosUpdate_03_Res1 | ACCOUNT | [PosUpdate_03.participant] | [PosUpdate_03.symbol] | 37.0         | 3163.5    | 37          | 3163.5   | 85.5     | [PosUpdate_03.account] | 6290.0   | 0.0              | 3126.5             | 98.83040935672514       | 3330.0   | 166.5           | 5.0 |            |        |

    Given "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol              | type | value |
      | MD3         | RZ_PT_Inst_Bond_004 | LTP  | 90.0  |
      | MD4         | RZ_PT_Inst_Bond_004 | AI   | 5.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD3_Res1    | [MD3.symbol] | 80.0 |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
      | Instance ID | symbol       | ai  |
      | MD4_Res1    | [MD4.symbol] | 5.0 |

       # added position for with Expiry date
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side | participant | notional | currency | market | expiryDate                    |
      | PosUpdate_04 | [Acc_01.Account Id] | [MD3.symbol] | 10       | 90.0  | 900.0 | LONG | RZ-PT-01    | 900      | GBP      | CME    | 2022-04-23T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | market                | expiryDate                |
      | PosUpdate_04_Res1 | ACCOUNT | [PosUpdate_04.participant] | [PosUpdate_04.symbol] | 10.0         | 855.0     | 10.0        | 855.0    | 85.5     | [PosUpdate_04.account] | 1900.0   | 0.0              | 1045.0             | 122.2222222             | 900.0    | 45.0            | [PosUpdate_04.market] | [PosUpdate_04.expiryDate] |

    # added position with Different Expiry Date(  RZ_PT_PK_04 is applicable. New position created )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side | participant | notional | currency | market | expiryDate                    |
      | PosUpdate_05 | [Acc_01.Account Id] | [MD3.symbol] | 15       | 90.0  | 900.0 | LONG | RZ-PT-01    | 900      | GBP      | CME    | 2022-06-23T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | market                | expiryDate                |
      | PosUpdate_05_Res1 | ACCOUNT | [PosUpdate_05.participant] | [PosUpdate_05.symbol] | 10.0         | 1282.5    | 10.0        | 1282.5   | 85.5     | [PosUpdate_05.account] | 2850.0   | 0.0              | 1567.5             | 122.2222222             | 1350.0   | 90.0            | [PosUpdate_05.market] | [PosUpdate_05.expiryDate] |

  @done6 @key
  Scenario: TC_015 Validate Position Key of asset class is applied(FI and Equity)

    Given "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol            | type | value |
      | MD1         | RZ_PT_Inst_Bond_3 | LTP  | 80.0  |
      | MD2         | RZ_PT_Inst_Bond_3 | AI   | 5.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD1_Res1    | [MD1.symbol] | 80.0 |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
      | Instance ID | symbol       | ai  |
      | MD1_Res2    | [MD1.symbol] | 5.0 |

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_01,RZ_PT_PK_06 |

      # Position update for Bond Instrument
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant | notional | currency | market | expiryDate                    |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | SHORT | RZ-PT-01    | 900      | USD      | CCCAGG | 2022-06-23T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,symbol" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedInterest | ai  |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0          | 855.0      | -10.0       | -855.0   | 85.5     | [PosUpdate_01.account] | -1700.0  | 0.0              | -845.0             | -98.83040935672514      | -900.0   | USD      | -45.0           | 5.0 |

    # Position update with Different Market-CME ( Seperate Position creates)
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | market | expiryDate                    |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1282.5 | LONG | RZ-PT-01    | 1350     | USD      | CME    | 2022-06-23T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,symbol" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | ai  |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 15.0         | 1282.5    | 15.0        | 1282.5   | 85.5     | [PosUpdate_02.account] | 2550.0   | 0.0              | 1267.5             | 98.83040935672514       | 1350.0   | 67.5            | 5.0 |

    # Position update with Same Market-CCCAGG ( Aggregated position should be created)
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side  | participant | notional | currency | market | expiryDate                    |
      | PosUpdate_03 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1282.5 | SHORT | RZ-PT-01    | 1350     | USD      | CCCAGG | 2022-05-23T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,symbol" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | ai  | expiryDate |
      | PosUpdate_03_Res1 | ACCOUNT | [PosUpdate_03.participant] | [PosUpdate_03.symbol] | 25.0          | -2250.0    | 0.0          | 0.0       | -25.0       | -2250.0  | 85.5     | [PosUpdate_03.account] | -4250.0  | 0.0              | -2112.5            | -98.83040936            | -2250.0  | -112.5          | 5.0 |            |

    ## For Equity Instrument

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol | type | value |
      | MD3         | GOOG   | LTP  | 80.0  |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD3_Res1    | [MD3.symbol] | 80.0 |

    # Position update with Settlement Date
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol            | quantity | price | value | side  | participant | currency | market | settlementDate                |
      | PosUpdate_05 | [Acc_01.Account Id] | [MD3_Res1.symbol] | 15       | 90.0  | 1350  | SHORT | RZ-PT-01    | GBP      | CME    | 2020-04-23T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,symbol,currency" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | currency                | settlementDate                |
      | PosUpdate_05_Res1 | ACCOUNT | [PosUpdate_05.participant] | [PosUpdate_05.symbol] | 15.0          | 1350.0     | 0.0          | 0.0       | -15.0       | -1350.0  | 90.0     | [PosUpdate_05.account] | -1200.0  | 0.0              | 150.0              | 11.11111111111111       | [PosUpdate_05.currency] | [PosUpdate_05.settlementDate]

   # Position Update with Different Settlement Date (Seperate Position should be created.RZ_PT_PK_06 applied )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol            | quantity | price | value | side  | participant | currency | market | settlementDate                |
      | PosUpdate_06 | [Acc_01.Account Id] | [MD3_Res1.symbol] | 15       | 90.0  | 1350  | SHORT | RZ-PT-01    | GBP      | CME    | 2020-04-13T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,symbol,currency" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | currency                | settlementDate                |
      | PosUpdate_06_Res1 | ACCOUNT | [PosUpdate_06.participant] | [PosUpdate_06.symbol] | 15.0          | 1350.0     | 0.0          | 0.0       | -15.0       | -1350.0  | 90.0     | [PosUpdate_06.account] | -1200.0  | 0.0              | 150.0              | 11.11111111111111       | [PosUpdate_06.currency] | [PosUpdate_06.settlementDate] |

    # Position Update with same Settlement Date ( Position should be aggregated )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol            | quantity | price | value | side  | participant | currency | market | settlementDate                |
      | PosUpdate_07 | [Acc_01.Account Id] | [MD3_Res1.symbol] | 15       | 90.0  | 1350  | SHORT | RZ-PT-01    | USD      | CME    | 2020-04-13T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,shortPosition,symbol,currency" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | currency                | settlementDate                |
      | PosUpdate_07_Res1 | ACCOUNT | [PosUpdate_07.participant] | [PosUpdate_07.symbol] | 30.0          | 2700.0     | 0.0          | 0.0       | -30.0       | -2700.0  | 90.0     | [PosUpdate_07.account] | -2400.0  | 0.0              | 300.0              | 11.11111111111111       | [PosUpdate_07.currency] | [PosUpdate_07.settlementDate] |

  @done2
  Scenario: TC_016 Validate correct key applies when prioritized key is Inactive

    Given "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol            | type | value |
      | MD1         | RZ_PT_Inst_Bond_3 | LTP  | 80.0  |
      | MD2         | RZ_PT_Inst_Bond_3 | AI   | 5.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD1_Res1    | [MD1.symbol] | 80.0 |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
      | Instance ID | symbol       | ai  |
      | MD1_Res2    | [MD1.symbol] | 5.0 |

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_08,RZ_PT_PK_02 |

   # added position for with market CCCAGG
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant | notional | currency | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | SHORT | RZ-PT-01    | 900      | USD      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedInterest | ai  |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0          | 855.0      | -10.0       | -855.0   | 85.5     | [PosUpdate_01.account] | -1700.0  | 0.0              | -845.0             | -98.83040935672514      | -900.0   | USD      | -45.0           | 5.0 |

    # Position update with Different Market-CME ( Aggregated position should be created,RZ_PT_PK_02 applies)
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1350.0 | LONG | RZ-PT-01    | 1350     | USD      | CME    |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | ai  | market |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 15.0         | 1350.0    | 5.0         | 50.0     | 85.5     | [PosUpdate_02.account] | 850.0    | 0.0              | 422.5              | 98.83040935672514       | 450.0    | 22.5            | 5.0 |        |

  @done2
  Scenario: TC_017 Validate Position Key Status Changes from INACTIVE to ACTIVE

    Given "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol            | type | value |
      | MD1         | RZ_PT_Inst_Bond_003 | LTP  | 80.0  |
      | MD2         | RZ_PT_Inst_Bond_003 | AI   | 5.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD1_Res1    | [MD1.symbol] | 80.0 |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
      | Instance ID | symbol       | ai  |
      | MD1_Res2    | [MD1.symbol] | 5.0 |

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_07,RZ_PT_PK_02 |

   # added position for with market CCCAGG
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant | notional | currency | market | settlementDate                |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | SHORT | RZ-PT-01    | 900      | USD      | CCCAGG | 2022-02-22T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedInterest | ai  | settlementDate                |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0          | 855.0      | -10.0       | -855.0   | 85.5     | [PosUpdate_01.account] | -1700.0  | 0.0              | -845.0             | -98.83040935672514      | -900.0   | USD      | -45.0           | 5.0 | [PosUpdate_01.settlementDate] |

    # Position update with Different Market-CME and Different Settlement Dates( Aggregated position should be created,RZ_PT_PK_02 applies)
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | market | settlementDate                |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1350.0 | LONG | RZ-PT-01    | 1350     | USD      | CME    | 2022-03-22T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | ai  | market |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 15.0         | 1350.0    | 5.0         | 50.0     | 85.5     | [PosUpdate_02.account] | 850.0    | 0.0              | 422.5              | 98.83040935672514       | 450.0    | 22.5            | 5.0 |        |

    Given instance "RZ_PT_PK_07" of entity "Position Keys" is updated with following values
      | Instance ID | Status |
      | Update01    | ACTIVE |

      # added position for with market CCCAGG
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant | notional | currency | market | settlementDate                | expiryDate                    |
      | PosUpdate_03 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | SHORT | RZ-PT-01    | 900      | USD      | CCCAGG | 2022-02-22T00:00:00.000+00:00 | 2022-02-25T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedInterest | ai  | settlementDate                |
      | PosUpdate_03_Res1 | ACCOUNT | [PosUpdate_03.participant] | [PosUpdate_03.symbol] | 10.0          | 855.0      | -10.0       | -855.0   | 85.5     | [PosUpdate_03.account] | -1700.0  | 0.0              | -845.0             | -98.83040935672514      | -900.0   | USD      | -45.0           | 5.0 | [PosUpdate_03.settlementDate] |

    # Position update with Different Market-CME and Different Settlement Dates( New position should be created,RZ_PT_PK_07 applies)
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | market | settlementDate                | expiryDate                    |
      | PosUpdate_04 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1350.0 | LONG | RZ-PT-01    | 1350     | USD      | CME    | 2022-03-22T00:00:00.000+00:00 | 2022-03-25T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | ai  | market                | settlementDate                |
      | PosUpdate_04_Res1 | ACCOUNT | [PosUpdate_04.participant] | [PosUpdate_04.symbol] | 15.0         | 1350.0    | 15.0        | 1350.0   | 85.5     | [PosUpdate_04.account] | 2550.0   | 0.0              | 1267.5             | 98.83040935672514       | 1350.0   | 67.5            | 5.0 | [PosUpdate_04.market] | [PosUpdate_04.settlementDate] |

     # Position update with Different Expire Dates( Position should be aggregated,RZ_PT_PK_07 applies)
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | market | settlementDate                | expiryDate                    |
      | PosUpdate_05 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1350.0 | LONG | RZ-PT-01    | 1350     | USD      | CME    | 2022-03-22T00:00:00.000+00:00 | 2022-04-25T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | ai  | market                | settlementDate                | expiryDate |
      | PosUpdate_05_Res1 | ACCOUNT | [PosUpdate_05.participant] | [PosUpdate_04.symbol] | 30.0         | 2850.0    | 30.0        | 2850.0   | 85.5     | [PosUpdate_05.account] | 6000.0   | 0.0              | 3435.0             | 133.9181287             | 2850.0   | 142.5           | 5.0 | [PosUpdate_05.market] | [PosUpdate_04.settlementDate] |            |

    #reset the Position Key
    Given instance "RZ_PT_PK_07" of entity "Position Keys" is updated with following values
      | Instance ID | Status |
      | Update01    | INACTIVE |


      @MD
  Scenario: TC_018

    Given "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol            | type | value |
      | MD1         | RZ_PT_Inst_Bond_003 | LTP  | 8.0  |
      | MD2         | RZ_PT_Inst_Bond_003 | AI   | 5.0   |

