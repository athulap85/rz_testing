Feature: Position Attributes

  @done
  Scenario: TC_001 Validating Position Key  and position id exists

    Given instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
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
  Scenario: TC_002 Validating Symbol for Floating Rate Bond with Minimum fields ( Matching with File Upload)

    Given instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

    And  instance "RZ-Base-Ins-Floating-01" of entity "Instruments" is copied with following values
      | Instance ID | Instrument Type    | Symbol                     | Coupon Benchmark | Reset Frequency | Fixing Offset | Last Fixing Rate | ISIN           | Coupon Spread |
      | Inst_01     | FLOATING_RATE_BOND | random(RZ_PT_Inst_Bond_,4) | RZ_ST_Rate2Y     | 1               | 1             | 1                | random(isin,6) | 1             |

    When "Position Update" messages are submitted with following values
      | Instance ID  | symbol           | side  | participant          | type   | account             | notional |
      | PosUpdate_01 | [Inst_01.Symbol] | SHORT | [Acc_01.Participant] | MARGIN | [Acc_01.Account Id] | 4800     |

    Then "Position" messages are filtered by "level,account,participant" should be
      | Instance ID       | symbol                | level   | account                | participant                | type   | positionKey |
      | PosUpdate_01_Res1 | [PosUpdate_01.symbol] | ACCOUNT | [PosUpdate_01.account] | [PosUpdate_01.participant] | MARGIN | NOT_EMPTY   |

    Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted
#    Given instance "[Inst_01.Symbol]" of entity "Instruments" is deleted

  @done
  Scenario: TC_003 Validating Currency ( Bonds with different currencies)

    Given instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

    And  instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
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

    Given instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

    When "Position Update" messages are submitted with following values
      | Instance ID  | symbol              | quantity | price | side  | participant          | type   | account             | notional | settlementDate                |
      | PosUpdate_01 | RZ_PT_Inst_Bond_001 | 1000     | 50.0  | SHORT | [Acc_01.Participant] | MARGIN | [Acc_01.Account Id] | 50000    | 2022-06-20T00:00:00.000+00:00 |

    Then "Position" messages are filtered by "level,account,participant,symbol" should be
      | Instance ID       | symbol                | level   | account                | participant                | type   | shortPosition | netPosition | settlementDate            |
      | PosUpdate_01_Res1 | [PosUpdate_01.symbol] | ACCOUNT | [PosUpdate_01.account] | [PosUpdate_01.participant] | MARGIN | 1000.0        | -1000.0     | Jun 20, 2022, 12:00:00 AM |

    Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted

  @done @removable
  Scenario: TC_005 Validating Markets ( Position Updates added with different Markets)

    Given instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
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

  @done @removable
  Scenario: TC_006 Validate Values in Long position ( longPosition,longValue, notional, average Price )

    Given instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol              | currency | ai  | ltp | dataClass |
      | MD1         | RZ_PT_Inst_Bond_001 | USD      | 2.0 | 5.0 | PRICE     |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ai  | ltp |
      | MD1_Res1    | [MD1.symbol] | 2.0 | 5.0 |

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
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 10000.0      | 3060.0    | 10000.0     | 3060.0   | [PosUpdate_02.account] | 0.31     | 46000.0  |

    Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted

  @done @removable
  Scenario: TC_007 Validate values in Short Position (shortPosition, shortValue, Average price, notional )

    Given  instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) |

    And instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

    Then instance "[Acc_01.Account Id]" of entity "Accounts" should be
      | Instance ID | Name          |
      | Acc_01_Res1 | [Acc_01.Name] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ai  | ltp  | dataClass |
      | MD1         | [Inst_01.Symbol] | USD      | 2.0 | 45.0 | PRICE     |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp,ai" should be
      | Instance ID | symbol       | ai  | ltp  |
      | MD1_Res1    | [MD1.symbol] | 2.0 | 45.0 |

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
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 1600.0        | 42630.0    | -1600.0     | -42630.0 | 26.64    | [PosUpdate_02.account] | -81000.0 |

    Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted

  @done
  Scenario: TC_008 Validate MTM Value when LTP is empty and updated before the next position update

    Given  instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) |

    #this step is just added to give some time just after the instrument creation before update Market Data
    Then instance "[Inst_01.Symbol]" of entity "Instruments" should be
      | Instance ID  | Symbol           |
      | Inst_01_Res1 | [Inst_01.Symbol] |

    When instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

    Then instance "[Acc_01.Account Id]" of entity "Accounts" should be
      | Instance ID | Name          |
      | Acc_01_Res1 | [Acc_01.Name] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ai   | ltp | dataClass |
      | MD1         | [Inst_01.Symbol] | USD      | 15.0 | 0   | PRICE     |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp,ai" should be
      | Instance ID | symbol       | ai   | ltp |
      | MD1_Res1    | [MD1.symbol] | 15.0 | 0.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol           | quantity | price | value | side  | participant          | notional | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [Inst_01.Symbol] | 10       | 60.0  | 450.0 | SHORT | [Acc_01.Participant] | 600      | CME    |

    Then "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | notional |
      | PosUpdate_01_Res2 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0          | 450.0      | -10.0       | -450.0   | 45.0     | [PosUpdate_01.account] | -90.0    | -600.0   |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ai   | ltp  | dataClass |
      | MD2         | [Inst_01.Symbol] | USD      | 15.0 | 75.0 | PRICE     |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp,ai" should be
      | Instance ID | symbol       | ai   | ltp  |
      | MD2_Res1    | [MD2.symbol] | 15.0 | 75.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol           | quantity | price | value | side  | participant          | notional | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [Inst_01.Symbol] | 10       | 70.0  | 595.0 | SHORT | [Acc_01.Participant] | 700      | CME    |

    Then "Position" messages are filtered by "level,participant,account,notional" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | notional |
      | PosUpdate_02_Res2 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 20.0          | 1045.0     | -20.0       | -1045.0  | 52.25    | [PosUpdate_02.account] | -1170.0  | -1300.0  |

  @done
  Scenario: TC_009 Validate MTM Value when AI is empty and updated

    Given  instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) |

    And instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ltp  | dataClass |
      | MD1         | [Inst_01.Symbol] | USD      | 55.0 | PRICE     |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD1_Res1    | [MD1.symbol] | 55.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol           | quantity | price | value | side  | participant          | notional | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [Inst_01.Symbol] | 15       | 60.0  | 540.0 | SHORT | [Acc_01.Participant] | 900      | CME    |

    Then "Position" messages are filtered by "level,participant,account,avgPrice,mtmValue" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | notional | accruedAmount |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 15.0          | 540.0      | -15.0       | -540.0   | 36.0     | [PosUpdate_01.account] | -495.0   | -900.0   | 0.0           |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ltp  | ai  | dataClass |
      | MD2         | [Inst_01.Symbol] | USD      | 55.0 | 3.0 | PRICE     |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp,ai" should be
      | Instance ID | symbol       | ltp  | ai  |
      | MD2_Res1    | [MD2.symbol] | 55.0 | 3.0 |

    Then "Position" messages are filtered by "level,participant,account,shortPosition,mtmValue" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | notional | accruedAmount |
      | PosUpdate_01_Res2 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 15.0          | 540.0      | -15.0       | -540.0   | 36.0     | [PosUpdate_01.account] | -522.0   | -900.0   | -27.0         |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol           | quantity | price | value | side | participant          | notional | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [Inst_01.Symbol] | 20       | 60.0  | 756.0 | LONG | [Acc_01.Participant] | 1200     | CME    |

    Then "Position" messages are filtered by "level,participant,account,longValue" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | account                | mtmValue | notional | accruedAmount |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 20.0         | 756.0     | 5.0         | 216.0    | [PosUpdate_02.account] | 174.0    | 300.0    | 9.0           |

  @done
  Scenario: TC_010 Validate MTM Value when LTP is empty and updated

    Given  instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) |

    And instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ai  | ltp | dataClass |
      | MD1         | [Inst_01.Symbol] | USD      | 5.0 | 0   | PRICE     |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp,ai" should be
      | Instance ID | symbol       | ai  | ltp |
      | MD1_Res1    | [MD1.symbol] | 5.0 | 0.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant          | notional |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 75.0  | 600.0 | SHORT | [Acc_01.Participant] | 750      |

    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | notional |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0          | 600.0      | -10.0       | -600.0   | 60.0     | [PosUpdate_01.account] | -37.5    | -750.0   |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ltp | dataClass |
      | MD1         | [Inst_01.Symbol] | USD      | 65  | PRICE     |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD1_Res1    | [MD1.symbol] | 65.0 |

    Then "Position" messages are filtered by "level,participant,account,shortPosition,shortValue" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | notional |
      | PosUpdate_01_Res2 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0          | 600.0      | -10.0       | -600.0   | 60.0     | [PosUpdate_01.account] | -525.0   | -750.0   |

  @done
  Scenario: TC_011 Validate Realized MTM Value, Unrealized MTM Value, Unrealized MTM % when Long Position < Short Position , Long Position = Short Position  and Long Position > Short Position

    Given instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value | Instrument Type |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       | FIXED_RATE_BOND |

    And instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ltp | ai | dataClass |
      | MD1         | [Inst_01.Symbol] | USD      | 100 | 1  | PRICE     |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp,ai" should be
      | Instance ID | symbol       | ltp   | ai  |
      | MD1_Res1    | [MD1.symbol] | 100.0 | 1.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side | participant          | notional |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 819.0 | LONG | [Acc_01.Participant] | 900      |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0         | 819.0     | 10.0        | 819.0    | 81.9     | [PosUpdate_01.account] | 1818.0   | 0.0              | 999.0              | 121.98                  | 900.0    |

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
      | PosUpdate_03_Res1 | ACCOUNT | [PosUpdate_03.participant] | [PosUpdate_03.symbol] | 10.0          | 648.0      | 10.0         | 819.0     | 0.0         | 171.0    | 0.0      | [PosUpdate_03.account] | 202.0    | 171.0            | 31.0               | 18.13                   | 100.0    |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant          | notional |
      | PosUpdate_04 | [Acc_01.Account Id] | [MD1.symbol] | 5        | 80.0  | 324.0 | SHORT | [Acc_01.Participant] | 400      |

    Then "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | notional | unrealizedMtmPercentage |
      | PosUpdate_04_Res1 | ACCOUNT | [PosUpdate_04.participant] | [PosUpdate_04.symbol] | 15.0          | 972.0      | 10.0         | 819.0     | -5.0        | -153.0   | 30.6     | [PosUpdate_04.account] | -606.0   | 171.0            | -453.0             | -300.0   | -296.08                 |

  @done
  Scenario: TC_012 Validate Priority of the Position Key applies ( For the accounts with multiple Keys -If specific key is available, then it applies. If not default Key applies)

    Given instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value | Instrument Type |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       | FIXED_RATE_BOND |

    And instance "RZ-Base-Ins-Floating-01" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value | Instrument Type    | Coupon Benchmark | ISIN                       | Reset Frequency | Coupon Spread | Interest In Arrears | Fixing Offset | Last Fixing Rate |
      | Inst_02     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       | FLOATING_RATE_BOND | RZ_ST_Rate2Y     | random(RZ_PT_Inst_Bond_,4) | 2               | 2             | Yes                 | 1             | 2                |

    And instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_01,RZ_PT_PK_02 |

    Then instance "[Acc_01.Account Id]" of entity "Accounts" should be
      | Instance ID | Name          |
      | Acc_01_Res1 | [Acc_01.Name] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ltp | ai | dataClass |
      | MD1         | [Inst_01.Symbol] | USD      | 100 | 4  | PRICE     |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp,ai" should be
      | Instance ID | symbol       | ltp   | ai  |
      | MD1_Res1    | [MD1.symbol] | 100.0 | 4.0 |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ltp | ai | dataClass |
      | MD2         | [Inst_02.Symbol] | USD      | 90  | 1  | PRICE     |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp,ai" should be
      | Instance ID | symbol       | ltp  | ai  |
      | MD2_Res1    | [MD2.symbol] | 90.0 | 1.0 |

        # added position for Market CME
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side | participant          | notional | currency | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | LONG | [Acc_01.Participant] | 900      | USD      | CME    |

    Then  "Position" messages are filtered by "level,participant,account,longPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | market                | positionKey |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0         | 846.0     | 10.0        | 846.0    | 84.6     | [PosUpdate_01.account] | 1872.0   | 0.0              | 1026.0             | 121.28                  | 900.0    | USD      | 36.0          | 4.0 | [PosUpdate_01.market] | RZ_PT_PK_01 |

    # added position for Market CCCAGG ( Seperate Position Created since RZ_PT_PK_01 is applicable )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant          | notional | currency | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 20       | 90.0  | 1692.0 | LONG | [Acc_01.Participant] | 1800     | USD      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | ai  | market                | positionKey |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 20.0         | 1692.0    | 20.0        | 1692.0   | 84.6     | [PosUpdate_02.account] | 3744.0   | 0.0              | 2052.0             | 121.28                  | 1800.0   | 72.0          | 4.0 | [PosUpdate_02.market] | RZ_PT_PK_01 |

    # added position for Market  CCCAGG ( Position is aggregated since RZ_PT_PK_01 is applicable )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant          | notional | currency | market |
      | PosUpdate_03 | [Acc_01.Account Id] | [MD1.symbol] | 20       | 90.0  | 1692.0 | LONG | [Acc_01.Participant] | 1800     | USD      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | ai  | market                | positionKey |
      | PosUpdate_03_Res1 | ACCOUNT | [PosUpdate_03.participant] | [PosUpdate_03.symbol] | 40.0         | 3384.0    | 40.0        | 3384.0   | 84.6     | [PosUpdate_03.account] | 7488.0   | 0.0              | 4104.0             | 121.28                  | 3600.0   | 144.0         | 4.0 | [PosUpdate_02.market] | RZ_PT_PK_01 |

    # added position for Market CME
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side | participant          | notional | currency | market |
      | PosUpdate_04 | [Acc_01.Account Id] | [MD2.symbol] | 10       | 90.0  | 819.0 | LONG | [Acc_01.Participant] | 900      | GBP      | CME    |

    Then  "Position" messages are filtered by "level,participant,account,symbol,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | market                | positionKey |
      | PosUpdate_04_Res1 | ACCOUNT | [PosUpdate_04.participant] | [PosUpdate_04.symbol] | 10.0         | 819.0     | 10.0        | 819.0    | 81.9     | [PosUpdate_04.account] | 1638.0   | 0.0              | 819.0              | 100.0                   | 900.0    | 9.0           | [PosUpdate_04.market] | DEFAULT     |

    # added position for Market CCCAGG( Position is aggregated since Default Key is applicable )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant          | notional | currency | market |
      | PosUpdate_05 | [Acc_01.Account Id] | [MD2.symbol] | 20       | 90.0  | 1638.0 | LONG | [Acc_01.Participant] | 1800     | GBP      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,symbol,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | positionKey |
      | PosUpdate_05_Res1 | ACCOUNT | [PosUpdate_05.participant] | [PosUpdate_05.symbol] | 30.0         | 2457.0    | 30.0        | 2457.0   | 81.9     | [PosUpdate_05.account] | 4914.0   | 0.0              | 2457.0             | 100.0                   | 2700.0   | 27.0          | DEFAULT     |

    ## Below 'market' field should be added into above step once BRP-675 is fixed

    # market |
    #        |

  @done @key
  Scenario: TC_013 Validate Priority of the Position Key applies ( For the accounts with multiple Keys -If multiples keys eligible,priority will consider.)

    Given instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value | Instrument Type |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       | FIXED_RATE_BOND |

    And instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_03,RZ_PT_PK_02 |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ltp | ai | dataClass |
      | MD1         | [Inst_01.Symbol] | USD      | 100 | 5  | PRICE     |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp,ai" should be
      | Instance ID | symbol       | ltp   | ai  |
      | MD1_Res1    | [MD1.symbol] | 100.0 | 5.0 |

    # added position with settlement data
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side | participant | notional | currency | settlementDate                | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | LONG | RZ-PT-01    | 900      | USD      | 2022-04-23T00:00:00.000+00:00 | CME    |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | positionKey |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0         | 855.0     | 10.0        | 855.0    | 85.5     | [PosUpdate_01.account] | 1890.0   | 0.0              | 1035.0             | 121.05                  | 900.0    | USD      | 45.0          | 5.0 | RZ_PT_PK_03 |

    # added position with same settlement Date (Position is aggregated since RZ_PT_PK_03 is applicable )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | settlementDate                | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1282.5 | LONG | RZ-PT-01    | 1350     | USD      | 2022-04-23T00:00:00.000+00:00 | CME    |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | ai  | positionKey |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 25.0         | 2137.5    | 25.0        | 2137.5   | 85.5     | [PosUpdate_02.account] | 4725.0   | 0.0              | 2587.5             | 121.05                  | 2250.0   | 112.5         | 5.0 | RZ_PT_PK_03 |

  @done @key
  Scenario: TC_014 Validate default Key applies if there is no eligible keys attached to the Account

    Given instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value | Instrument Type |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       | FIXED_RATE_BOND |

    And instance "RZ-Base-Ins-Floating-01" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value | Instrument Type    | Coupon Benchmark | ISIN           | Fixing Offset | Last Fixing Rate | ISIN                       | Reset Frequency | Coupon Spread | Interest In Arrears |
      | Inst_02     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       | FLOATING_RATE_BOND | RZ_ST_Rate2Y     | random(isin,6) | 1             | 1                | random(RZ_PT_Inst_Bond_,4) | 2               | 2             | Yes                 |

    And instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_04      |

    Then instance "[Acc_01.Account Id]" of entity "Accounts" should be
      | Instance ID | Name          |
      | Acc_01_Res1 | [Acc_01.Name] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ltp | ai | dataClass |
      | MD1         | [Inst_01.Symbol] | USD      | 80  | 5  | PRICE     |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp,ai" should be
      | Instance ID | symbol       | ltp  | ai  |
      | MD1_Res1    | [MD1.symbol] | 80.0 | 5.0 |

     # added position
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side | participant | notional | currency | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | LONG | RZ-PT-01    | 900      | USD      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | positionKey |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0         | 855.0     | 10.0        | 855.0    | 85.5     | [PosUpdate_01.account] | 1530.0   | 0.0              | 675.0              | 78.95                   | 900.0    | USD      | 45.0          | 5.0 | DEFAULT     |

    # added position  with a different Markets(Position is aggregated since Default key is applicable )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1282.5 | LONG | RZ-PT-01    | 1350     | USD      | CME    |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | ai  |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 25.0         | 2137.5    | 25.0        | 2137.5   | 85.5     | [PosUpdate_02.account] | 3825.0   | 0.0              | 1687.5             | 78.95                   | 2250.0   | 112.5         | 5.0 |

  ## Below 'market' field should be added into above step once BRP-675 is fixed

    # market |
    #        |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ltp | ai | dataClass |
      | MD2         | [Inst_02.Symbol] | USD      | 90  | 5  | PRICE     |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp,ai" should be
      | Instance ID | symbol       | ltp  | ai  |
      | MD2_Res1    | [MD2.symbol] | 90.0 | 5.0 |

       # added position  with Settlement Date
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side | participant | notional | currency | market | settlementDate                |
      | PosUpdate_04 | [Acc_01.Account Id] | [MD2.symbol] | 10       | 90.0  | 900.0 | LONG | RZ-PT-01    | 900      | GBP      | CME    | 2022-02-22T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,symbol,netPosition,settlementDate" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | market                | settlementDate            | positionKey |
      | PosUpdate_04_Res1 | ACCOUNT | [PosUpdate_04.participant] | [PosUpdate_04.symbol] | 10.0         | 855.0     | 10.0        | 855.0    | 85.5     | [PosUpdate_04.account] | 1710.0   | 0.0              | 855.0              | 100.0                   | 900.0    | 45.0          | [PosUpdate_04.market] | Feb 22, 2022, 12:00:00 AM | RZ_PT_PK_04 |

    # added position with Different Settlement Date(  RZ_PT_PK_04 is applicable. New position created )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | side | participant | notional | currency | market | settlementDate                |
      | PosUpdate_05 | [Acc_01.Account Id] | [MD2.symbol] | 15       | 90.0  | LONG | RZ-PT-01    | 1350     | GBP      | CME    | 2022-06-23T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,symbol,netPosition,settlementDate" should be

      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | market                | settlementDate            | positionKey |
      | PosUpdate_05_Res1 | ACCOUNT | [PosUpdate_05.participant] | [PosUpdate_05.symbol] | 15.0         | 1282.5    | 15.0        | 1282.5   | 85.5     | [PosUpdate_05.account] | 2565.0   | 0.0              | 1282.5             | 100.0                   | 1350.0   | 67.5          | [PosUpdate_05.market] | Jun 23, 2022, 12:00:00 AM | RZ_PT_PK_04 |

  @done @key
  Scenario: TC_015 Validate Position Key of asset class is applied(FI and Equity)

    Given instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       |

    And instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_01,RZ_PT_PK_06 |

    Then instance "[Acc_01.Account Id]" of entity "Accounts" should be
      | Instance ID | Name          |
      | Acc_01_Res1 | [Acc_01.Name] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ltp | ai | dataClass |
      | MD1         | [Inst_01.Symbol] | USD      | 80  | 5  | PRICE     |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp,ai" should be
      | Instance ID | symbol       | ltp  | ai  |
      | MD1_Res1    | [MD1.symbol] | 80.0 | 5.0 |

      # Position update for Bond Instrument
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant          | notional | currency | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | SHORT | [Acc_01.Participant] | 900      | USD      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,symbol" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | positionKey |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0          | 855.0      | -10.0       | -855.0   | 85.5     | [PosUpdate_01.account] | -1530.0  | 0.0              | -675.0             | -78.95                  | -900.0   | USD      | -45.0         | 5.0 | RZ_PT_PK_01 |

    # Position update with Different Market-CME ( Seperate Position creates)
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant          | notional | currency | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1282.5 | LONG | [Acc_01.Participant] | 1350     | USD      | CME    |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | ai  | positionKey |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 15.0         | 1282.5    | 15.0        | 1282.5   | 85.5     | [PosUpdate_02.account] | 2295.0   | 0.0              | 1012.5             | 78.95                   | 1350.0   | 67.5          | 5.0 | RZ_PT_PK_01 |

    # Position update with Same Market-CCCAGG ( Aggregated position should be created)
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side  | participant          | notional | currency | market |
      | PosUpdate_03 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1282.5 | SHORT | [Acc_01.Participant] | 1350     | USD      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | ai  | positionKey |
      | PosUpdate_03_Res1 | ACCOUNT | [PosUpdate_03.participant] | [PosUpdate_03.symbol] | 25.0          | 2137.5     | -25.0       | -2137.5  | 85.5     | [PosUpdate_03.account] | -3825.0  | 0.0              | -1687.5            | -78.95                  | -2250.0  | -112.5        | 5.0 | RZ_PT_PK_01 |

    ## For Equity Instrument

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol | currency | ltp | dataClass |
      | MD3         | GOOG   | USD      | 80  | PRICE     |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD3_Res1    | [MD3.symbol] | 80.0 |

    # Position update with Settlement Date
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol            | quantity | price | value | side  | participant          | currency | market | settlementDate                |
      | PosUpdate_05 | [Acc_01.Account Id] | [MD3_Res1.symbol] | 15       | 90.0  | 1350  | SHORT | [Acc_01.Participant] | GBP      | CME    | 2022-04-23T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,market" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | currency                | market                | settlementDate            | positionKey |
      | PosUpdate_05_Res1 | ACCOUNT | [PosUpdate_05.participant] | [PosUpdate_05.symbol] | 15.0          | 1350.0     | 0.0          | 0.0       | -15.0       | -1350.0  | 90.0     | [PosUpdate_05.account] | -1200.0  | 0.0              | 150.0              | 11.11                   | [PosUpdate_05.currency] | [PosUpdate_05.market] | Apr 23, 2022, 12:00:00 AM | RZ_PT_PK_06 |

   # Position Update with Different Settlement Date (Seperate Position should be created.RZ_PT_PK_06 applied )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol            | quantity | price | value | side  | participant          | currency | market | settlementDate                |
      | PosUpdate_06 | [Acc_01.Account Id] | [MD3_Res1.symbol] | 25       | 90.0  | 2250  | SHORT | [Acc_01.Participant] | GBP      | CME    | 2022-04-13T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,market" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | currency                | market                | settlementDate            | positionKey |
      | PosUpdate_06_Res1 | ACCOUNT | [PosUpdate_06.participant] | [PosUpdate_06.symbol] | 25.0          | 2250.0     | 0.0          | 0.0       | -25.0       | -2250.0  | 90.0     | [PosUpdate_06.account] | -2000.0  | 0.0              | 250.0              | 11.11                   | [PosUpdate_06.currency] | [PosUpdate_06.market] | Apr 13, 2022, 12:00:00 AM | RZ_PT_PK_06 |

    # Position Update with same Settlement Date ( Position should be aggregated .RZ_PT_PK_06 applied )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol            | quantity | price | value | side  | participant          | currency | market | settlementDate                |
      | PosUpdate_07 | [Acc_01.Account Id] | [MD3_Res1.symbol] | 15       | 90.0  | 1350  | SHORT | [Acc_01.Participant] | GBP      | CME    | 2022-04-13T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | currency                | market                | settlementDate            | positionKey |
      | PosUpdate_07_Res1 | ACCOUNT | [PosUpdate_07.participant] | [PosUpdate_07.symbol] | 40.0          | 3600.0     | 0.0          | 0.0       | -40.0       | -3600.0  | 90.0     | [PosUpdate_07.account] | -3200.0  | 0.0              | 400.0              | 11.11                   | [PosUpdate_07.currency] | [PosUpdate_07.market] | Apr 13, 2022, 12:00:00 AM | RZ_PT_PK_06 |

  @done
  Scenario: TC_016 Validate correct key applies when prioritized key is Inactive

    Given instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       |

    And instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_08,RZ_PT_PK_02 |

    Then instance "[Acc_01.Account Id]" of entity "Accounts" should be
      | Instance ID | Name          |
      | Acc_01_Res1 | [Acc_01.Name] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ltp | ai | dataClass |
      | MD1         | [Inst_01.Symbol] | USD      | 80  | 5  | PRICE     |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp,ai" should be
      | Instance ID | symbol       | ltp  | ai  |
      | MD1_Res1    | [MD1.symbol] | 80.0 | 5.0 |

   # added position  with market CCCAGG
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant | notional | currency | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | SHORT | RZ-PT-01    | 900      | USD      | CCCAGG |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | positionKey |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0          | 855.0      | -10.0       | -855.0   | 85.5     | [PosUpdate_01.account] | -1530.0  | 0.0              | -675.0             | -78.95                  | -900.0   | USD      | -45.0         | 5.0 | RZ_PT_PK_02 |

    # Position update with Different Market-CME ( Aggregated position should be created,RZ_PT_PK_02 applies)
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1350.0 | LONG | RZ-PT-01    | 1350     | USD      | CME    |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | ai  | positionKey |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 15.0         | 1282.5    | 5.0         | 427.5    | 85.5     | [PosUpdate_02.account] | 765.0    | 0.0              | 337.5              | 78.95                   | 450.0    | 22.5          | 5.0 | RZ_PT_PK_02 |

    ## Below 'market' field should be added into above step once BRP-675 is fixed

    # market |
    #        |
  @done @key
  Scenario: TC_017 Validate Position Key Status Changes from INACTIVE to ACTIVE

    Given instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       |

    #set the Position Key- Inactive
    And instance "RZ_PT_PK_07" of entity "Position Keys" is updated with following values
      | Instance ID | Status   |
      | Update01    | INACTIVE |

    And instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_07,RZ_PT_PK_02 |

    Then instance "[Acc_01.Account Id]" of entity "Accounts" should be
      | Instance ID | Name          |
      | Acc_01_Res1 | [Acc_01.Name] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ltp | ai | dataClass |
      | MD1         | [Inst_01.Symbol] | USD      | 80  | 5  | PRICE     |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp,ai" should be
      | Instance ID | symbol       | ltp  | ai  |
      | MD1_Res1    | [MD1.symbol] | 80.0 | 5.0 |


   # added position  with market CCCAGG
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant | notional | currency | market | settlementDate                |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | SHORT | RZ-PT-01    | 900      | USD      | CCCAGG | 2022-02-22T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | settlementDate            | positionKey |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 10.0          | 855.0      | -10.0       | -855.0   | 85.5     | [PosUpdate_01.account] | -1530.0  | 0.0              | -675.0             | -78.95                  | -900.0   | USD      | -45.0         | 5.0 | Feb 22, 2022, 12:00:00 AM | RZ_PT_PK_02 |

    # Position update with same Market-CME and Different Settlement Dates( Aggregated position should be created,RZ_PT_PK_02 applies)
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | market | settlementDate                |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1350.0 | LONG | RZ-PT-01    | 1350     | USD      | CCCAGG | 2022-03-22T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | ai  | market | positionKey |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 15.0         | 1282.5    | 5.0         | 427.5    | 85.5     | [PosUpdate_02.account] | 765.0    | 0.0              | 337.5              | 78.95                   | 450.0    | 22.5          | 5.0 | CCCAGG | RZ_PT_PK_02 |

   ## Below 'settlementDate' field should be added into above step once RISK-698 is fixed
    # settlementDate  |
    #        |

    Given instance "RZ_PT_PK_07" of entity "Position Keys" is updated with following values
      | Instance ID | Status |
      | Update01    | ACTIVE |

      # added position  with market CCCAGG
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant | notional | currency | market | settlementDate                |
      | PosUpdate_03 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 900.0 | SHORT | RZ-PT-01    | 900      | USD      | CCCAGG | 2022-02-22T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | settlementDate            | positionKey |
      | PosUpdate_03_Res1 | ACCOUNT | [PosUpdate_03.participant] | [PosUpdate_03.symbol] | 10.0          | 855.0      | -10.0       | -855.0   | 85.5     | [PosUpdate_03.account] | -1530.0  | 0.0              | -675.0             | -78.95                  | -900.0   | USD      | -45.0         | 5.0 | Feb 22, 2022, 12:00:00 AM | RZ_PT_PK_07 |

    # Position update with same CCCAGG and Different Settlement Dates( New position should be created,RZ_PT_PK_07 applies)
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | market | settlementDate                |
      | PosUpdate_04 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1282.5 | LONG | RZ-PT-01    | 1350     | USD      | CCCAGG | 2022-03-22T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | ai  | market                | settlementDate            | positionKey |
      | PosUpdate_04_Res1 | ACCOUNT | [PosUpdate_04.participant] | [PosUpdate_04.symbol] | 15.0         | 1282.5    | 15.0        | 1282.5   | 85.5     | [PosUpdate_04.account] | 2295.0   | 0.0              | 1012.5             | 78.95                   | 1350.0   | 67.5          | 5.0 | [PosUpdate_04.market] | Mar 22, 2022, 12:00:00 AM | RZ_PT_PK_07 |

     # Position update same Market CCCAGG and Same Settlement Date( Position should be aggregated,RZ_PT_PK_07 applies)
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant | notional | currency | market | settlementDate                |
      | PosUpdate_05 | [Acc_01.Account Id] | [MD1.symbol] | 15       | 90.0  | 1282.5 | LONG | RZ-PT-01    | 1350     | USD      | CCCAGG | 2022-03-22T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | accruedAmount | ai  | market                | positionKey |
      | PosUpdate_05_Res1 | ACCOUNT | [PosUpdate_05.participant] | [PosUpdate_04.symbol] | 30.0         | 2565.0    | 30.0        | 2565.0   | 85.5     | [PosUpdate_05.account] | 4590.0   | 0.0              | 2025.0             | 78.95                   | 2700.0   | 135.0         | 5.0 | [PosUpdate_04.market] | RZ_PT_PK_07 |

     ## Below 'settlementDate' field should be added into above step once RISK-698 is fixed
    # settlementDate  |
    #        |

    #reset the Position Key
    Given instance "RZ_PT_PK_07" of entity "Position Keys" is updated with following values
      | Instance ID | Status   |
      | Update01    | INACTIVE |

  @done
  Scenario: TC_018 Validate Position Key with all applicable fields

    Given instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       |

    And instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value | Expiry Date |
      | Inst_02     | random(RZ_PT_Inst_Bond_,4) | 1               | 100       | 2023-06-07  |

    And instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Type   | Account Currency | Category | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acc-,4) | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_09      |

    Then instance "[Acc_01.Account Id]" of entity "Accounts" should be
      | Instance ID | Name          |
      | Acc_01_Res1 | [Acc_01.Name] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ltp | ai | dataClass |
      | MD1         | [Inst_01.Symbol] | USD      | 95  | 5  | PRICE     |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp,ai" should be
      | Instance ID | symbol       | ltp  | ai  |
      | MD1_Res1    | [MD1.symbol] | 95.0 | 5.0 |

   #### added positions with  different markets (( Settlement Date,Trade Date, Expiry Date(Instrument ) are Same )
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant | notional | currency | market | settlementDate                | tradeDate                     |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 855.0 | SHORT | RZ-PT-01    | 900      | USD      | CCCAGG | 2022-02-22T00:00:00.000+00:00 | 2022-02-22T00:00:00.000+00:00 |

    And "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant | notional | currency | market | settlementDate                | tradeDate                     |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 855.0 | SHORT | RZ-PT-01    | 900      | USD      | CME    | 2022-02-22T00:00:00.000+00:00 | 2022-02-22T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,market,settlementDate,tradeDate" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | settlementDate            | market                | tradeDate                 | positionKey |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 10.0          | 855.0      | -10.0       | -855.0   | 85.5     | [PosUpdate_02.account] | -1800.0  | 0.0              | -945.0             | -110.53                 | -900.0   | USD      | -45.0         | 5.0 | Feb 22, 2022, 12:00:00 AM | [PosUpdate_02.market] | Feb 22, 2022, 12:00:00 AM | RZ_PT_PK_09 |

    #### added positions with  different Trade Dates (( Settlement Date,Market, Expiry Date(Instrument ) are Same )

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant | notional | currency | market | settlementDate                | tradeDate                     |
      | PosUpdate_03 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 855.0 | SHORT | RZ-PT-01    | 900      | USD      | CCCAGG | 2022-02-22T00:00:00.000+00:00 | 2022-02-23T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,market,tradeDate,settlementDate" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | settlementDate            | market                | tradeDate                 | positionKey |
      | PosUpdate_03_Res1 | ACCOUNT | [PosUpdate_03.participant] | [PosUpdate_03.symbol] | 10.0          | 855.0      | -10.0       | -855.0   | 85.5     | [PosUpdate_03.account] | -1800.0  | 0.0              | -945.0             | -110.53                 | -900.0   | USD      | -45.0         | 5.0 | Feb 22, 2022, 12:00:00 AM | [PosUpdate_03.market] | Feb 23, 2022, 12:00:00 AM | RZ_PT_PK_09 |

    #### added positions with  different Settlement Dates (( Trade Date,Market, Expiry Date(Instrument ) are Same )

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant | notional | currency | market | settlementDate                | tradeDate                     |
      | PosUpdate_04 | [Acc_01.Account Id] | [MD1.symbol] | 10       | 90.0  | 855.0 | SHORT | RZ-PT-01    | 900      | USD      | CCCAGG | 2022-02-23T00:00:00.000+00:00 | 2022-02-23T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,market,settlementDate,tradeDate" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | settlementDate            | market                | tradeDate                 | positionKey |
      | PosUpdate_04_Res1 | ACCOUNT | [PosUpdate_04.participant] | [PosUpdate_04.symbol] | 10.0          | 855.0      | -10.0       | -855.0   | 85.5     | [PosUpdate_04.account] | -1800.0  | 0.0              | -945.0             | -110.53                 | -900.0   | USD      | -45.0         | 5.0 | Feb 23, 2022, 12:00:00 AM | [PosUpdate_04.market] | Feb 23, 2022, 12:00:00 AM | RZ_PT_PK_09 |


    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ltp | ai | dataClass |
      | MD2         | [Inst_02.Symbol] | USD      | 95  | 5  | PRICE     |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp,ai" should be
      | Instance ID | symbol       | ltp  | ai  |
      | MD2_Res1    | [MD2.symbol] | 95.0 | 5.0 |

    #### added positions with  different Expiry Dates(Instrument) ( Trade Date,Market, Settlement Dates are Same )

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant | notional | currency | market | settlementDate                | tradeDate                     |
      | PosUpdate_05 | [Acc_01.Account Id] | [MD2.symbol] | 10       | 90.0  | 855.0 | SHORT | RZ-PT-01    | 900      | USD      | CCCAGG | 2022-02-23T00:00:00.000+00:00 | 2022-02-23T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,symbol,market,settlementDate,tradeDate" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | settlementDate            | market                | tradeDate                 | expiryDate  | positionKey |
      | PosUpdate_05_Res1 | ACCOUNT | [PosUpdate_05.participant] | [PosUpdate_05.symbol] | 10.0          | 855.0      | -10.0       | -855.0   | 85.5     | [PosUpdate_05.account] | -900.0   | 0.0              | -45.0              | -5.26                   | -900.0   | USD      | -45.0         | 5.0 | Feb 23, 2022, 12:00:00 AM | [PosUpdate_05.market] | Feb 23, 2022, 12:00:00 AM | Jun 7, 2023 | RZ_PT_PK_09 |

      #### added positions with same properties ( Trade Date,Market, Settlement Dates , Expiry dates are Same )- position aggregates

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value | side  | participant | notional | currency | market | settlementDate                | tradeDate                     |
      | PosUpdate_06 | [Acc_01.Account Id] | [MD2.symbol] | 10       | 90.0  | 855.0 | SHORT | RZ-PT-01    | 900      | USD      | CCCAGG | 2022-02-23T00:00:00.000+00:00 | 2022-02-23T00:00:00.000+00:00 |

    Then  "Position" messages are filtered by "level,participant,account,netPosition,symbol,market,settlementDate,tradeDate" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | notional | currency | accruedAmount | ai  | settlementDate            | market                | tradeDate                 | expiryDate  | positionKey |
      | PosUpdate_06_Res1 | ACCOUNT | [PosUpdate_06.participant] | [PosUpdate_06.symbol] | 20.0          | 1710.0     | -20.0       | -1710.0  | 85.5     | [PosUpdate_06.account] | -1800.0  | 0.0              | -90.0              | -5.26                   | -1800.0  | USD      | -90.0         | 5.0 | Feb 23, 2022, 12:00:00 AM | [PosUpdate_06.market] | Feb 23, 2022, 12:00:00 AM | Jun 7, 2023 | RZ_PT_PK_09 |

  @done
  Scenario: TC_019 Validate Last MD Update affected to Position Recalculation

    Given instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       |

    And instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

    Then instance "[Acc_01.Account Id]" of entity "Accounts" should be
      | Instance ID | Name          |
      | Acc_01_Res1 | [Acc_01.Name] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ltp | ai | dataClass |
      | MD1         | [Inst_01.Symbol] | USD      | 45  | 2  | PRICE     |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp,ai" should be
      | Instance ID | symbol       | ltp  | ai  |
      | MD1_Res1    | [MD1.symbol] | 45.0 | 2.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side  | participant          | notional | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 60       | 50.0  | 1560.0 | SHORT | [Acc_01.Participant] | 3000     | CCCAGG |

    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 60.0          | 1560.0     | -60.0       | -1560.0  | 26.0     | [PosUpdate_01.account] | -3000.0  | -2820.0  | 0.0              | -1260.0            | -80.77                  | -60.0         | 2.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side  | participant          | notional | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 100      | 51.0  | 2703.0 | SHORT | [Acc_01.Participant] | 5100     | CCCAGG |

    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 160.0         | 4263.0     | -160.0      | -4263.0  | 26.64    | [PosUpdate_02.account] | -8100.0  | -7614.0  | 0.0              | -3351.0            | -78.61                  | -162.0        | 2.0 |

    # multiple LTP updates
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | ltp  | currency | dataClass |
      | MD3         | [MD1.symbol] | 46.0 | USD      | PRICE     |
      | MD4         | [MD1.symbol] | 47.0 | USD      | PRICE     |
      | MD5         | [MD1.symbol] | 48.0 | USD      | PRICE     |
      | MD6         | [MD1.symbol] | 49.0 | USD      | PRICE     |
      | MD7         | [MD1.symbol] | 50.0 | USD      | PRICE     |
      | MD8         | [MD1.symbol] | 51.0 | USD      | PRICE     |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD8_Res1    | [MD8.symbol] | 51.0 |

    # Position should be recalculated for the last LTP Update
    Then   "Position" messages are filtered by "level,participant,account,shortPosition,mtmValue" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | PosUpdate_02_Res2 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 160.0         | 4263.0     | -160.0      | -4263.0  | 26.64    | [PosUpdate_02.account] | -8100.0  | -8586.0  | 0.0              | -4323.0            | -101.41                 | -162.0        | 2.0 |

    And "Position History" messages are filtered by "positionId,shortPosition" should be
      | Instance ID   | participant          | account             | positionId                     | shortPosition | shortValue | netPosition | netValue | avgPrice | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | POS_History01 | [Acc_01.Participant] | [Acc_01.Account Id] | [PosUpdate_02_Res2.positionId] | 60.0          | 1560.0     | -60.0       | -1560.0  | 26.0     | -3000.0  | -2820.0  | 0.0              | -1260.0            | -80.77                  | -60.0         | 2.0 |

  @done
  Scenario: TC_020 Validate position will be calculated by market data from all venues regardless of the position venue

    Given instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       |

    And instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

    Then instance "[Acc_01.Account Id]" of entity "Accounts" should be
      | Instance ID | Name          |
      | Acc_01_Res1 | [Acc_01.Name] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ltp | ai | dataClass |venue  |
      | MD1         | [Inst_01.Symbol] | USD      | 45  | 2  | PRICE     |CCCAGG |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp,ai" should be
      | Instance ID | symbol       | ltp  | ai  |
      | MD1_Res1    | [MD1.symbol] | 45.0 | 2.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side  | participant          | notional | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 60       | 50.0  | 1560.0 | SHORT | [Acc_01.Participant] | 3000     | CCCAGG |

    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 60.0          | 1560.0     | -60.0       | -1560.0  | 26.0     | [PosUpdate_01.account] | -3000.0  | -2820.0  | 0.0              | -1260.0            | -80.77                  | -60.0         | 2.0 |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ltp | dataClass |venue  |
      | MD1         | [Inst_01.Symbol] | USD      | 55  | PRICE     |CME |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD1_Res1    | [MD1.symbol] | 55.0 |

    # position should be recalculated even if the market is different
    Then "Position" messages are filtered by "level,participant,account,shortPosition,accruedAmount,mtmValue" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | PosUpdate_01_Res2 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 60.0          | 1560.0     | -60.0       | -1560.0  | 26.0     | [PosUpdate_01.account] | -3000.0  | -3420.0  | 0.0              | -1860.0            | -119.23                 | -60.0         | 2.0 |

  @done
  Scenario: TC_021 Validate position calculation when instrument par value updated

    Given instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       |

    And instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

    Then instance "[Acc_01.Account Id]" of entity "Accounts" should be
      | Instance ID | Name          |
      | Acc_01_Res1 | [Acc_01.Name] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ltp | ai | dataClass |venue  |
      | MD1         | [Inst_01.Symbol] | USD      | 45  | 2  | PRICE     |CCCAGG |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp,ai" should be
      | Instance ID | symbol       | ltp  | ai  |
      | MD1_Res1    | [MD1.symbol] | 45.0 | 2.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side  | participant          | notional | market |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 60       | 50.0  | 1560.0 | SHORT | [Acc_01.Participant] | 3000     | CCCAGG |

    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 60.0          | 1560.0     | -60.0       | -1560.0  | 26.0     | [PosUpdate_01.account] | -3000.0  | -2820.0  | 0.0              | -1260.0            | -80.77                  | -60.0         | 2.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side  | participant          | notional | market |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 100      | 51.0  | 2703.0 | SHORT | [Acc_01.Participant] | 5100     | CCCAGG |

    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 160.0         | 4263.0     | -160.0      | -4263.0  | 26.64    | [PosUpdate_02.account] | -8100.0  | -7614.0  | 0.0              | -3351.0            | -78.61                  | -162.0        | 2.0 |

    When instance "[Inst_01.Symbol]" of entity "Instruments" is updated with following values
      | Instance ID | Par Value |
      | Updt_01     | 200       |

    Then instance "[Inst_01.Symbol]" of entity "Instruments" should be
      | Instance ID    | Par Value           |
      | Update_01_Res1 | [Updt_01.Par Value] |

    # Position should be recalculated for the PAR value update of the Instrument ( New PAR value is not applicable for already calculated Considerations )
    Then   "Position" messages are filtered by "level,participant,account,shortPosition,accruedAmount" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | PosUpdate_02_Res2 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 160.0         | 4263.0     | -160.0      | -4263.0  | 26.64    | [PosUpdate_02.account] | -8100.0  | -3807.0  | 0.0              | 456.0              | 10.7                    | -81.0         | 2.0 |

    #Add another Position (New PAR value should be used for the Calculation)
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side  | participant          | notional | market |
      | PosUpdate_03 | [Acc_01.Account Id] | [MD1.symbol] | 100      | 51.0  | 2703.0 | SHORT | [Acc_01.Participant] | 5100     | CCCAGG |

    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | PosUpdate_03_Res1 | ACCOUNT | [PosUpdate_03.participant] | [PosUpdate_03.symbol] | 260.0         | 5614.5     | -260.0      | -5614.5  | 21.59    | [PosUpdate_03.account] | -13200.0 | -6204.0  | 0.0              | -589.5             | -10.5                   | -132.0        | 2.0 |

    And "Position History" messages are filtered by "positionId,shortPosition" should be
      | Instance ID   | participant          | account             | positionId                     | shortPosition | shortValue | netPosition | netValue | avgPrice | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | POS_History01 | [Acc_01.Participant] | [Acc_01.Account Id] | [PosUpdate_03_Res1.positionId] | 60.0          | 1560.0     | -60.0       | -1560.0  | 26.0     | -3000.0  | -2820.0  | 0.0              | -1260.0            | -80.77                  | -60.0         | 2.0 |

    And "Position History" messages are filtered by "positionId,shortPosition" should be
      | Instance ID   | participant          | account             | positionId                     | shortPosition | shortValue | netPosition | netValue | avgPrice | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  |
      | POS_History02 | [Acc_01.Participant] | [Acc_01.Account Id] | [PosUpdate_03_Res1.positionId] | 160.0         | 4263.0     | -160.0      | -4263.0  | 26.64    | -8100.0  | -3807.0  | 0.0              | 456.0              | 10.7                    | -81.0         | 2.0 |

  @done @BRP-412
  Scenario: TC_022 -BRP-412 Submit Position updates to make settled position for Short and Long positions of the Same Account

    Given instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       |

    And instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

    Then instance "[Acc_01.Account Id]" of entity "Accounts" should be
      | Instance ID | Name          |
      | Acc_01_Res1 | [Acc_01.Name] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ltp | ai | dataClass |venue  |
      | MD1         | [Inst_01.Symbol] | USD      | 45  | 2  | PRICE     |CCCAGG |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp,ai" should be
      | Instance ID | symbol       | ltp  | ai  |
      | MD1_Res1    | [MD1.symbol] | 45.0 | 2.0 |

    # Create Settlement Position for One Account
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side  | participant          | notional | market | positionKey | type       | settlementStatus | settlementDate                |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 60       | 50.0  | 1560.0 | SHORT | [Acc_01.Participant] | 3000     | CCCAGG | RZ_PT_IT_01 | SETTLEMENT | OPEN             | 2022-06-23T00:00:00.000+00:00 |

    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | account                | type                | settlementStatus                | settlementDate            |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 60.0          | 1560.0     | -60.0       | -1560.0  | [PosUpdate_01.account] | [PosUpdate_01.type] | [PosUpdate_01.settlementStatus] | Jun 23, 2022, 12:00:00 AM |

    # Create Settlement Position for the same Account as settlement Position and both should be settled
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant          | notional | market | positionKey | type       | settlementStatus | settlementDate                |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 60       | 50.0  | 1560.0 | LONG | [Acc_01.Participant] | 3000     | CCCAGG | RZ_PT_IT_01 | SETTLEMENT | SETTLED          | 2022-06-23T00:00:00.000+00:00 |

    Then "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | longPosition | longValue | netPosition | netValue | avgPrice | account                | type                | settlementStatus                | settlementDate            |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 60.0          | 1560.0     | 60.0         | 1560.0    | 0.0         | 0.0      | 0.0      | [PosUpdate_02.account] | [PosUpdate_02.type] | [PosUpdate_02.settlementStatus] | Jun 23, 2022, 12:00:00 AM |

    And "Position History" messages are filtered by "positionId,shortPosition" should be
      | Instance ID   | participant          | account             | positionId                     | shortPosition | shortValue | netPosition | netValue | avgPrice | settlementStatus                |
      | POS_History02 | [Acc_01.Participant] | [Acc_01.Account Id] | [PosUpdate_02_Res1.positionId] | 60.0          | 1560.0     | -60.0       | -1560.0  | 26.0     | [PosUpdate_01.settlementStatus] |

  @done @BRP-412
  Scenario: TC_023 -BRP-412 Submit Position updates to make settled position for Short and Long positions for an account has Settlement Date in Position Key( Zero coupon Bond)

    Given instance "RZ-Base-Ins-ZeroCoupon-01" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value | ISIN          |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       | random(001,4) |

    And instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_03      |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ltp | ai | dataClass |venue  |
      | MD1         | [Inst_01.Symbol] | USD      | 45  | 2  | PRICE     |CCCAGG |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp,ai" should be
      | Instance ID | symbol       | ltp  | ai  |
      | MD1_Res1    | [MD1.symbol] | 45.0 | 2.0 |

    # Create Settlement Position with Status OPEN
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side  | participant          | notional | market | type       | settlementDate                | settlementStatus |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 60       | 50.0  | 1560.0 | SHORT | [Acc_01.Participant] | 3000     | CCCAGG | SETTLEMENT | 2022-06-23T00:00:00.000+00:00 | OPEN             |

    Then "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | account                | type                | settlementDate            | settlementStatus                |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 60.0          | 1560.0     | -60.0       | -1560.0  | [PosUpdate_01.account] | [PosUpdate_01.type] | Jun 23, 2022, 12:00:00 AM | [PosUpdate_01.settlementStatus] |

   # Create Settlement Position with Status SETTLED with different Settlement Date. New Position created
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant          | notional | market | type       | settlementDate                | settlementStatus |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 60       | 50.0  | 1560.0 | LONG | [Acc_01.Participant] | 3000     | CCCAGG | SETTLEMENT | 2022-06-24T00:00:00.000+00:00 | SETTLED          |

    Then "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | account                | type                | settlementDate            | settlementStatus                |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 60.0         | 1560.0    | 60.0        | 1560.0   | [PosUpdate_02.account] | [PosUpdate_02.type] | Jun 24, 2022, 12:00:00 AM | [PosUpdate_02.settlementStatus] |

    # Create Settlement Position with Status SETTLED with Same Settlement Date. Position aggregated
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant          | notional | market | type       | settlementDate                | settlementStatus |
      | PosUpdate_03 | [Acc_01.Account Id] | [MD1.symbol] | 60       | 50.0  | 1560.0 | LONG | [Acc_01.Participant] | 3000     | CCCAGG | SETTLEMENT | 2022-06-23T00:00:00.000+00:00 | SETTLED          |

    Then "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | netPosition | netValue | account                | type                | settlementDate            | settlementStatus                |
      | PosUpdate_03_Res1 | ACCOUNT | [PosUpdate_03.participant] | [PosUpdate_03.symbol] | 0.0         | 0.0      | [PosUpdate_03.account] | [PosUpdate_03.type] | Jun 23, 2022, 12:00:00 AM | [PosUpdate_03.settlementStatus] |

  @done @BRP-412
  Scenario: TC_024 -BRP-412 Submit Position updates to make settled position for Short and Long positions for an account which has not included the Settlement Date in Position Key

    Given instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 100       |

    And instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01      |

     When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | currency | ltp | ai | dataClass |venue  |
      | MD1         | [Inst_01.Symbol] | USD      | 45  | 2  | PRICE     |CCCAGG |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp,ai" should be
      | Instance ID | symbol       | ltp  | ai  |
      | MD1_Res1    | [MD1.symbol] | 45.0 | 2.0 |

    # Create Settlement Position with Status OPEN
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side  | participant          | notional | market | type       | settlementDate                | settlementStatus |
      | PosUpdate_01 | [Acc_01.Account Id] | [MD1.symbol] | 60       | 50.0  | 1560.0 | SHORT | [Acc_01.Participant] | 3000     | CCCAGG | SETTLEMENT | 2022-06-23T00:00:00.000+00:00 | OPEN             |

    Then "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | account                | type                | settlementDate            | settlementStatus                |
      | PosUpdate_01_Res1 | ACCOUNT | [PosUpdate_01.participant] | [PosUpdate_01.symbol] | 60.0          | 1560.0     | -60.0       | -1560.0  | [PosUpdate_01.account] | [PosUpdate_01.type] | Jun 23, 2022, 12:00:00 AM | [PosUpdate_01.settlementStatus] |

   # Create Settlement Position with Status SETTLED with different Settlement Date.Position aggregated
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol       | quantity | price | value  | side | participant          | notional | market | type       | settlementDate                | settlementStatus |
      | PosUpdate_02 | [Acc_01.Account Id] | [MD1.symbol] | 60       | 50.0  | 1560.0 | LONG | [Acc_01.Participant] | 3000     | CCCAGG | SETTLEMENT | 2022-06-24T00:00:00.000+00:00 | SETTLED          |

    Then "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | longPosition | longValue | netPosition | netValue | account                | type                | settlementDate            | settlementStatus                |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 60.0         | 1560.0    | 0.0         | 0.0      | [PosUpdate_02.account] | [PosUpdate_02.type] | Jun 24, 2022, 12:00:00 AM | [PosUpdate_02.settlementStatus] |

    And "Position History" messages are filtered by "positionId,shortPosition" should be
      | Instance ID   | participant          | account             | positionId                     | shortPosition | shortValue | netPosition | netValue | avgPrice | settlementDate            | settlementStatus                |
      | POS_History02 | [Acc_01.Participant] | [Acc_01.Account Id] | [PosUpdate_02_Res1.positionId] | 60.0          | 1560.0     | -60.0       | -1560.0  | 26.0     | Jun 23, 2022, 12:00:00 AM | [PosUpdate_01.settlementStatus] |

  @done25 @BRP-636
  Scenario: TC_025 - BRP-636 Submit Position updates for different types of bond instruments where account has position keys for the specific bond types

     # Create Fixed Rate Bond
    Given instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value |
      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               | 200       |

    Then instance "[Inst_01.Symbol]" of entity "Instruments" should be
      | Instance ID  | Symbol           |
      | Inst_01.Res1 | [Inst_01.Symbol] |

    # Create Floating Rate Bond
    Given instance "RZ-Base-Ins-Floating-01" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value | Coupon Benchmark |
      | Inst_02     | random(RZ_PT_Inst_Bond_,4) | 2               | 200       | RZ_ST_Rate2Y     |

    Then instance "[Inst_02.Symbol]" of entity "Instruments" should be
      | Instance ID  | Symbol           |
      | Inst_02.Res1 | [Inst_02.Symbol] |

    # Create Zero Coupon Bond
    Given instance "ZCBond-Test" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value |
      | Inst_03     | random(RZ_PT_Inst_Bond_,4) | 2               | 200       |

    Then instance "[Inst_03.Symbol]" of entity "Instruments" should be
      | Instance ID  | Symbol           |
      | Inst_03.Res1 | [Inst_03.Symbol] |

    # Create STEPPED_COUPON_BOND
    And instance "SteppedBond1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol                     | Size Multiplier | Par Value |
      | Inst_04     | random(RZ_PT_Inst_Bond_,4) | 2               | 200       |

    When instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids                                |
      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_01,RZ_PT_PK_04,RZ_PT_PK_10,RZ_PT_PK_11 |

    Then instance "[Acc_01.Account Id]" of entity "Accounts" should be
      | Instance ID | Name          |
      | Acc_01_Res1 | [Acc_01.Name] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol           | type | value | currency |
      | MD1         | [Inst_01.Symbol] | AI   | 3.0   | USD      |
      | MD2         | [Inst_02.Symbol] | AI   | 3.0   | USD      |
      | MD3         | [Inst_03.Symbol] | AI   | 3.0   | USD      |
      | MD4         | Stepped-Bond-hnk | AI   | 3.0   | USD      |
      | MD5         | [Inst_01.Symbol] | LTP  | 90.0  | USD      |
      | MD6         | [Inst_02.Symbol] | LTP  | 90.0  | USD      |
      | MD7         | [Inst_03.Symbol] | LTP  | 90.0  | USD      |
      | MD8         | Stepped-Bond-hnk | LTP  | 90.0  | USD      |
      | MD9         | [Inst_01.Symbol] | DV01 | 10.0  | USD      |
      | MD10        | [Inst_02.Symbol] | DV01 | 10.0  | USD      |
      | MD11        | [Inst_03.Symbol] | DV01 | 10.0  | USD      |
      | MD12        | Stepped-Bond-hnk | DV01 | 10.0  | USD      |

    Then response of the request "MD1" should be
      | Instance ID |
      | MD1_Res01   |

    Then "Realtime Risk Factor Update" messages are filtered by "id" should be
      | Instance ID | id             | status |
      | MD1_Req01   | [MD1_Res01.id] | POSTED |

    Then response of the request "MD2" should be
      | Instance ID |
      | MD2_Res01   |

    Then "Realtime Risk Factor Update" messages are filtered by "id" should be
      | Instance ID | id             | status |
      | MD2_Req01   | [MD2_Res01.id] | POSTED |

    Then response of the request "MD3" should be
      | Instance ID |
      | MD3_Res01   |

    Then "Realtime Risk Factor Update" messages are filtered by "id" should be
      | Instance ID | id             | status |
      | MD3_Req01   | [MD3_Res01.id] | POSTED |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD1_Res1    | [MD1.symbol] | 90.0 |

    And "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD2_Res1    | [MD2.symbol] | 90.0 |

    And "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD3_Res1    | [MD3.symbol] | 90.0 |

    ##Create Positions for Floating Rate Bond. RZ_PT_PK_04 applied
    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol           | quantity | price | value  | side  | participant          | notional | market | type   | settlementDate                |
      | PosUpdate_01 | [Acc_01.Account Id] | [Inst_02.Symbol] | 60       | 80.0  | 3984.0 | SHORT | [Acc_01.Participant] | 4800     | CCCAGG | MARGIN | 2022-07-24T00:00:00.000+00:00 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol           | quantity | price | value | side  | participant          | notional | market | type   | settlementDate                |
      | PosUpdate_02 | [Acc_01.Account Id] | [Inst_02.Symbol] | 10       | 80.0  | 332.0 | SHORT | [Acc_01.Participant] | 800      | CCCAGG | MARGIN | 2022-08-24T00:00:00.000+00:00 |

    Then "Position" messages are filtered by "level,participant,account,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | netPosition | netValue | account                | type                | settlementDate                | positionKey |
      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | -10.0       | -332.0   | [PosUpdate_02.account] | [PosUpdate_02.type] | [PosUpdate_02.settlementDate] | RZ_PT_PK_04 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol           | quantity | price | value | side  | participant          | notional | market | type   | settlementDate                |
      | PosUpdate_03 | [Acc_01.Account Id] | [Inst_02.Symbol] | 10       | 80.0  | 332.0 | SHORT | [Acc_01.Participant] | 800      | CME    | MARGIN | 2022-08-24T00:00:00.000+00:00 |

    Then "Position" messages are filtered by "level,participant,account,symbol,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | netPosition | netValue | account                | positionKey |
      | PosUpdate_03_Res1 | ACCOUNT | [PosUpdate_03.participant] | [PosUpdate_03.symbol] | -20.0       | -664.0   | [PosUpdate_03.account] | RZ_PT_PK_04 |

      ##Create Positions for Zero Coupon Bond. RZ_PT_PK_11 applied

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol           | quantity | price | value  | side  | participant          | notional | market | type       | settlementDate                |
      | PosUpdate_04 | [Acc_01.Account Id] | [Inst_03.Symbol] | 60       | 80.0  | 3984.0 | SHORT | [Acc_01.Participant] | 4800     | CCCAGG | SETTLEMENT | 2022-07-24T00:00:00.000+00:00 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol           | quantity | price | value | side  | participant          | notional | market | type       | settlementDate                |
      | PosUpdate_05 | [Acc_01.Account Id] | [Inst_03.Symbol] | 10       | 80.0  | 332.0 | SHORT | [Acc_01.Participant] | 800      | CCCAGG | SETTLEMENT | 2022-08-24T00:00:00.000+00:00 |

#    Then "Position" messages are filtered by "level,participant,account,symbol,netPosition" should be
#      | Instance ID       | level   | participant                | symbol                | netPosition | netValue | account                | type                | settlementDate                | positionKey |
#      | PosUpdate_05_Res1 | ACCOUNT | [PosUpdate_05.participant] | [PosUpdate_05.symbol] | -10.0       | -332.0   | [PosUpdate_05.account] | [PosUpdate_05.type] | [PosUpdate_05.settlementDate] | RZ_PT_PK_11 |

       ##Create Positions for Stepped Bond. RZ_PT_PK_10 applied

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol           | quantity | price | value  | side  | participant          | notional | market | type       | settlementDate                |
      | PosUpdate_06 | [Acc_01.Account Id] | Stepped-Bond-hnk | 60       | 80.0  | 3984.0 | SHORT | [Acc_01.Participant] | 4800     | CCCAGG | SETTLEMENT | 2022-07-24T00:00:00.000+00:00 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account             | symbol           | quantity | price | value | side  | participant          | notional | market | type       | settlementDate                |
      | PosUpdate_07 | [Acc_01.Account Id] | Stepped-Bond-hnk | 10       | 80.0  | 332.0 | SHORT | [Acc_01.Participant] | 800      | CCCAGG | SETTLEMENT | 2022-08-24T00:00:00.000+00:00 |

    Then "Position" messages are filtered by "level,participant,account,symbol,netPosition" should be
      | Instance ID       | level   | participant                | symbol                | netPosition | netValue | account                | type                | positionKey |
      | PosUpdate_07_Res1 | ACCOUNT | [PosUpdate_07.participant] | [PosUpdate_07.symbol] | -70.0       | -2324.0  | [PosUpdate_07.account] | [PosUpdate_07.type] | RZ_PT_PK_10 |
#
#  @InstrumentEdit
#  Scenario: TC_022 Instrument Edit
#
#    Given instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
#      | Instance ID | Symbol                     | Size Multiplier |
#      | Inst_01     | random(RZ_PT_Inst_Bond_,4) | 2               |
#
#    When "Realtime Risk Factor Update" messages are submitted with following values
#      | Instance ID | symbol           | type | value | currency | venue  |
#      | MD1         | [Inst_01.Symbol] | AI   | 2.0   | USD      | CCCAGG |
#      | MD2         | [Inst_01.Symbol] | LTP  | 45.0  | USD      | CCCAGG |
#
#    And instance "[Inst_01.Symbol]" of entity "Instruments" is updated with following values
#      | Instance ID    | Size Multiplier |
#      | Inst_Update_01 | 8               |
#
  @MD
  Scenario: AI update

#    Given  instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
#      | Instance ID | Symbol                     |
#      | Inst_01     | random(RZ_PT_Inst_Bond_,4) |
#
#    #this step is just added to give some time just after the instrument creation before update Market Data
#    Then instance "[Inst_01.Symbol]" of entity "Instruments" should be
#      | Instance ID  | Symbol           |
#      | Inst_01_Res1 | [Inst_01.Symbol] |

    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | currency | ltp  | dv01 | ai  |
      | MD1         | RZ_ST_Rate1M | USD      | 10.0 | 15.0 | 3.0 |
#      | MD1         | RZ_PT_Inst_Bond_0975 | AI   | 5.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | MD1_Res1    | [MD1.symbol] | 15.0 |

#  @history
#  Scenario:  History
#
#    Given instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
#      | Instance ID | Account Id           | Name                 | Participant | Position Key Ids |
#      | Acc_01      | random(RZ-PT-Acc-,4) | random(RZ-PT-Acn-,4) | RZ-PT-01    | RZ_PT_PK_05      |
#
#    And  instance "RZ-Base-Ins-Fixed-02" of entity "Instruments" is copied with following values
#      | Instance ID | Symbol                     |
#      | Inst_01     | random(RZ_PT_Inst_Bond_,4) |
#
#    When "Position Update" messages are submitted with following values
#      | Instance ID  | account             | symbol           | quantity | price | value  | side  | participant          | notional | market | settlementDate                |
#      | PosUpdate_01 | [Acc_01.Account Id] | Stepped-Bond-hnk | 60       | 50.0  | 1500.0 | SHORT | [Acc_01.Participant] | 3000     | CCCAGG | 2022-02-22T00:00:00.000+00:00 |
#
#    And "Position Update" messages are submitted with following values
#      | Instance ID  | account             | symbol           | quantity | price | value  | side  | participant          | notional | market | settlementDate                |
#      | PosUpdate_02 | [Acc_01.Account Id] | Stepped-Bond-hnk | 60       | 50.0  | 1500.0 | SHORT | [Acc_01.Participant] | 3000     | CCCAGG | 2023-02-22T00:00:00.000+00:00 |
#
#    Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
#      | Instance ID       | level   | participant                | symbol                | shortPosition | shortValue | netPosition | netValue | avgPrice | account                | notional | mtmValue | realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage | accruedAmount | ai  | positionId |
#      | PosUpdate_02_Res1 | ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 120.0         | 3000.0     | -120.0      | -3000.0  | 25.0     | [PosUpdate_02.account] | -6000.0  | 0.0      | 0.0              | 3000.0             | 100.0                   | 0.0           | 0.0 | NOT_EMPTY  |
#
#    And "Position History" messages are filtered by "positionId,notional" should be
#      | Instance ID   | participant          | account             | positionId                     | shortPosition | shortValue | longPosition | longValue | netPosition | netValue | avgPrice | notional |
#      | POS_History01 | [Acc_01.Participant] | [Acc_01.Account Id] | [PosUpdate_02_Res1.positionId] | 60.0          | 1500.0     | 60.0         | 1500.0    | 0.0         | 0.0      | 25.0     | -3000.0  |
#
#  @Upload
#  Scenario: AI update
#
#    When "Position Update" messages are submitted with following values
