Feature: Position Attributes

  @done
  Scenario: TC_001 Validating Position Key  and position id exists

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

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
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

    And  instance "FLR_BOND" of entity "Instruments" is copied with following values
      | Instance ID | Instrument Type    | Symbol                     | Coupon Benchmark | Reset Frequency | Fixing Offset | Last Fixing Rate |
      | Inst_01     | FLOATING_RATE_BOND | random(RZ_PT_Inst_Bond_,4) | AJ-USD           | 1               | 1             | 1                |

    When "Position Update" messages are submitted with following values
      | Instance ID  | symbol           | quantity | price | side  | participant          | type   | account             | notional |
      | PosUpdate_01 | [Inst_01.Symbol] | 1000     | 50.0  | SHORT | [Acc_01.Participant] | MARGIN | [Acc_01.Account Id] | 50000    |

    Then "Position" messages are filtered by "level,account,participant" should be
      | Instance ID       | symbol                | level   | account                | participant                | type   | shortPosition | netPosition | positionKey |
      | PosUpdate_01_Res1 | [PosUpdate_01.symbol] | ACCOUNT | [PosUpdate_01.account] | [PosUpdate_01.participant] | MARGIN | 1000.0        | -1000.0     | NOT_EMPTY   |

    Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted
#    Given instance "[Inst_01.Symbol]" of entity "Instruments" is deleted

  @done
  Scenario: TC_003 Validating Currency ( Bonds with different currencies)

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

    And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                           | Currency |
      | Inst_01     | random(RZ_PT_Inst_Bond_TC_003,3) | GBP      |

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
#    Given instance "[Inst_01.Symbol]" of entity "Instruments" is deleted

  @done
  Scenario: TC_004 Validating Settlement Date

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

    When "Position Update" messages are submitted with following values
      | Instance ID  | symbol              | quantity | price | side  | participant          | type   | account             | notional | settlementDate                |
      | PosUpdate_01 | RZ_PT_Inst_Bond_001 | 1000     | 50.0  | SHORT | [Acc_01.Participant] | MARGIN | [Acc_01.Account Id] | 50000    | 2022-06-20T00:00:00.000+00:00 |

    Then "Position" messages are filtered by "level,account,participant,symbol" should be
      | Instance ID       | symbol                | level   | account                | participant                | type   | shortPosition | netPosition | settlementDate                |
      | PosUpdate_01_Res1 | [PosUpdate_01.symbol] | ACCOUNT | [PosUpdate_01.account] | [PosUpdate_01.participant] | MARGIN | 1000.0        | -1000.0     | [PosUpdate_01.settlementDate] |

    Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted

  @done-removable
  Scenario: TC_005 Validating Markets ( Position Updates added with different Markets)

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

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

  @done-removable
  Scenario: TC_006 Validate Values in Long position ( longPosition,longValue, notional, average Price )

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

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

  @done-removable
  Scenario: TC_007 Validate values in Short Position (shortPosition, shortValue, Average price, notional )

    Given  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

    Then instance "[Acc_01.Account Id]" of entity "Accounts" should be
      | Instance ID | Name          |
      | Acc_01_Res1 | [Acc_01.Name] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol              | type | value | currency |
      | MD1         | [Inst_01.Symbol] | AI   | 2.0   | USD      |
      | MD2         | [Inst_01.Symbol] | LTP  | 45.0  | USD      |
#
#    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
#      | Instance ID | symbol       | ai  |
#      | MD1_Res1    | [MD1.symbol] | 2.0 |

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
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 1600.0        | 42630.0    | -1600.0     | -42630.0 | 26.64 | [PosUpdate_02.account] | -81000.0 |

    Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted

  @fail8
  Scenario: TC_008 Validate MTM Value when LTP is empty and updated before the next position update

    Given  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) |

    #this step is just added to give some time just after the instrument creation before update Market Data
    Then instance "[Inst_01.Symbol]" of entity "Instruments" should be
      | Instance ID  | Symbol           |
      | Inst_01_Res1 | [Inst_01.Symbol] |

    When instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

    And "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD1         | [Inst_01.Symbol] | AI   | 15.0  |

#    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
#      | Instance ID | symbol       | ai   |
#      | MD1_Res1    | [MD1.symbol] | 15.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol           | quantity | price | value | side  | participant          | notional | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [Inst_01.Symbol] | 10       | 60.0  | 450.0 | SHORT | [Acc_01.Participant] | 600      | CME    |

    Then "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | notional |
      | PosUpdate_01_Res2 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0          | 450.0      | -10.0       | -450.0   | 45.0     | [PosUpdate_01.account] | -150.0   | -600.0   |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD2         | [Inst_01.Symbol] | LTP  | 75.0  |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD2_res1    | [MD2.Symbol] | 75.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol           | quantity | price | value | side  | participant          | notional | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [Inst_01.Symbol] | 10       | 70.0  | 595.0 | SHORT | [Acc_01.Participant] | 700      | CME    |

    Then "Position" messages are filtered by "level,participant,account,notional" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | notional |
      | PosUpdate_02_Res2 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 20.0          | 1045.0     | -20.0       | -1045.0  | 52.25    | [PosUpdate_02.account] | -1800.0  | -1300.0  |

    Given instance "[Acc_01.Account Id] " of entity "Accounts" is deleted
#    Given instance "[Inst_01.Symbol]" of entity "Instruments" is deleted

  @fail9
  Scenario: TC_009 Validate MTM Value when AI is empty and updated

    Given  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD1         | [Inst_01.Symbol] | LTP  | 55.0  |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD1_Res1    | [MD1.symbol] | 55.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol           | quantity | price | value | side  | participant          | notional | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [Inst_01.Symbol] | 15       | 60.0  | 540.0 | SHORT | [Acc_01.Participant] | 900      | CME    |

    Then "Position" messages are filtered by "level,participant,account,avgPrice,mtmValue" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | notional |
      | PosUpdate_01_Res2 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 15.0          | 540.0      | -15.0       | -540.0   | 36.0     | [PosUpdate_01.account] | -825.0   | -900.0   |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD2         | [Inst_01.Symbol] | AI   | 3.0   |

#    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
#      | Instance ID | symbol       | ai  |
#      | MD1_Res1    | [MD1.symbol] | 3.0 |

    Then "Position" messages are filtered by "level,participant,account,shortPosition,mtmValue" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | notional |
      | PosUpdate_01_Res3 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 15.0          | 567.0      | -15.0       | -567.0   | 37.8     | [PosUpdate_01.account] | -870.0   | -900.0   |

    Given instance "[Acc_01.Account Id] " of entity "Accounts" is deleted
#    Given instance "[Inst_01.Symbol]" of entity "Instruments" is deleted

  @fail10
  Scenario: TC_010 Validate MTM Value when LTP is empty and updated

    Given  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD1         | [Inst_01.Symbol] | AI   | 5.0   |

#    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
#      | Instance ID | symbol       | ai  |
#      | MD1_Res1    | [MD1.symbol] | 5.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant          | notional |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 75.0  | 600.0 | SHORT | [Acc_01.Participant] | 750      |

    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | notional |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0          | 600.0      | -10.0       | -600.0   | 60.0     | [PosUpdate_01.account] | 100.0    | -750.0   |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | type | value |
      | MD3         | [MD1.symbol] | LTP  | 65.0  |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD3_Res1    | [MD3.symbol] | 65.0 |

    Then "Position" messages are filtered by "level,participant,account,shortPosition,shortValue" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | notional |
      | PosUpdate_01_Res2 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0          | 600.0      | -10.0       | -600.0   | 60.0     | [PosUpdate_01.account] | 1400.0   | -750.0   |

    Given instance "[Acc_01.Account Id] " of entity "Accounts" is deleted
    Given instance "[Inst_01.Symbol]" of entity "Instruments" is deleted

  @done
  Scenario: TC_011 Validate Realized MTM Value, Unrealized MTM Value, Unrealized MTM % when Long Position < Short Position , Long Position = Short Position  and Long Position > Short Position

    Given instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value | Instrument Type |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       | FIXED_RATE_BOND |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD1         | [Inst_01.Symbol] | LTP  | 100.0 |
      | MD2         | [Inst_01.Symbol] | AI   | 1.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp   |
      | MD1_Res1    | [MD1.symbol] | 100.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side | participant          | notional |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 819.0 | LONG | [Acc_01.Participant] | 900      |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0         | 819.0     | 10.0        | 819.0    | 81.9     | [PosUpdate_01.account] | 2020.0   | 0.0              | 1201.0             | 146.64                  | 900.0    |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant          | notional |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 5        | 80.0  | 320.0 | SHORT | [Acc_01.Participant] | 400      |

    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 5.0           | 324.0      | 10.0         | 819.0     | 5.0         | 495.0    | 99.0     | [PosUpdate_02.account] | 1010.0   | -85.5            | 515.0              | 104.04                  | 500.0    |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant          | notional |
      | PosUpdate_03 | [Acc_01.Account Id] | [MD1.symbol] | 5        | 80.0  | 320.0 | SHORT | [Acc_01.Participant] | 400      |

    Then "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional |
      | PosUpdate_03_Res1 | ACCOUNT | [PosUpdate_03.participant] | [PosUpdate_03.symbol] | 10.0          | 648.0      | 10.0         | 819.0     | 0.0         | 171.0    | 0.0      | [PosUpdate_03.account] | 0.0      | 171.0            | -171.0             | -100.0                  | 100.0    |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant          | notional |
      | PosUpdate_04 | [Acc_01.Account Id] | [MD1.symbol] | 5        | 80.0  | 324.0 | SHORT | [Acc_01.Participant] | 400      |

    Then "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | notional | unrealizedMtmPercentage |
      | PosUpdate_04_Res1 | ACCOUNT | [PosUpdate_04.participant] | [PosUpdate_04.symbol] | 15.0          | 972.0      | 10.0         | 819.0     | -5.0        | -153.0   | 30.6     | [PosUpdate_04.account] | -1010.0  | 171.0            | -857.0             | -300.0   | -560.13                 |

  @BRP-675
  Scenario: TC_012 Validate Priority of the Position Key applies ( For the accounts with multiple Keys -If specific key is available, then it applies. If not default Key applies)

    Given instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value | Instrument Type |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       | FIXED_RATE_BOND |

    And instance "FLR_BOND" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value | Instrument Type    | Coupon Benchmark |
      | Inst_02     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       | FLOATING_RATE_BOND | AJ-USD           |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_01,RZ_PT_PK_02 |

    Then instance "[Acc_01.Account Id]" of entity "Accounts" should be
      | Instance ID | Name          |
      | Acc_01_Res1 | [Acc_01.Name] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD1         | [Inst_01.Symbol] | LTP  | 100.0 |
      | MD2         | [Inst_01.Symbol] | AI   | 4.00  |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp   |
      | MD1_Res1    | [MD1.symbol] | 100.0 |

#    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
#      | Instance ID | symbol       | ai  |
#      | MD1_Res2    | [MD1.symbol] | 4.0 |

    Given "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD3         | [Inst_02.Symbol] | LTP  | 90.0  |
      | MD4         | [Inst_02.Symbol] | AI   | 1.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD3_Res1    | [MD3.symbol] | 90.0 |

#    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
#      | Instance ID | symbol       | ai  |
#      | MD3_Res2    | [MD3.symbol] | 1.0 |

        # added position for Market CME
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side | participant          | notional | currency | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | LONG | [Acc_01.Participant] | 900      | USD      | CME    |

    Then  "Position" messages are filtered by "level,participant,account,longPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | market                | positionKey |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0         | 846.0     | 10.0        | 846.0    | 84.6     | [PosUpdate_01.account] | 2080.0   | 0.0              | 1234.0             | 145.86                  | 900.0    | USD      | 36.0          | 4.0 | [PosUpdate_01.market] | RZ_PT_PK_01 |

    # added position for Market CCCAGG ( Seperate Position Created since RZ_PT_PK_01 is applicable )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant          | notional | currency | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 20       | 90.0  | 1692.0 | LONG | [Acc_01.Participant] | 1800     | USD      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | ai  | market                | positionKey |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 20.0         | 1692.0    | 20.0        | 1692.0   | 84.6     | [PosUpdate_02.account] | 4160.0   | 0.0              | 2468.0             | 145.86                  | 1800.0   | 72.0          | 4.0 | [PosUpdate_02.market] | RZ_PT_PK_01 |

    # added position for Market  CCCAGG ( Position is aggregated since RZ_PT_PK_01 is applicable )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant          | notional | currency | market |
      | PosUpdate_03 | [Acc_01.Account Id] | [MD1.symbol] | 20       | 90.0  | 1692.0 | LONG | [Acc_01.Participant] | 1800     | USD      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | ai  | market                | positionKey |
      | PosUpdate_03_Res1 | ACCOUNT | [PosUpdate_03.participant] | [PosUpdate_03.symbol] | 40.0         | 3384.0    | 40.0        | 3384.0   | 84.6     | [PosUpdate_03.account] | 8320.0   | 0.0              | 4936.0             | 145.86                  | 3600.0   | 144.0         | 4.0 | [PosUpdate_02.market] | RZ_PT_PK_01 |

    # added position for Market CME
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side | participant          | notional | currency | market |
      | PosUpdate_04 | [Acc_01.Account Id] | [MD3.symbol] | 10       | 90.0  | 819.0 | LONG | [Acc_01.Participant] | 900      | GBP      | CME    |

    Then  "Position" messages are filtered by "level,participant,account,symbol,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | market                | positionKey |
      | PosUpdate_04_Res1 | ACCOUNT | [PosUpdate_04.participant] | [PosUpdate_04.symbol] | 10.0         | 819.0     | 10.0        | 819.0    | 81.9     | [PosUpdate_04.account] | 1820.0   | 0.0              | 1001.0             | 122.22                  | 900.0    | 9.0           | [PosUpdate_04.market] | DEFAULT     |

    # added position for Market CCCAGG( Position is aggregated since Default Key is applicable )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant          | notional | currency | market |
      | PosUpdate_05 | [Acc_01.Account Id] | [MD3.symbol] | 20       | 90.0  | 1638.0 | LONG | [Acc_01.Participant] | 1800     | GBP      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,symbol,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | market | positionKey |
      | PosUpdate_05_Res1 | ACCOUNT | [PosUpdate_05.participant] | [PosUpdate_05.symbol] | 30.0         | 2457.0    | 30.0        | 2457.0   | 81.9     | [PosUpdate_05.account] | 5460.0   | 0.0              | 3003.0             | 122.22                  | 2700.0   | 27.0          |        | DEFAULT     |

  @done @key
  Scenario: TC_013 Validate Priority of the Position Key applies ( For the accounts with multiple Keys -If multiples keys eligible,priority will consider.)

    Given instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value | Instrument Type |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       | FIXED_RATE_BOND |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_03,RZ_PT_PK_02 |

    Given "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD1         | [Inst_01.Symbol] | LTP  | 100.0 |
      | MD2         | [Inst_01.Symbol] | AI   | 5.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp   |
      | MD1_Res1    | [MD1.symbol] | 100.0 |

#    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
#      | Instance ID | symbol       | ai  |
#      | MD1_Res2    | [MD1.symbol] | 5.0 |

    # added position with settlement data
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side | participant | notional | currency | settlementDate                | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | LONG | RZ-PT-01    | 900      | USD      | 2022-04-23T00:00:00.000+00:00 | CME    |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | settlementDate                | positionKey |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0         | 855.0     | 10.0        | 855.0    | 85.5     | [PosUpdate_01.account] | 2100.0   | 0.0              | 1245.0             | 145.61                  | 900.0    | USD      | 45.0          | 5.0 | [PosUpdate_01.settlementDate] | RZ_PT_PK_03 |

    # added position with same settlement Date (Position is aggregated since RZ_PT_PK_03 is applicable )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | settlementDate                | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1282.5 | LONG | RZ-PT-01    | 1350     | USD      | 2022-04-23T00:00:00.000+00:00 | CME    |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | ai  | settlementDate                | positionKey |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 25.0         | 2137.5    | 25.0        | 2137.5   | 85.5     | [PosUpdate_02.account] | 5250.0   | 0.0              | 3112.5             | 145.61                  | 2250.0   | 112.5         | 5.0 | [PosUpdate_02.settlementDate] | RZ_PT_PK_03 |

  @done @key
  Scenario: TC_014 Validate default Key applies if there is no eligible keys attached to the Account

    Given instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value | Instrument Type |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       | FIXED_RATE_BOND |

    And instance "FLR_BOND" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value | Instrument Type    | Coupon Benchmark |
      | Inst_02     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       | FLOATING_RATE_BOND | AJ-USD           |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_04      |

#    Then instance "[Acc_01.Account Id]" of entity "Accounts" should be
#      | Instance ID | Name          |
#      | Acc_01_Res1 | [Acc_01.Name] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD1         | [Inst_01.Symbol] | LTP  | 80.0  |
      | MD2         | [Inst_01.Symbol] | AI   | 5.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD1_Res1    | [MD1.symbol] | 80.0 |

#    And "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
#      | Instance ID | symbol       | ai  |
#      | MD1_Res2    | [MD1.symbol] | 5.0 |

     # added position
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side | participant | notional | currency | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | LONG | RZ-PT-01    | 900      | USD      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | positionKey |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0         | 855.0     | 10.0        | 855.0    | 85.5     | [PosUpdate_01.account] | 1700.0   | 0.0              | 845.0              | 98.83                   | 900.0    | USD      | 45.0          | 5.0 | DEFAULT     |

    # added position  with a different Markets(Position is aggregated since Default key is applicable )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1282.5 | LONG | RZ-PT-01    | 1350     | USD      | CME    |

#    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
#      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | ai  | market |
#      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 25.0         | 2137.5    | 25.0        | 2137.5   | 85.5     | [PosUpdate_02.account] | 4250.0   | 0.0              | 2112.5             | 98.83                   | 2250.0   | 112.5           | 5.0 |        |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD3         | [Inst_02.Symbol] | LTP  | 90.0  |
      | MD4         | [Inst_02.Symbol] | AI   | 5.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD3_Res1    | [MD3.symbol] | 90.0 |

#    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
#      | Instance ID | symbol       | ai  |
#      | MD4_Res1    | [MD4.symbol] | 5.0 |

       # added position  with Settlement Date
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side | participant | notional | currency | market | settlementDate                |
      | PosUpdate_04 | [Acc_01.Account Id] | [MD3.symbol] | 10       | 90.0  | 900.0 | LONG | RZ-PT-01    | 900      | GBP      | CME    | 2022-02-22T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,symbol,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | market                | settlementDate                | positionKey |
      | PosUpdate_04_Res1 | ACCOUNT | [PosUpdate_04.participant] | [PosUpdate_04.symbol] | 10.0         | 855.0     | 10.0        | 855.0    | 85.5     | [PosUpdate_04.account] | 1900.0   | 0.0              | 1045.0             | 122.22                  | 900.0    | 45.0          | [PosUpdate_04.market] | [PosUpdate_04.settlementDate] | RZ_PT_PK_04 |

    # added position with Different Settlement Date(  RZ_PT_PK_04 is applicable. New position created )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side | participant | notional | currency | market | settlementDate                |
      | PosUpdate_05 | [Acc_01.Account Id] | [MD3.symbol] | 15       | 90.0  | 900.0 | LONG | RZ-PT-01    | 900      | GBP      | CME    | 2022-06-23T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,symbol,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | market                | expiryDate                | positionKey |
      | PosUpdate_05_Res1 | ACCOUNT | [PosUpdate_05.participant] | [PosUpdate_05.symbol] | 10.0         | 1282.5    | 10.0        | 1282.5   | 85.5     | [PosUpdate_05.account] | 2850.0   | 0.0              | 1567.5             | 122.22                  | 1350.0   | 90.0          | [PosUpdate_05.market] | [PosUpdate_05.expiryDate] | RZ_PT_PK_04 |

  @done @key
  Scenario: TC_015 Validate Position Key of asset class is applied(FI and Equity)

    Given instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_01,RZ_PT_PK_06 |

    Then instance "[Acc_01.Account Id]" of entity "Accounts" should be
      | Instance ID | Name          |
      | Acc_01_Res1 | [Acc_01.Name] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD1         | [Inst_01.Symbol] | LTP  | 80.0  |
      | MD2         | [Inst_01.Symbol] | AI   | 5.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD1_Res1    | [MD1.symbol] | 80.0 |
#
#    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
#      | Instance ID | symbol       | ai  |
#      | MD1_Res2    | [MD1.symbol] | 5.0 |
#
      # Position update for Bond Instrument
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant          | notional | currency | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | SHORT | [Acc_01.Participant] | 900      | USD      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,symbol" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | positionKey |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0          | 855.0      | -10.0       | -855.0   | 85.5     | [PosUpdate_01.account] | -1700.0  | 0.0              | -845.0             | -98.83                  | -900.0   | USD      | -45.0         | 5.0 | RZ_PT_PK_01 |

    # Position update with Different Market-CME ( Seperate Position creates)
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant          | notional | currency | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1282.5 | LONG | [Acc_01.Participant] | 1350     | USD      | CME    |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | ai  | positionKey |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 15.0         | 1282.5    | 15.0        | 1282.5   | 85.5     | [PosUpdate_02.account] | 2550.0   | 0.0              | 1267.5             | 98.83                   | 1350.0   | 67.5          | 5.0 | RZ_PT_PK_01 |

    # Position update with Same Market-CCCAGG ( Aggregated position should be created)
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side  | participant          | notional | currency | market |
      | PosUpdate_03 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1282.5 | SHORT | [Acc_01.Participant] | 1350     | USD      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | ai  | positionKey |
      | PosUpdate_03_Res1 | ACCOUNT | [PosUpdate_03.participant] | [PosUpdate_03.symbol] | 25.0          | 2137.5     | -25.0       | -2137.5  | 85.5     | [PosUpdate_03.account] | -4250.0  | 0.0              | -2112.5            | -98.83                  | -2250.0  | -112.5        | 5.0 | RZ_PT_PK_01 |

    ## For Equity Instrument

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol | type | value |
      | MD3         | GOOG   | LTP  | 80.0  |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD3_Res1    | [MD3.symbol] | 80.0 |

    # Position update with Settlement Date
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol            | quantity | price | value | side  | participant          | currency | market | settlementDate                |
      | PosUpdate_05 | [Acc_01.Account Id] | [MD3_Res1.symbol] | 15       | 90.0  | 1350  | SHORT | [Acc_01.Participant] | GBP      | CME    | 2022-04-23T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,market" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | currency                | market                | settlementDate                | positionKey |
      | PosUpdate_05_Res1 | ACCOUNT | [PosUpdate_05.participant] | [PosUpdate_05.symbol] | 15.0          | 1350.0     | 0.0          | 0.0       | -15.0       | -1350.0  | 90.0     | [PosUpdate_05.account] | -1200.0  | 0.0              | 150.0              | 11.11                   | [PosUpdate_05.currency] | [PosUpdate_05.market] | [PosUpdate_05.settlementDate] | RZ_PT_PK_06 |

   # Position Update with Different Settlement Date (Seperate Position should be created.RZ_PT_PK_06 applied )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol            | quantity | price | value | side  | participant          | currency | market | settlementDate                |
      | PosUpdate_06 | [Acc_01.Account Id] | [MD3_Res1.symbol] | 25       | 90.0  | 2250  | SHORT | [Acc_01.Participant] | GBP      | CME    | 2022-04-13T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,market" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | currency                | market                | settlementDate                | positionKey |
      | PosUpdate_06_Res1 | ACCOUNT | [PosUpdate_06.participant] | [PosUpdate_06.symbol] | 25.0          | 2250.0     | 0.0          | 0.0       | -25.0       | -2250.0  | 90.0     | [PosUpdate_06.account] | -2000.0  | 0.0              | 250.0              | 11.11                   | [PosUpdate_06.currency] | [PosUpdate_06.market] | [PosUpdate_06.settlementDate] | RZ_PT_PK_06 |

    # Position Update with same Settlement Date ( Position should be aggregated .RZ_PT_PK_06 applied )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol            | quantity | price | value | side  | participant          | currency | market | settlementDate                |
      | PosUpdate_07 | [Acc_01.Account Id] | [MD3_Res1.symbol] | 15       | 90.0  | 1350  | SHORT | [Acc_01.Participant] | GBP      | CME    | 2022-04-13T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | currency                | market                | settlementDate                | positionKey |
      | PosUpdate_07_Res1 | ACCOUNT | [PosUpdate_07.participant] | [PosUpdate_07.symbol] | 40.0          | 3600.0     | 0.0          | 0.0       | -40.0       | -3600.0  | 90.0     | [PosUpdate_07.account] | -3200.0  | 0.0              | 400.0              | 11.11                   | [PosUpdate_07.currency] | [PosUpdate_07.market] | [PosUpdate_07.settlementDate] | RZ_PT_PK_06 |

  @BRP-674 @key
  Scenario: TC_016 Validate correct key applies when prioritized key is Inactive

    Given instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_08,RZ_PT_PK_02 |

    Then instance "[Acc_01.Account Id]" of entity "Accounts" should be
      | Instance ID | Name          |
      | Acc_01_Res1 | [Acc_01.Name] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD1         | [Inst_01.Symbol] | LTP  | 80.0  |
      | MD2         | [Inst_01.Symbol] | AI   | 5.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD1_Res1    | [MD1.symbol] | 80.0 |

#    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
#      | Instance ID | symbol       | ai  |
#      | MD1_Res2    | [MD1.symbol] | 5.0 |


   # added position  with market CCCAGG
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant | notional | currency | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | SHORT | RZ-PT-01    | 900      | USD      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | positionKey |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0          | 855.0      | -10.0       | -855.0   | 85.5     | [PosUpdate_01.account] | -1700.0  | 0.0              | -845.0             | -98.83                  | -900.0   | USD      | -45.0         | 5.0 | RZ_PT_PK_02 |

    # Position update with Different Market-CME ( Aggregated position should be created,RZ_PT_PK_02 applies)
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1350.0 | LONG | RZ-PT-01    | 1350     | USD      | CME    |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | ai  | positionKey | market |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 15.0         | 1282.5    | 5.0         | 427.5    | 85.5     | [PosUpdate_02.account] | 850.0    | 0.0              | 422.5              | 98.83                   | 450.0    | 22.5          | 5.0 | RZ_PT_PK_02 |        |

  @BRP-674 @key
  Scenario: TC_017 Validate Position Key Status Changes from INACTIVE to ACTIVE

    Given instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       |

    #set the Position Key- Inactive
    And instance "RZ_PT_PK_07" of entity "Position Keys" is updated with following values
      | Instance ID | Status   |
      | Update01    | INACTIVE |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_07,RZ_PT_PK_02 |

    Then instance "[Acc_01.Account Id]" of entity "Accounts" should be
      | Instance ID | Name          |
      | Acc_01_Res1 | [Acc_01.Name] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD1         | [Inst_01.Symbol] | LTP  | 80.0  |
      | MD2         | [Inst_01.Symbol] | AI   | 5.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD1_Res1    | [MD1.symbol] | 80.0 |

#    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
#      | Instance ID | symbol       | ai  |
#      | MD1_Res2    | [MD1.symbol] | 5.0 |

   # added position  with market CCCAGG
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant | notional | currency | market | settlementDate                |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | SHORT | RZ-PT-01    | 900      | USD      | CCCAGG | 2022-02-22T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | settlementDate                | positionKey |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0          | 855.0      | -10.0       | -855.0   | 85.5     | [PosUpdate_01.account] | -1700.0  | 0.0              | -845.0             | -98.83                  | -900.0   | USD      | -45.0         | 5.0 | [PosUpdate_01.settlementDate] | RZ_PT_PK_02 |

    # Position update with same Market-CME and Different Settlement Dates( Aggregated position should be created,RZ_PT_PK_02 applies)
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | market | settlementDate                |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1350.0 | LONG | RZ-PT-01    | 1350     | USD      | CCCAGG | 2022-03-22T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | ai  | market | positionKey | settlementDate |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 15.0         | 1282.5    | 5.0         | 427.5    | 85.5     | [PosUpdate_02.account] | 850.0    | 0.0              | 422.5              | 98.83                   | 450.0    | 22.5          | 5.0 | CCCAGG | RZ_PT_PK_02 |                |

    Given instance "RZ_PT_PK_07" of entity "Position Keys" is updated with following values
      | Instance ID | Status |
      | Update01    | ACTIVE |

      # added position  with market CCCAGG
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant | notional | currency | market | settlementDate                |
      | PosUpdate_03 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | SHORT | RZ-PT-01    | 900      | USD      | CCCAGG | 2022-02-22T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | settlementDate                | positionKey |
      | PosUpdate_03_Res1 | ACCOUNT | [PosUpdate_03.participant] | [PosUpdate_03.symbol] | 10.0          | 855.0      | -10.0       | -855.0   | 85.5     | [PosUpdate_03.account] | -1700.0  | 0.0              | -845.0             | -98.83                  | -900.0   | USD      | -45.0         | 5.0 | [PosUpdate_03.settlementDate] | RZ_PT_PK_07 |

    # Position update with same CCCAGG and Different Settlement Dates( New position should be created,RZ_PT_PK_07 applies)
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | market | settlementDate                |
      | PosUpdate_04 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1282.5 | LONG | RZ-PT-01    | 1350     | USD      | CCCAGG | 2022-03-22T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | ai  | market                | settlementDate                | positionKey |
      | PosUpdate_04_Res1 | ACCOUNT | [PosUpdate_04.participant] | [PosUpdate_04.symbol] | 15.0         | 1282.5    | 15.0        | 1282.5   | 85.5     | [PosUpdate_04.account] | 2550.0   | 0.0              | 1267.5             | 98.83                   | 1350.0   | 67.5          | 5.0 | [PosUpdate_04.market] | [PosUpdate_04.settlementDate] | RZ_PT_PK_07 |

     # Position update same Market CCCAGG and Same Settlement Date( Position should be aggregated,RZ_PT_PK_07 applies)
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | market | settlementDate                |
      | PosUpdate_05 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1282.5 | LONG | RZ-PT-01    | 1350     | USD      | CCCAGG | 2022-03-22T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | ai  | market                | settlementDate | positionKey |
      | PosUpdate_05_Res1 | ACCOUNT | [PosUpdate_05.participant] | [PosUpdate_04.symbol] | 30.0         | 2565.0    | 30.0        | 2565.0   | 85.5     | [PosUpdate_05.account] | 5100.0   | 0.0              | 2535.0             | 98.83                   | 2700.0   | 135.0         | 5.0 | [PosUpdate_04.market] |                | RZ_PT_PK_07 |

    #reset the Position Key
    Given instance "RZ_PT_PK_07" of entity "Position Keys" is updated with following values
      | Instance ID | Status   |
      | Update01    | INACTIVE |

  @done
  Scenario: TC_018 Validate Position Key with all applicable fields

    Given instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       |

    And instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value | Expiry Date |
      | Inst_02     | random(RZ_PT_Inst_Bond_,4) | 1               | 100       | 2023-06-07  |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_09      |

    Then instance "[Acc_01.Account Id]" of entity "Accounts" should be
      | Instance ID | Name          |
      | Acc_01_Res1 | [Acc_01.Name] |

    Given "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD1         | [Inst_01.Symbol] | LTP  | 95.0  |
      | MD2         | [Inst_01.Symbol] | AI   | 5.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD1_Res1    | [MD1.symbol] | 95.0 |

#    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
#      | Instance ID | symbol       | ai  |
#      | MD1_Res2    | [MD1.symbol] | 5.0 |


   #### added positions with  different markets (( Settlement Date,Trade Date, Expiry Date(Instrument ) are Same )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant | notional | currency | market | settlementDate                | tradeDate                     |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 855.0 | SHORT | RZ-PT-01    | 900      | USD      | CCCAGG | 2022-02-22T00:00:00.000+00:00 | 2022-02-22T00:00:00.000+00:00 |

    And "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant | notional | currency | market | settlementDate                | tradeDate                     |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 855.0 | SHORT | RZ-PT-01    | 900      | USD      | CME    | 2022-02-22T00:00:00.000+00:00 | 2022-02-22T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,market" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | settlementDate                | market                | tradeDate                | positionKey |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 10.0          | 855.0      | -10.0       | -855.0   | 85.5     | [PosUpdate_02.account] | -2000.0  | 0.0              | -1145.0            | -133.92                 | -900.0   | USD      | -45.0         | 5.0 | [PosUpdate_02.settlementDate] | [PosUpdate_02.market] | [PosUpdate_02.tradeDate] | RZ_PT_PK_09 |

    #### added positions with  different Trade Dates (( Settlement Date,Market, Expiry Date(Instrument ) are Same )

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant | notional | currency | market | settlementDate                | tradeDate                     |
      | PosUpdate_03 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 855.0 | SHORT | RZ-PT-01    | 900      | USD      | CCCAGG | 2022-02-22T00:00:00.000+00:00 | 2022-02-23T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,market,tradeDate" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | settlementDate                | market                | tradeDate                | positionKey |
      | PosUpdate_03_Res1 | ACCOUNT | [PosUpdate_03.participant] | [PosUpdate_03.symbol] | 10.0          | 855.0      | -10.0       | -855.0   | 85.5     | [PosUpdate_03.account] | -2000.0  | 0.0              | -1145.0            | -133.92                 | -900.0   | USD      | -45.0         | 5.0 | [PosUpdate_03.settlementDate] | [PosUpdate_03.market] | [PosUpdate_03.tradeDate] | RZ_PT_PK_09 |

    #### added positions with  different Settlement Dates (( Trade Date,Market, Expiry Date(Instrument ) are Same )

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant | notional | currency | market | settlementDate                | tradeDate                     |
      | PosUpdate_04 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 855.0 | SHORT | RZ-PT-01    | 900      | USD      | CCCAGG | 2022-02-23T00:00:00.000+00:00 | 2022-02-23T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,market,settlementDate" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | settlementDate                | market                | tradeDate                | positionKey |
      | PosUpdate_04_Res1 | ACCOUNT | [PosUpdate_04.participant] | [PosUpdate_04.symbol] | 10.0          | 855.0      | -10.0       | -855.0   | 85.5     | [PosUpdate_04.account] | -2000.0  | 0.0              | -1145.0            | -133.92                 | -900.0   | USD      | -45.0         | 5.0 | [PosUpdate_04.settlementDate] | [PosUpdate_04.market] | [PosUpdate_04.tradeDate] | RZ_PT_PK_09 |


    Given "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD3         | [Inst_02.Symbol] | LTP  | 95.0  |
      | MD4         | [Inst_02.Symbol] | AI   | 5.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD3_Res1    | [MD3.symbol] | 95.0 |

#    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
#      | Instance ID | symbol       | ai  |
#      | MD4_Res2    | [MD4.symbol] | 5.0 |

    #### added positions with  different Expiry Dates(Instrument) ( Trade Date,Market, Settlement Dates are Same )

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant | notional | currency | market | settlementDate                | tradeDate                     |
      | PosUpdate_05 | [Acc_01.Account Id] | [MD3.symbol] | 10       | 90.0  | 855.0 | SHORT | RZ-PT-01    | 900      | USD      | CCCAGG | 2022-02-23T00:00:00.000+00:00 | 2022-02-23T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,symbol,market" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | settlementDate                | market                | tradeDate                | expiryDate                    | positionKey |
      | PosUpdate_05_Res1 | ACCOUNT | [PosUpdate_05.participant] | [PosUpdate_05.symbol] | 10.0          | 855.0      | -10.0       | -855.0   | 85.5     | [PosUpdate_05.account] | -1000.0  | 0.0              | -145.0             | -16.96                  | -900.0   | USD      | -45.0         | 5.0 | [PosUpdate_05.settlementDate] | [PosUpdate_05.market] | [PosUpdate_05.tradeDate] | 2023-06-07T00:00:00.000+00:00 | RZ_PT_PK_09 |

      #### added positions with same properties ( Trade Date,Market, Settlement Dates , Expiry dates are Same )- position aggregates

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant | notional | currency | market | settlementDate                | tradeDate                     |
      | PosUpdate_06 | [Acc_01.Account Id] | [MD3.symbol] | 10       | 90.0  | 855.0 | SHORT | RZ-PT-01    | 900      | USD      | CCCAGG | 2022-02-23T00:00:00.000+00:00 | 2022-02-23T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,symbol,market" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | settlementDate                | market                | tradeDate                | expiryDate                    | positionKey |
      | PosUpdate_06_Res1 | ACCOUNT | [PosUpdate_06.participant] | [PosUpdate_06.symbol] | 20.0          | 1710.0     | -20.0       | -1710.0  | 85.5     | [PosUpdate_06.account] | -2000.0  | 0.0              | -290.0             | -16.96                  | -1800.0  | USD      | -90.0         | 5.0 | [PosUpdate_06.settlementDate] | [PosUpdate_06.market] | [PosUpdate_06.tradeDate] | 2023-06-07T00:00:00.000+00:00 | RZ_PT_PK_09 |

  @done
  Scenario: TC_019 Validate Last MD Update affected to Position Recalculation

    Given instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_IT_01      |

    Then instance "[Acc_01.Account Id]" of entity "Accounts" should be
      | Instance ID | Name          |
      | Acc_01_Res1 | [Acc_01.Name] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value | currency |
      | MD1         | [Inst_01.Symbol] | AI   | 2.0   | USD      |
      | MD2         | [Inst_01.Symbol] | LTP  | 45.0  | USD      |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD2_Res1    | [MD2.symbol] | 45.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side  | participant          | notional | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 60       | 50.0  | 1560.0 | SHORT | [Acc_01.Participant] | 3000     | CCCAGG |

    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 60.0          | 1560.0     | -60.0       | -1560.0  | 26.0     | [PosUpdate_01.account] | -3000.0  | -5640.0  | 0.0              | -4080.0            | -261.54                 | -60.0         | 2.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side  | participant          | notional | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 100      | 51.0  | 2703.0 | SHORT | [Acc_01.Participant] | 5100     | CCCAGG |

    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 160.0         | 4263.0     | -160.0      | -4263.0  | 26.64    | [PosUpdate_02.account] | -8100.0  | -15040.0 | 0.0              | -10777.0           | -252.8                  | -162.0        | 2.0 |

    # multiple LTP updates
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | type | value | currency |
      | MD3         | [MD1.symbol] | LTP  | 46.0  | USD      |
      | MD4         | [MD1.symbol] | LTP  | 47.0  | USD      |
      | MD5         | [MD1.symbol] | LTP  | 48.0  | USD      |
      | MD6         | [MD1.symbol] | LTP  | 49.0  | USD      |
      | MD7         | [MD1.symbol] | LTP  | 50.0  | USD      |
      | MD8         | [MD1.symbol] | LTP  | 51.0  | USD      |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD8_Res1    | [MD8.symbol] | 51.0 |

    # Position should be recalculated for the last LTP Update
    Then   "Position" messages are filtered by "level,participant,account,shortPosition,mtmValue" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | PosUpdate_02_Res2 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 160.0         | 4263.0     | -160.0      | -4263.0  | 26.64    | [PosUpdate_02.account] | -8100.0  | -16960.0 | 0.0              | -12697.0           | -297.84                 | -162.0        | 2.0 |

    And "Position History" messages are filtered by "positionId,shortPosition" should be
      | Instance ID   | participant          | account             | positionId                     | shortPosition | shortValue | netPosition | netValue | avgPrice | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | POS_History01 | [Acc_01.Participant] | [Acc_01.Account Id] | [PosUpdate_02_Res2.positionId] | 60.0          | 1560.0     | -60.0       | -1560.0  | 26.0     | -3000.0  | -5640.0  | 0.0              | -4080.0            | -261.54                 | -60.0         | 2.0 |

  @done
  Scenario: TC_020 Validate position will be calculated by market data from all venues regardless of the position venue

    Given instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_IT_01      |

    Then instance "[Acc_01.Account Id]" of entity "Accounts" should be
      | Instance ID | Name          |
      | Acc_01_Res1 | [Acc_01.Name] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value | currency | venue  |
      | MD1         | [Inst_01.Symbol] | AI   | 2.0   | USD      | CCCAGG |
      | MD2         | [Inst_01.Symbol] | LTP  | 45.0  | USD      | CCCAGG |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD2_Res1    | [MD2.symbol] | 45.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side  | participant          | notional | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 60       | 50.0  | 1560.0 | SHORT | [Acc_01.Participant] | 3000     | CCCAGG |

    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 60.0          | 1560.0     | -60.0       | -1560.0  | 26.0     | [PosUpdate_01.account] | -3000.0  | -5640.0  | 0.0              | -4080.0            | -261.54                 | -60.0         | 2.0 |

    #submit market data update for CME venue
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value | currency | venue |
      | MD3         | [Inst_01.Symbol] | LTP  | 55.0  | USD      | CME   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD3_Res1    | [MD2.symbol] | 55.0 |

    # position should be recalculated even if the market is different
    Then "Position" messages are filtered by "level,participant,account,shortPosition,accruedAmount,mtmValue" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | PosUpdate_01_Res2 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 60.0          | 1560.0     | -60.0       | -1560.0  | 26.0     | [PosUpdate_01.account] | -3000.0  | -6840.0  | 0.0              | -5280.0            | -338.46                 | -60.0         | 2.0 |

  @done
  Scenario: TC_021 Validate position calculation when instrument par value updated

    Given instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_IT_01      |

    Then instance "[Acc_01.Account Id]" of entity "Accounts" should be
      | Instance ID | Name          |
      | Acc_01_Res1 | [Acc_01.Name] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value | currency | venue  |
      | MD1         | [Inst_01.Symbol] | AI   | 2.0   | USD      | CCCAGG |
      | MD2         | [Inst_01.Symbol] | LTP  | 45.0  | USD      | CCCAGG |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD2_Res1    | [MD2.symbol] | 45.0 |

#    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
#      | Instance ID | symbol       | ai  |
#      | MD2_Res1    | [MD2.symbol] | 2.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side  | participant          | notional | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 60       | 50.0  | 1560.0 | SHORT | [Acc_01.Participant] | 3000     | CCCAGG |

    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 60.0          | 1560.0     | -60.0       | -1560.0  | 26.0     | [PosUpdate_01.account] | -3000.0  | -5640.0  | 0.0              | -4080.0            | -261.54                 | -60.0         | 2.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side  | participant          | notional | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 100      | 51.0  | 2703.0 | SHORT | [Acc_01.Participant] | 5100     | CCCAGG |

    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 160.0         | 4263.0     | -160.0      | -4263.0  | 26.64    | [PosUpdate_02.account] | -8100.0  | -15040.0 | 0.0              | -10777.0           | -252.8                  | -162.0        | 2.0 |

    When instance "[Inst_01.Symbol]" of entity "Instruments" is updated with following values
      | Instance ID | Par Value |
      | Updt_01     | 200       |

    Then instance "[Inst_01.Symbol]" of entity "Instruments" should be
      | Instance ID    | Par Value           |
      | Update_01_Res1 | [Updt_01.Par Value] |

    # Position should be recalculated for the PAR value update of the Instrument ( New PAR value is not applicable for already calculated Considerations )
    Then   "Position" messages are filtered by "level,participant,account,shortPosition,accruedAmount" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | PosUpdate_02_Res2 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 160.0         | 4263.0     | -160.0      | -4263.0  | 26.64    | [PosUpdate_02.account] | -8100.0  | -15040.0 | 0.0              | -10777.0           | -252.8                  | -81.0         | 2.0 |

    #Add another Position (New PAR value should be used for the Calculation)
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side  | participant          | notional | market |
      | PosUpdate_03 | [Acc_01.Account Id] | [MD1.symbol] | 100      | 51.0  | 2703.0 | SHORT | [Acc_01.Participant] | 5100     | CCCAGG |

    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | PosUpdate_03_Res1 | ACCOUNT | [PosUpdate_03.participant] | [PosUpdate_03.symbol] | 260.0         | 5614.5     | -260.0      | -5614.5  | 21.59    | [PosUpdate_03.account] | -13200.0 | -24440.0 | 0.0              | -18825.5           | -335.3                  | -132.0        | 2.0 |

    And "Position History" messages are filtered by "positionId,shortPosition" should be
      | Instance ID   | participant          | account             | positionId                     | shortPosition | shortValue | netPosition | netValue | avgPrice | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | POS_History01 | [Acc_01.Participant] | [Acc_01.Account Id] | [PosUpdate_03_Res1.positionId] | 60.0          | 1560.0     | -60.0       | -1560.0  | 26.0     | -3000.0  | -5640.0  | 0.0              | -4080.0            | -261.54                 | -60.0         | 2.0 |

    And "Position History" messages are filtered by "positionId,shortPosition" should be
      | Instance ID   | participant          | account             | positionId                     | shortPosition | shortValue | netPosition | netValue | avgPrice | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | POS_History02 | [Acc_01.Participant] | [Acc_01.Account Id] | [PosUpdate_03_Res1.positionId] | 160.0         | 4263.0     | -160.0      | -4263.0  | 26.64    | -8100.0  | -15040.0 | 0.0              | -10777.0           | -252.8                  | -81.0         | 2.0 |

  @InstrumentEdit
  Scenario: TC_022 Instrument Edit

    Given instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value | currency | venue  |
      | MD1         | [Inst_01.Symbol] | AI   | 2.0   | USD      | CCCAGG |
      | MD2         | [Inst_01.Symbol] | LTP  | 45.0  | USD      | CCCAGG |

    And instance "[Inst_01.Symbol]" of entity "Instruments" is updated with following values
      | Instance ID    | Size Multiplier |
      | Inst_Update_01 | 8               |

  @MD
  Scenario: AI update

    Given  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) |

    #this step is just added to give some time just after the instrument creation before update Market Data
    Then instance "[Inst_01.Symbol]" of entity "Instruments" should be
      | Instance ID  | Symbol           |
      | Inst_01_Res1 | [Inst_01.Symbol] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD1         | [Inst_01.Symbol] | LTP  | 15.0  |
      | MD1         | [Inst_01.Symbol] | AI   | 5.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  | ai  |
      | MD1_Res1    | [MD1.symbol] | 15.0 | 5.0 |

  @history
  Scenario: TC_23 History

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_IT_01      |

    And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol           | quantity | price | value  | side  | participant          | notional | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [Inst_01.Symbol] | 60       | 50.0  | 1500.0 | SHORT | [Acc_01.Participant] | 3000     | CCCAGG |

    And "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol           | quantity | price | value  | side  | participant          | notional | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [Inst_01.Symbol] | 60       | 50.0  | 1500.0 | SHORT | [Acc_01.Participant] | 3000     | CCCAGG |

    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  | positionId |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 120.0         | 3000.0     | -120.0      | -3000.0  | 25.0     | [PosUpdate_02.account] | -6000.0  | 0.0      | 0.0              | 3000.0             | 100.0                   | 0.0           | 0.0 | NOT_EMPTY  |

    And "Position History" messages are filtered by "positionId,notional" should be
      | Instance ID   | participant          | account             | positionId                     | shortPosition | shortValue | netPosition | netValue | avgPrice | notional |
      | POS_History01 | [Acc_01.Participant] | [Acc_01.Account Id] | [PosUpdate_02_Res1.positionId] | 60.0          | 1500.0     | -60.0       | -1500.0  | 25.0     | -3000.0  |
