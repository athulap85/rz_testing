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
  Scenario: TC_002 Validating Symbol for Floating Rate Bond

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_IT_01      |

    And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Instrument Type    | Symbol                     | Coupon Benchmark | Reset Frequency | Fixing Offset | Last Fixing Rate |
      | Inst_01     | FLOATING_RATE_BOND | random(RZ_PT_Inst_Bond_,4) | AJ-USD           | 1               | 1             | 1                |

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

  @fail8
  Scenario: TC_008 Validate MTM Value when LTP is empty and updated before the next position update

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_IT_01      |

    And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD1         | [Inst_01.Symbol] | AI   | 15.0  |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
      | Instance ID | symbol           | ai   |
      | MD1_Res1    | [MD1.symbol] | 15.0 |

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
#    Given instance "[Inst_01.Symbol]" of entity "Instruments" is deleted

  @fail9
  Scenario: TC_009 Validate MTM Value when AI is empty and updated

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_IT_01      |

    And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD1         | [Inst_01.Symbol] | LTP  | 55.0  |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD1_Res1    | [MD1.symbol] | 55.0 |

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

  @blocked
  Scenario: TC_010 Validate MTM Value when LTP is empty and updated

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_IT_01      |

    And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value |
      | MD1         | [Inst_01.Symbol] | AI   | 5.0   |
      | MD2         | [Inst_01.Symbol] | LTP  | 0.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
      | Instance ID | symbol       | ai  |
      | MD1_Res1    | [MD1.symbol] | 5.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant          | notional |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 75.0  | 600.0 | SHORT | [Acc_01.Participant] | 750      |

    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | notional |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0          | 600.0      | -10.0       | -600.0   | 60.0     | [PosUpdate_01.account] | 100.0    | 750.0    |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | type | value |
      | MD3         | [MD1.symbol] | LTP  | 65.0  |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD3_Res1    | [MD3.symbol] | 65.0 |

    Then "Position" messages are filtered by "level,participant,account,shortPosition,shortValue" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | notional |
      | PosUpdate_01_Res2 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0          | 600.0      | -10.0       | -600.0   | 60.0     | [PosUpdate_01.account] | 1400.0   | 750.0    |

    Given instance "[Acc_01.Account Id] " of entity "Accounts" is deleted
    Given instance "[Inst_01.Symbol]" of entity "Instruments" is deleted

  @FailedDuetoLastDecimal
    #"2022-06-14 19:32:37,215[comparators][INFO] Field [realizedMtmValue], Expected:Received [-85.5]:[-85.50000000000004]"
    #"2022-06-14 20:05:57,003[comparators][INFO] Field [realizedMtmValue], Expected:Received [171.0]:[171.00000000000009]"
    #"2022-06-14 20:09:03,265[comparators][INFO] Field [realizedMtmValue], Expected:Received [171.0]:[171.00000000000009]"

  Scenario: TC_011 Validate Realized MTM Value, Unrealized MTM Value, Unrealized MTM % when Long Position < Short Position , Long Position = Short Position  and Long Position > Short Position

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol               | type | value |
      | MD1         | RZ_PT_Inst_Bond_0031 | LTP  | 100.0 |
      | MD2         | RZ_PT_Inst_Bond_0031 | AI   | 1.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp   |
      | MD1_Res1    | [MD1.symbol] | 100.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side | participant          | notional |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 819.0 | LONG | [Acc_01.Participant] | 900      |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0         | 819.0     | 10.0        | 819.0    | 81.9     | [PosUpdate_01.account] | 2020.0   | 0.0              | 1201.0             | 146.64224664224662      | 900.0    |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant          | notional |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 5        | 80.0  | 320.0 | SHORT | [Acc_01.Participant] | 400      |

#    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
#      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional |
#      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 5.0           | 324.0      | 10.0         | 819.0     | 5.0         | 495.0    | 99.0     | [PosUpdate_02.account] | 1010.0   | -85.5            | 515.0              | 104.04040404040404              | 500.0    |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant          | notional |
      | PosUpdate_03 | [Acc_01.Account Id] | [MD1.symbol] | 5        | 80.0  | 320.0 | SHORT | [Acc_01.Participant] | 400      |
#
#    Then "Position" messages are filtered by "level,participant,account,netPosition" should be
#      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional |
#      | PosUpdate_03_Res1 | ACCOUNT | [PosUpdate_03.participant] | [PosUpdate_03.symbol] | 10.0          | 648.0      | 10.0         | 819.0     | 0.0         | 171.0    | 0.0      | [PosUpdate_03.account] | 0.0      | 171.0            | -171.0             | -100.0                  | 100.0    |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant          | notional |
      | PosUpdate_04 | [Acc_01.Account Id] | [MD1.symbol] | 5        | 80.0  | 324.0 | SHORT | [Acc_01.Participant] | 400      |

    Then "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | notional | unrealizedMtmPercentage |
      | PosUpdate_04_Res1 | ACCOUNT | [PosUpdate_04.participant] | [PosUpdate_04.symbol] | 15.0          | 972.0      | 10.0         | 819.0     | -5.0        | -153.0   | 30.6     | [PosUpdate_04.account] | -1010.0  | 171.0            | -857.0             | -300.0   | 560.130719              |

  @BRP-675
  Scenario: TC_012 Validate Priority of the Position Key applies ( For the accounts with multiple Keys -If specific key is available, then it applies. If not default Key applies)

    Given "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol              | type | value |
      | MD1         | RZ_PT_Inst_Bond_003 | LTP  | 100.0 |
      | MD2         | RZ_PT_Inst_Bond_003 | AI   | 4.00  |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp   |
      | MD1_Res1    | [MD1.symbol] | 100.0 |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
      | Instance ID | symbol       | ai  |
      | MD1_Res2    | [MD1.symbol] | 4.0 |

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_01,RZ_PT_PK_02 |
    # added position for Market CME
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side | participant          | notional | currency | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | LONG | [Acc_01.Participant] | 900      | USD      | CME    |

    Then  "Position" messages are filtered by "level,participant,account,longPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedInterest | ai  | market                | positionKey |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0         | 846.0     | 10.0        | 846.0    | 84.6     | [PosUpdate_01.account] | 2080.0   | 0.0              | 1234.0             | 145.8628841607565       | 900.0    | USD      | 36.0            | 4.0 | [PosUpdate_01.market] | RZ_PT_PK_01 |

    # added position for Market CCCAGG ( Seperate Position Created since RZ_PT_PK_01 is applicable )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant          | notional | currency | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 20       | 90.0  | 1692.0 | LONG | [Acc_01.Participant] | 1800     | USD      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | ai  | market                | positionKey |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 20.0         | 1692.0    | 20.0        | 1692.0   | 84.6     | [PosUpdate_02.account] | 4160.0   | 0.0              | 2468.0             | 145.8628841607565       | 1800.0   | 72.0            | 4.0 | [PosUpdate_02.market] | RZ_PT_PK_01 |

    # added position for Market  CCCAGG ( Position is aggregated since RZ_PT_PK_01 is applicable )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant          | notional | currency | market |
      | PosUpdate_03 | [Acc_01.Account Id] | [MD1.symbol] | 20       | 90.0  | 1692.0 | LONG | [Acc_01.Participant] | 1800     | USD      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | ai  | market                | positionKey |
      | PosUpdate_03_Res1 | ACCOUNT | [PosUpdate_03.participant] | [PosUpdate_03.symbol] | 40.0         | 3384.0    | 40.0        | 3384.0   | 84.6     | [PosUpdate_03.account] | 8320.0   | 0.0              | 4936.0             | 145.8628841607565       | 3600.0   | 144.0           | 4.0 | [PosUpdate_02.market] | RZ_PT_PK_01 |

    Given "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol              | type | value |
      | MD3         | RZ_PT_Inst_Bond_004 | LTP  | 90.0  |
      | MD4         | RZ_PT_Inst_Bond_004 | AI   | 1.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD3_Res1    | [MD3.symbol] | 90.0 |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
      | Instance ID | symbol       | ai  |
      | MD3_Res2    | [MD3.symbol] | 1.0 |

    # added position for Market CME
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side | participant          | notional | currency | market |
      | PosUpdate_04 | [Acc_01.Account Id] | [MD3.symbol] | 10       | 90.0  | 819.0 | LONG | [Acc_01.Participant] | 900      | GBP      | CME    |

    Then  "Position" messages are filtered by "level,participant,account,symbol" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | market                | positionKey |
      | PosUpdate_04_Res1 | ACCOUNT | [PosUpdate_04.participant] | [PosUpdate_04.symbol] | 10.0         | 819.0     | 10.0        | 819.0    | 81.9     | [PosUpdate_04.account] | 1820.0   | 0.0              | 1001.0             | 122.22222222222223      | 900.0    | 9.0             | [PosUpdate_04.market] | DEFAULT     |

    # added position for Market CCCAGG( Position is aggregated since Default Key is applicable )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant          | notional | currency | market |
      | PosUpdate_05 | [Acc_01.Account Id] | [MD3.symbol] | 20       | 90.0  | 1638.0 | LONG | [Acc_01.Participant] | 1800     | GBP      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,symbol,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | market | positionKey |
      | PosUpdate_05_Res1 | ACCOUNT | [PosUpdate_05.participant] | [PosUpdate_05.symbol] | 30.0         | 2457.0    | 30.0        | 2457.0   | 81.9     | [PosUpdate_05.account] | 5460.0   | 0.0              | 3003.0             | 122.22222222222223      | 2700.0   | 27.0            |        | DEFAULT     |

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

    # added position with settlement data
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side | participant | notional | currency | settlementDate                | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | LONG | RZ-PT-01    | 900      | USD      | 2022-04-23T00:00:00.000+00:00 | CME    |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedInterest | ai  | settlementDate                | positionKey |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0         | 855.0     | 10.0        | 855.0    | 85.5     | [PosUpdate_01.account] | 2100.0   | 0.0              | 1245.0             | 145.61403508771932      | 900.0    | USD      | 45.0            | 5.0 | [PosUpdate_01.settlementDate] | RZ_PT_PK_03 |

    # added position with same settlement Date (Position is aggregated since RZ_PT_PK_03 is applicable )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | settlementDate                | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1282.5 | LONG | RZ-PT-01    | 1350     | USD      | 2022-04-23T00:00:00.000+00:00 | CME    |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | ai  | settlementDate                | positionKey |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 25.0         | 2137.5    | 25.0        | 2137.5   | 85.5     | [PosUpdate_02.account] | 5250.0   | 0.0              | 3112.5             | 145.61403508771932      | 2250.0   | 112.5           | 5.0 | [PosUpdate_02.settlementDate] | RZ_PT_PK_03 |

  @BRP-675 @key
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

     # added position
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side | participant | notional | currency | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | LONG | RZ-PT-01    | 900      | USD      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedInterest | ai  |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0         | 855.0     | 10.0        | 855.0    | 85.5     | [PosUpdate_01.account] | 1700.0   | 0.0              | 845.0              | 98.83040935672514       | 900.0    | USD      | 45.0            | 5.0 |

    # added position  with a different Markets(Position is aggregated since Default key is applicable )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1282.5 | LONG | RZ-PT-01    | 1350     | USD      | CME    |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | ai  | market |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 25.0         | 2137.5    | 25.0        | 2137.5   | 85.5     | [PosUpdate_02.account] | 4250.0   | 0.0              | 2112.5             | 98.83040935672514       | 2250.0   | 112.5           | 5.0 |        |

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

       # added position  with Expiry date
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

  @done @key
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
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant          | notional | currency | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | SHORT | [Acc_01.Participant] | 900      | USD      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,symbol" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedInterest | ai  | positionKey |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0          | 855.0      | -10.0       | -855.0   | 85.5     | [PosUpdate_01.account] | -1700.0  | 0.0              | -845.0             | -98.83040935672514      | -900.0   | USD      | -45.0           | 5.0 | RZ_PT_PK_01 |

    # Position update with Different Market-CME ( Seperate Position creates)
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant          | notional | currency | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1282.5 | LONG | [Acc_01.Participant] | 1350     | USD      | CME    |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | ai  | positionKey |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 15.0         | 1282.5    | 15.0        | 1282.5   | 85.5     | [PosUpdate_02.account] | 2550.0   | 0.0              | 1267.5             | 98.83040935672514       | 1350.0   | 67.5            | 5.0 | RZ_PT_PK_01 |

    # Position update with Same Market-CCCAGG ( Aggregated position should be created)
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side  | participant          | notional | currency | market |
      | PosUpdate_03 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1282.5 | SHORT | [Acc_01.Participant] | 1350     | USD      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedInterest | ai  | positionKey |
      | PosUpdate_03_Res1 | ACCOUNT | [PosUpdate_03.participant] | [PosUpdate_03.symbol] | 25.0          | 2137.5     | -25.0       | -2137.5  | 85.5     | [PosUpdate_03.account] | -4250.0  | 0.0              | -2112.5            | -98.83040935672514      | -2250.0  | -112.5          | 5.0 | RZ_PT_PK_01 |

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
      | PosUpdate_05_Res1 | ACCOUNT | [PosUpdate_05.participant] | [PosUpdate_05.symbol] | 15.0          | 1350.0     | 0.0          | 0.0       | -15.0       | -1350.0  | 90.0     | [PosUpdate_05.account] | -1200.0  | 0.0              | 150.0              | 11.11111111111111       | [PosUpdate_05.currency] | [PosUpdate_05.market] | [PosUpdate_05.settlementDate] | RZ_PT_PK_06 |

   # Position Update with Different Settlement Date (Seperate Position should be created.RZ_PT_PK_06 applied )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol            | quantity | price | value | side  | participant          | currency | market | settlementDate                |
      | PosUpdate_06 | [Acc_01.Account Id] | [MD3_Res1.symbol] | 25       | 90.0  | 2250  | SHORT | [Acc_01.Participant] | GBP      | CME    | 2022-04-13T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,market" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | currency                | market                | settlementDate                | positionKey |
      | PosUpdate_06_Res1 | ACCOUNT | [PosUpdate_06.participant] | [PosUpdate_06.symbol] | 25.0          | 2250.0     | 0.0          | 0.0       | -25.0       | -2250.0  | 90.0     | [PosUpdate_06.account] | -2000.0  | 0.0              | 250.0              | 11.11111111111111       | [PosUpdate_06.currency] | [PosUpdate_06.market] | [PosUpdate_06.settlementDate] | RZ_PT_PK_06 |

    # Position Update with same Settlement Date ( Position should be aggregated .RZ_PT_PK_06 applied )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol            | quantity | price | value | side  | participant          | currency | market | settlementDate                |
      | PosUpdate_07 | [Acc_01.Account Id] | [MD3_Res1.symbol] | 15       | 90.0  | 1350  | SHORT | [Acc_01.Participant] | GBP      | CME    | 2022-04-13T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | currency                | market                | settlementDate                | positionKey |
      | PosUpdate_07_Res1 | ACCOUNT | [PosUpdate_07.participant] | [PosUpdate_07.symbol] | 40.0          | 3600.0     | 0.0          | 0.0       | -40.0       | -3600.0  | 90.0     | [PosUpdate_07.account] | -3200.0  | 0.0              | 400.0              | 11.11111111111111       | [PosUpdate_07.currency] | [PosUpdate_07.market] | [PosUpdate_07.settlementDate] | RZ_PT_PK_06 |

  @BRP-674 @key
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

   # added position  with market CCCAGG
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

  @BRP-674 @key
  Scenario: TC_017 Validate Position Key Status Changes from INACTIVE to ACTIVE

    Given "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol               | type | value |
      | MD1         | RZ_PT_Inst_Bond_0031 | LTP  | 80.0  |
      | MD2         | RZ_PT_Inst_Bond_0031 | AI   | 5.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD1_Res1    | [MD1.symbol] | 80.0 |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
      | Instance ID | symbol       | ai  |
      | MD1_Res2    | [MD1.symbol] | 5.0 |

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_07,RZ_PT_PK_02 |

   # added position  with market CCCAGG
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

      # added position  with market CCCAGG
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
      | Instance ID | Status   |
      | Update01    | INACTIVE |


  @MD
  Scenario: TC_018

    Given "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol              | type | value |
      | MD1         | RZ_PT_Inst_Bond_003 | LTP  | 8.0   |
      | MD2         | RZ_PT_Inst_Bond_003 | AI   | 5.0   |

  @Instrument
  Scenario: TC_003Instrument

    Given   instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                      | Currency |
      | Inst_01     | random(RZ_PT_Inst_Bond_1,5) | GBP      |


