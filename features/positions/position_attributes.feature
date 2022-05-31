Feature: Position Attributes

  @done
  Scenario: TC_001 Validating Position Key  and position id exists

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-001   |

    When "Position Update" messages are submitted with following values
      | Instance ID  | symbol              | quantity | price | side  | participant          | type   | account             | notional | Position Key Id |
      | PosUpdate_01 | RZ_PT_Inst_Bond_001 | 1000     | 50.0  | SHORT | [Acc_01.Participant] | MARGIN | [Acc_01.Account Id] | 50000    | 1               |

    Then "Position" messages are filtered by "level,account,participant" should be
      | Instance ID       | symbol                | level   | account                | participant                | type   | shortPosition | netPosition | positionKey | positionId |
      | PosUpdate_01_Res1 | [PosUpdate_01.symbol] | ACCOUNT | [PosUpdate_01.account] | [PosUpdate_01.participant] | MARGIN | 1000.0        | -1000.0     | NOT_EMPTY   | NOT_EMPTY  |

    Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted

  @done
  Scenario: TC_002 Validating Symbol for Floating Rate Bond

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-001   |

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
      | Instance ID | Account Id           | Name                 | Participant |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-001   |

    And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                    | Currency |
      | Inst_01     | random(RZ_PT_Inst_Bond,2) | BTC      |

    When "Position Update" messages are submitted with following values
      | Instance ID  | symbol           | quantity | price | side  | participant          | type   | account             | notional | market   | currency |
      | PosUpdate_01 | [Inst_01.Symbol] | 1000     | 50.0  | SHORT | [Acc_01.Participant] | MARGIN | [Acc_01.Account Id] | 50000    | BitStamp | BTC      |

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

  @done @fail
  Scenario: TC_004 Validating Settlement Date

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-001   |

    When "Position Update" messages are submitted with following values
      | Instance ID  | symbol              | quantity | price | side  | participant          | type   | account             | notional | settlement Date |
      | PosUpdate_01 | RZ_PT_Inst_Bond_001 | 1000     | 50.0  | SHORT | [Acc_01.Participant] | MARGIN | [Acc_01.Account Id] | 50000    | 2022-04-20      |

    Then "Position" messages are filtered by "level,account,participant" should be
      | Instance ID       | symbol                | level   | account                | participant                | type   | shortPosition | netPosition | settlementDate                 |
      | PosUpdate_01_Res1 | [PosUpdate_01.symbol] | ACCOUNT | [PosUpdate_01.account] | [PosUpdate_01.participant] | MARGIN | 1000.0        | -1000.0     | [PosUpdate_01.settlement Date] |

    Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted

  @done
  Scenario: TC_005 Validating Markets ( Position Updates added with different Markets)

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-001   |

    When "Position Update" messages are submitted with following values
      | Instance ID  | symbol              | quantity | price | side  | participant          | type   | account             | notional | market   |
      | PosUpdate_01 | RZ_PT_Inst_Bond_001 | 1000     | 50.0  | SHORT | [Acc_01.Participant] | MARGIN | [Acc_01.Account Id] | 50000    | BitStamp |

    Then "Position" messages are filtered by "level,account,participant,shortPosition,market" should be
      | Instance ID | symbol                | level   | account                | participant                | type   | shortPosition | market                |
      | Acc_01_Res1 | [PosUpdate_01.symbol] | ACCOUNT | [PosUpdate_01.account] | [PosUpdate_01.participant] | MARGIN | 1000.0        | [PosUpdate_01.market] |

    When "Position Update" messages are submitted with following values
      | Instance ID  | symbol              | quantity | price | side  | participant          | type   | account             | notional | market  |
      | PosUpdate_02 | RZ_PT_Inst_Bond_002 | 1000     | 50.0  | SHORT | [Acc_01.Participant] | MARGIN | [Acc_01.Account Id] | 500000   | BINANCE |

    Then "Position" messages are filtered by "level,account,participant,shortPosition,market" should be
      | Instance ID       | symbol                | level   | account                | participant                | type   | shortPosition | market                |
      | PosUpdate_02_Res1 | [PosUpdate_02.symbol] | ACCOUNT | [PosUpdate_02.account] | [PosUpdate_02.participant] | MARGIN | 1000.0        | [PosUpdate_02.market] |

    Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted

  @done1
  Scenario: TC_006 Validate Values in Long position ( longPosition,longValue, notional, average Price )

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-001   |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol              | type | value |
      | MD1         | RZ_PT_Inst_Bond_001 | AI   | 2.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
      | Instance ID | symbol       | ai  |
      | MD1_Res1    | [MD1.symbol] | 2.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value   | side | participant          | notional |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.Symbol] | 6000     | 5.0   | 30000.0 | LONG | [Acc_01.Participant] | 30000    |

    Then "Position" messages are filtered by "level,participant,account" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | account                | avgPrice | notional |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 6000.0       | 2100.0    | 6000.0      | 2100.0   | [PosUpdate_01.account] | 0.35     | 30000.0  |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value   | side | participant          | notional |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.Symbol] | 4000     | 4.0   | 16000.0 | LONG | [Acc_01.Participant] | 16000    |

    Then "Position" messages are filtered by "level,participant,account,longPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | account                | avgPrice | notional |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 10000.0      | 3060.0    | 10000.0     | 3060.0   | [PosUpdate_02.account] | 0.306    | 46000.0  |

    Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted

  @done
  Scenario: TC_007 Validate values in Short Position (shortPosition, shortValue, Average price, notional )

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-001   |

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

    And "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 600.0         | 15600.0    | -600.0      | -15600.0 | 26.0     | [PosUpdate_01.account] | 30000    |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value   | side  | participant          | notional |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 1000     | 51.0  | 51000.0 | SHORT | [Acc_01.Participant] | 51000    |

    And "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 1600.0        | 27030.0    | -1600.0     | -42630.0 | 26.64375 | [PosUpdate_02.account] | 96000.0  |

    Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted

  @done
  Scenario: TC_008 Validate MTM Value when LTP is empty and updated before the next position update

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-001   |

    And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol              |
      | Inst_01     | (RZ_PT_Inst_Bond,2) |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD1         | [Inst_01.Symbol] | AI   | 15.0  |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
      | Instance ID | symbol           | ai   |
      | MD1_Res1    | [Inst_01.symbol] | 15.0 |

    And "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol           | quantity | price | value   | side  | participant          | notional |
      | PosUpdate_01 | [Acc_01.Account Id] | [Inst_01.Symbol] | 1000     | 60.0  | 60000.0 | SHORT | [Acc_01.Participant] | 100000   |

    And "Position" messages are filtered by "level,participant,account,mtmValue" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | notional |
      | PosUpdate_01_Res2 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 1000.0        | 75000.0    | -1000.0     | -75000.0 | 75.0     | [PosUpdate_01.account] | -15000.0 | 100000.0 |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD2         | [Inst_01.Symbol] | LTP  | 75.0  |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD2_res1    | [Inst_01.Symbol] | LTP  | 75.0  |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol           | quantity | price | value   | side  | participant          | notional |
      | PosUpdate_02 | [Acc_01.Account Id] | [Inst_01.Symbol] | 1000     | 60.0  | 60000.0 | SHORT | [Acc_01.Participant] | 100000   |

    And "Position" messages are filtered by "level,participant,account,shortPosition,mtmValue" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue  | avgPrice | account                | mtmValue  | notional |
      | PosUpdate_02_Res2 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 2000.0        | 150000.0   | -2000.0     | -150000.0 | 75.0     | [PosUpdate_02.account] | -180000.0 | 100000.0 |

    Given instance "[Acc_01.Account Id] " of entity "Accounts" is deleted
    Given instance "[Inst_01.Symbol]" of entity "Instruments" is deleted

  @done
  Scenario: TC_009 Validate MTM Value when AI is empty and updated

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-001   |

    And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                |
      | Inst_01     | random(FR_BOND_CUR,6) |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD1         | [Inst_01.Symbol] | LTP  | 55.0  |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp |
      | MD1_Res1    | [MD1.symbol] | 2.0 |

    And "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol           | quantity | price | value   | side  | participant          | notional |
      | PosUpdate_01 | [Acc_01.Account Id] | [Inst_01.Symbol] | 1000     | 60.0  | 60000.0 | SHORT | [Acc_01.Participant] | 60000    |

    And "Position" messages are filtered by "level,participant,account,avgPrice,mtmValue" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | notional |
      | PosUpdate_01_Res2 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 1000.0        | 36000.0    | -1000.0     | -36000.0 | 36.0     | [PosUpdate_01.account] | -36000.0 | 60000.0  |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD2         | [Inst_01.Symbol] | AI   | 15.0  |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
      | Instance ID | symbol       | ai   |
      | MD1_Res1    | [MD1.symbol] | 15.0 |


    Then "Position" messages are filtered by "level,participant,account,shortPosition,avgPrice,mtmValue" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | notional |
      | PosUpdate_01_Res3 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 1000.0        | 45000.0    | -1000.0     | -45000.0 | 45.0     | [PosUpdate_01.account] | -70000.0 | 60000.0  |

    Given instance "[Acc_01.Account Id] " of entity "Accounts" is deleted
    Given instance "[Inst_01.Symbol]" of entity "Instruments" is deleted

  @wip1
  Scenario: TC_010 Validate MTM Value when LTP is empty and updated

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-001   |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol              | type | value |
      | MD1         | RZ_PT_Inst_Bond_001 | AI   | 25.0  |
      | MD2         | RZ_PT_Inst_Bond_001 | LTP  | 0.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
      | Instance ID | symbol       | ai   |
      | MD2_Res1    | [MD2.symbol] | 25.0 |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp |
      | MD2_Res1    | [MD2.symbol] | 0.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value   | side  | participant          | notional |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 1000     | 60.0  | 60000.0 | SHORT | [Acc_01.Participant] | 60000    |

    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | notional |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 1000.0        | 51000.0    | -1000.0     | -51000.0 | 51.0     | [PosUpdate_01.account] | -25000.0 | 60000.0  |

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

  @done5
  Scenario: TC_011 Validate Realized MTM Value, Unrealized MTM Value, Unrealized MTM % when Long Position < Short Position , Long Position = Short Position  and Long Position > Short Position

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-001   |

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


  @wip
  Scenario: TC_012 Validate Priority of the Position Key applies ( For the accounts with multiple Keys -If specific key is available, then it applies. If not default Key applies)

    Given "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol              | type | value  |
      | MD1         | RZ_PT_Inst_Bond_003 | LTP  | 1000.0 |
      | MD2         | RZ_PT_Inst_Bond_003 | AI   | 500.00 |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp    |
      | MD1_Res1    | [MD1.symbol] | 1000.0 |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
      | Instance ID | symbol       | ai    |
      | MD1_Res2    | [MD1.symbol] | 500.0 |

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids          |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-001   | MARGIN | USD              | CLIENT   | RZ_PT_IT_001,RZ_PT_IT_002 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value   | side | participant | notional | currency |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 100      | 900.0 | 90000.0 | LONG | RZ-PT-001   | 90000    | USD      |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,symbol" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue  | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedInterest | ai    |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 100.0        | 1260000.0 | 100.0       | 1260000.0 | 12600.0  | [PosUpdate_01.account] | 300000.0 | 0.0              | -960000.0          | -76.19047619047619      | 90000.0  | USD      | 450000.0        | 500.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value    | side | participant | notional | currency |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 150      | 900.0 | 135000.0 | LONG | RZ-PT-001   | 135000   | GBP      |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,symbol" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue  | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | ai    |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 150.0        | 1890000.0 | 150.0       | 1890000.0 | 12600.0  | [PosUpdate_02.account] | 450000.0 | 0.0              | -1440000.0         | -76.19047619047619      | 135000.0 | 675000.0        | 500.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value   | side | participant | notional | currency |
      | PosUpdate_03 | [Acc_01.Account Id] | [MD1.symbol] | 100      | 900.0 | 90000.0 | LONG | RZ-PT-001   | 90000    | USD      |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,symbol" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue  | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest |
      | PosUpdate_03_Res1 | ACCOUNT | [PosUpdate_03.participant] | [PosUpdate_03.symbol] | 200.0        | 2520000.0 | 200.0       | 2520000.0 | 12600.0  | [PosUpdate_03.account] | 600000.0 | 0.0              | -1920000.0         | -76.19047619047619      | 180000.0 | 900000.0        |

#    Given "Realtime Risk Factor Update" messages are submitted with following values
#      | Instance ID | symbol              | type | value  |
#      | MD3         | RZ_PT_Inst_Bond_0045 | LTP  | 1000.0 |
#      | MD4         | RZ_PT_Inst_Bond_0045 | AI   | 500.00 |
#
#    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
#      | Instance ID | symbol       | ltp    |
#      | MD3_Res1    | [MD3.symbol] | 1000.0 |
#
#    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
#      | Instance ID | symbol       | ai    |
#      | MD3_Res2    | [MD3.symbol] | 500.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value   | side | participant | notional | currency | market |
      | PosUpdate_05 | [Acc_01.Account Id] |  [MD1.symbol]  | 100      | 900.0 | 90000.0 | LONG | RZ-PT-001   | 90000    | GBP      | CME    |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,symbol" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue  | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest |
      | PosUpdate_05_Res1 | ACCOUNT | [PosUpdate_05.participant] | [PosUpdate_05.symbol] | 100.0        | 90000.0 | 100.0       | 90000.0 | 900.0  | [PosUpdate_05.account] | 0.0 | 0.0              | -90000.0          | -100.0      | 90000.0  | 0.0       |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value   | side | participant | notional | currency | market |
      | PosUpdate_06 | [Acc_01.Account Id] |  [MD1.symbol]  | 100      | 900.0 | 90000.0 | LONG | RZ-PT-001   | 90000    | GBP      | XNAS   |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,symbol" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue  | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest |
      | PosUpdate_06_Res1 | ACCOUNT | [PosUpdate_06.participant] | [PosUpdate_06.symbol] | 200.0        | 180000.0 | 200.0       | 180000.0 | 900.0  | [PosUpdate_06.account] | 0.0 | 0.0              | -180000.0         | -100.0       | 180000.0 | 0.0       |


  @MD
  Scenario: MD

#        Given instance "Home" of entity "Accounts" is copied with following values
#      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids          |
#      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-001   | MARGIN | USD              | CLIENT   | RZ_PT_IT_001,RZ_PT_IT_002 |
#
#    When "Position Update" messages are submitted with following values
#      | Instance ID  | account             | symbol       | quantity | price | value   | side | participant | notional | currency | Market |
#      | PosUpdate_05 | [Acc_01.Account Id] | RZ_PT_Inst_Bond_0045 | 100      | 900.0 | 90000.0 | LONG | RZ-PT-001   | 90000    | GBP      | CME    |
#

    Given "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol                | type | value   |
      | MD3         | RZ_PT_Inst_Bond_0045 | LTP  | 11000.0 |
      | MD4         | RZ_PT_Inst_Bond_0045 | AI   | 1500.00 |
