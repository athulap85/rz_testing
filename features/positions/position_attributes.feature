Feature: Position Attributes

     @done
     Scenario: TC_003 Validating Position Key exists

      Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id            | Name                    | Participant    |
        | Acc_01      | random(RZ-PT-Acc-,4)  | random(RZ-PT-Acn-,4)    | RZ-PT-001      |

        When "Position Update" messages are submitted with following values
        | Instance ID  | symbol              | quantity | price | side | participant          | type   | account             |  notional | Position Key Id |
        | PosUpdate_01 | RZ_PT_Inst_Bond_001 | 1000     | 50.0  | SHORT| [Acc_01.Participant] | MARGIN | [Acc_01.Account Id] |  50000    |  1              |

        Then "Position" messages are filtered by "level,account,participant" should be
        | Instance ID      | symbol               | level    | account                  | participant               | type   | shortPosition| netPosition |  positionKey|
        | PosUpdate_01_Res1| [PosUpdate_01.symbol]| ACCOUNT  | [PosUpdate_01.account]   | [PosUpdate_01.participant]| MARGIN | 1000.0       | -1000.0     |  NOT_EMPTY  |

      Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted

     @done
     Scenario: TC_004 Validating Symbol for Floating Rate Bond

      Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id          | Name                | Participant |
        | Acc_01      | random(RZ-PT-Acc-,4)| random(RZ-PT-Acn-,4)| RZ-PT-001   |

        And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
        | Instance ID | Instrument Type    | Symbol                   |
        | Inst_01     | FLOATING_RATE_BOND | random(RZ_PT_Inst_Bond,2)|

        When "Position Update" messages are submitted with following values
        | Instance ID | symbol          | quantity | price | side | participant          | type   | account             |  notional |
        | PosUpdate_01| [Inst_01.Symbol]| 1000     | 50.0  | SHORT| [Acc_01.Participant] | MARGIN | [Acc_01.Account Id] |  50000    |

        Then "Position" messages are filtered by "level,account,participant" should be
        | Instance ID      | symbol               | level  | account                  | participant               | type   | shortPosition| netPosition |  positionKey|
        | PosUpdate_01_Res1| [PosUpdate_01.symbol]| ACCOUNT| [PosUpdate_01.account]   | [PosUpdate_01.participant]| MARGIN | 1000.0       | -1000.0     |  NOT_EMPTY  |

      Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted
      Given instance "[Inst_01.Symbol]" of entity "Instruments" is deleted

     @done
     Scenario: TC_005 Validating Currency ( Bonds with different currencies)

      Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id            | Name                | Participant    |
        | Acc_01      | random(RZ-PT-Acc-,4)  | random(RZ-PT-Acn-,4)| RZ-PT-001      |

       And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
        | Instance ID | Symbol                   | Currency    |
        | Inst_01     | random(RZ_PT_Inst_Bond,2)|  BTC        |

        When "Position Update" messages are submitted with following values
        | Instance ID | symbol          | quantity | price | side | participant          | type   | account             |  notional  | market    |  currency |
        | PosUpdate_01| [Inst_01.Symbol]|   1000   | 50.0  | SHORT| [Acc_01.Participant] | MARGIN | [Acc_01.Account Id] |  50000     | BitStamp  | BTC       |

        Then "Position" messages are filtered by "level,account,participant,shortPosition" should be
        | Instance ID       |  symbol               |  level    | account                   | participant               | type   | shortPosition | netPosition |   currency              |
        | PosUpdate_01_Res2 | [PosUpdate_01.symbol] | ACCOUNT   | [PosUpdate_01.account]    | [PosUpdate_01.participant]| MARGIN | 1000.0        | -1000.0     |   [PosUpdate_01.currency]|

	    When "Position Update" messages are submitted with following values
        | Instance ID | symbol           | quantity | price | side | participant          | type   | account             |  notional  | currency |
        | PosUpdate_02| [Inst_01.Symbol] | 1000     | 50.0  | SHORT| [Acc_01.Participant] | MARGIN | [Acc_01.Account Id] |  50000     | USD      |

        Then "Position" messages are filtered by "level,account,participant,currency" should be
        | Instance ID       | symbol                | level    | account                  | participant               | type   | shortPosition   | netPosition |  currency              |
        | PosUpdate_02_Res1 | [PosUpdate_02.symbol] | ACCOUNT  | [PosUpdate_02.account]   | [PosUpdate_02.participant]| MARGIN | 1000.0          | -1000.0     |  [PosUpdate_02.currency]|

      Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted
	  Given instance "[Inst_01.Symbol]" of entity "Instruments" is deleted

     @done @fail
     Scenario: TC_006 Validating Settlement Date

      Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id          | Name                | Participant|
        | Acc_01      | random(RZ-PT-Acc-,4)| random(RZ-PT-Acn-,4)| RZ-PT-001     |

        When "Position Update" messages are submitted with following values
        | Instance ID | symbol             | quantity | price | side | participant         | type   | account             |  notional  |  settlement Date |
        | PosUpdate_01| RZ_PT_Inst_Bond_001|   1000   | 50.0  | SHORT| [Acc_01.Participant]| MARGIN | [Acc_01.Account Id] |  50000     |  2022-04-20      |

        Then "Position" messages are filtered by "level,account,participant" should be
        | Instance ID       |  symbol               |  level    | account                  | participant               | type   | shortPosition| netPosition |    settlementDate			     |
        | PosUpdate_01_Res1 | [PosUpdate_01.symbol] | ACCOUNT   | [PosUpdate_01.account]   | [PosUpdate_01.participant]| MARGIN | 1000.0       | -1000.0     |   [PosUpdate_01.settlement Date]  |

      Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted

     @done
     Scenario: TC_007 Validating Markets ( Position Updates added with different Markets)

      Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id          | Name                | Participant   |
        | Acc_01      | random(RZ-PT-Acc-,4)| random(RZ-PT-Acn-,4)| RZ-PT-001     |

        When "Position Update" messages are submitted with following values
        | Instance ID  | symbol             | quantity   | price | side | participant          | type   | account             |  notional  | market   |
        | PosUpdate_01 | RZ_PT_Inst_Bond_001|   1000     | 50.0  | SHORT| [Acc_01.Participant] | MARGIN | [Acc_01.Account Id] |  50000     | BitStamp |

        Then "Position" messages are filtered by "level,account,participant,shortPosition,market" should be
        | Instance ID|  symbol               |  level    | account                   | participant                | type   | shortPosition   |  market               |
        | Acc_01_Res1| [PosUpdate_01.symbol] | ACCOUNT   | [PosUpdate_01.account]    | [PosUpdate_01.participant] | MARGIN | 1000.0          |  [PosUpdate_01.market]|

        When "Position Update" messages are submitted with following values
        | Instance ID  | symbol              | quantity  | price | side  | participant          | type   | account             |  notional  | market   |
        | PosUpdate_02 | RZ_PT_Inst_Bond_002 |   1000    | 50.0  | SHORT | [Acc_01.Participant] | MARGIN | [Acc_01.Account Id] |  500000    | BINANCE |

        Then "Position" messages are filtered by "level,account,participant,shortPosition,market" should be
        | Instance ID       |  symbol               |  level    | account                 | participant                | type   | shortPosition |  market              |
        | PosUpdate_02_Res1 | [PosUpdate_02.symbol] | ACCOUNT   | [PosUpdate_02.account]  | [PosUpdate_02.participant] | MARGIN | 1000.0        |  [PosUpdate_02.market]|

      Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted

     @done1
      Scenario: TC_008 Validate Values in Long position ( longPosition,longValue, notional, average Price )

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id            | Name                | Participant    |
        | Acc_01      | random(RZ-PT-Acc-,4)  | random(RZ-PT-Acn-,4)| RZ-PT-001      |

        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol               | type   | value |
        |   MD1       | RZ_PT_Inst_Bond_001  | AI     | 2.0   |

        Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
        | Instance ID| symbol       | ai  |
        | MD1_Res1   | [MD1.symbol] | 2.0 |

        When "Position Update" messages are submitted with following values
        | Instance ID | account             | symbol       |  quantity | price | value   | side | participant           | notional  |
        | PosUpdate_01| [Acc_01.Account Id] | [MD1.Symbol] | 6000      | 5.0   | 30000.0 | LONG | [Acc_01.Participant]  | 30000     |

        Then "Position" messages are filtered by "level,participant,account" should be
        | Instance ID      | level   | participant               |  symbol               | longPosition | longValue | netPosition  | netValue | account                | avgPrice  |  notional |
        | PosUpdate_01_Res1| ACCOUNT | [PosUpdate_01.participant]| [PosUpdate_01.symbol] | 6000.0       | 2100.0    | 6000.0       | 2100.0   | [PosUpdate_01.account] | 0.35      |  30000.0  |

	   When "Position Update" messages are submitted with following values
        | Instance ID | account              | symbol        |  quantity | price | value   | side | participant           | notional  |
        | PosUpdate_02 | [Acc_01.Account Id] | [MD1.Symbol]  |  4000     | 4.0   | 16000.0 | LONG | [Acc_01.Participant]  | 16000     |

        Then "Position" messages are filtered by "level,participant,account,longPosition" should be
        | Instance ID     | level   | participant                 |  symbol              | longPosition | longValue | netPosition  | netValue | account                 | avgPrice  |  notional   |
        | PosUpdate_02_Res1| ACCOUNT | [PosUpdate_02.participant] | [PosUpdate_02.symbol] | 10000.0     | 3060.0    | 10000.0      | 3060.0   | [PosUpdate_02.account]  | 0.306     |  46000.0    |

	    Given instance "[Acc_01.Account Id]" of entity "Accounts" is deleted
     @done
      Scenario: TC_009 Validate values in Short Position (shortposition, shortvalue, Average price, notional )

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id        | Name              | Participant    |
        | TC_009_Ins1 | random(RZ-PT-Acc-,4)     | random(RZ-PT-Acn-,4)     | PS_001           |

		And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
        | Instance ID | Symbol               | Currency    |
        | TC_009_Inst | random(FR_BOND_CUR,6)|  USD        |

        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol                  | type   | value |  currency   |
        | TC_009_MD1 | [TC_009_Inst.Symbol]     | AI     | 2.0   |  USD        |

        When "Position Update" messages are submitted with following values
        | Instance ID   | account                  | symbol                 |quantity   | price | value   | side  | participant                 | notional     |
        | TC_009_Ins2   | [TC_009_Ins1.Account Id] | [TC_009_Inst.Symbol]   |  600      | 50.0  | 30000.0 | SHORT |  [TC_009_Ins1.Participant]  |  30000       |

       And "Position" messages are filtered by "level,participant,account,shortPosition" should be
        | Instance ID        | level   | participant               | symbol                | shortPosition   | shortValue | netPosition  | netValue  | avgPrice | account                 |
        | TC_009_Ins2_Res1   | ACCOUNT | [TC_009_Ins2.participant] | [TC_009_Ins2.symbol]  | 600.0           | 15600.0    | -600.0       | -15600.0  | 26.0     | [TC_009_Ins2.account]   |

        When "Position Update" messages are submitted with following values
        | Instance ID   | account                   | symbol                | quantity  | price | value   | side  | participant               | notional  |
        | TC_009_Ins3   | [TC_009_Ins1.Account Id]  | [TC_009_Inst.Symbol]  |  1000     | 51.0  | 51000.0 | SHORT |  [TC_009_Ins1.Participant]|  51000    |

         And "Position" messages are filtered by "level,participant,account,shortPosition" should be
        | Instance ID       | level   | participant              | symbol                 |  shortPosition   | shortValue | netPosition  | netValue  | avgPrice    | account                 |
        | TC_009_Ins3_Res1  | ACCOUNT | [TC_009_Ins2.participant]| [TC_009_Ins3.symbol]   |  1600.0          | 42630.0    | -1600.0      | -42630.0  | 26.64375     | [TC_009_Ins2.account]   |

      Given instance "[TC_009_Ins1.Account Id]" of entity "Accounts" is deleted
	  Given instance "[TC_009_Inst.Symbol]" of entity "Instruments" is deleted

     @done
    Scenario: TC_010 Validate values in Net position when both positions exit (net value,net position,average price)

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id     | Name          | Participant    |
        | TC_010_Ins1 | random(RZ-PT-Acc-,4)  | random(RZ-PT-Acn-,4) | PS_001           |

		And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
        | Instance ID | Symbol               | Currency    |
        | TC_010_Inst | random(FR_BOND_CUR,6)|  USD        |

        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol                  | type   | value |  currency   |
        | TC_010_MD1 | [TC_010_Inst.Symbol]     | AI     | 5.0   |  USD        |

        When "Position Update" messages are submitted with following values
        | Instance ID   | account                     | symbol                | quantity  | price | value   | side  | participant                 | notional |
        | TC_010_Ins2   | [TC_010_Ins1.Account Id]    | [TC_010_Inst.Symbol]  |  800      | 50.0  | 40000.0 | SHORT |  [TC_010_Ins1.Participant]  | 40000    |

        And "Position" messages are filtered by "level,participant,account,netPosition,netValue" should be
        | Instance ID         | level   | participant               |  symbol              | shortPosition   | shortValue | netPosition  | netValue | avgPrice | account                    |
        | TC_010_Ins2_Res1    | ACCOUNT |  [TC_010_Ins1.Participant]| [TC_010_Ins2.symbol] | 800.0           | 22000.0    | -800.0       | -22000.0 | 27.5     | [TC_010_Ins1.Account Id]   |

        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol                  | type   | value |  currency   |
        | TC_010_MD2  | [TC_010_Inst.Symbol]    | AI     | 10.0  |  USD        |

       And  "Position Update" messages are submitted with following values
        | Instance ID  | account                     |  symbol               | quantity | price | value   | side  | participant                      |  notional    |
        | TC_010_Ins3  | [TC_010_Ins1.Account Id]    | [TC_010_Inst.Symbol]  | 1000     | 51.0  | 51000.0 | LONG  |  [TC_010_Ins1.Participant]       |  200000      |

       Then response of the request "TC_010_Ins3" should be
        | Instance ID       | status   | subStatus   |
        | TC_010_Ins3_Res1  | POSTED   | ACCEPTED  |

       And "Position" messages are filtered by "level,participant,account,shortPosition,longPosition,netPosition" should be
        | Instance ID         | level   | participant   | symbol               |  shortPosition   | longPosition  | shortValue | longValue  | netPosition  | netValue  | avgPrice    | account                    |
        | TC_010_Ins3_Res2    | ACCOUNT | PS_001          | [TC_010_Ins3.symbol] |  800.0           | 1000.0        | 55000.0    | 122000.0   | 200.0        | 67000.0   | 335.0       | [TC_010_Ins1.Account Id]   |

       Given instance "[TC_010_Ins1.Account Id] " of entity "Accounts" is deleted
       Given instance "[TC_010_Inst.Symbol]" of entity "Instruments" is deleted

     @done
    Scenario: TC_011 Validate MTM Value when LTP is available for the Instrument

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id     | Name          | Participant    |
        | TC_011_Ins1 | random(RZ-PT-Acc-,4)  | random(RZ-PT-Acn-,4) | PS_001           |

		And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
        | Instance ID | Symbol               |
        | TC_011_Inst | random(FR_BOND_CUR,6)|

        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol                  | type   | value  |
        | TC_011_MD1 | [TC_011_Inst.Symbol]     | AI     | 15.0   |
        | TC_011_MD2 | [TC_011_Inst.Symbol]     | LTP    | 65.0   |

        And "Position Update" messages are submitted with following values
        | Instance ID   | account                     | symbol                | quantity  | price | value   | side  | participant                 | notional |
        | TC_011_Ins2   | [TC_011_Ins1.Account Id]    | [TC_011_Inst.Symbol]  |  1000     | 60.0  | 60000.0 | SHORT |  [TC_011_Ins1.Participant]  | 100000   |

        Then response of the request "TC_011_Ins2" should be
        | Instance ID       | status   | subStatus   |
        | TC_011_Ins2_Res1  | POSTED   | ACCEPTED  |

        And "Position" messages are filtered by "level,participant,account" should be
        | Instance ID         | level   | participant               |  symbol              | shortPosition    | shortValue | netPosition    | netValue | avgPrice  | account                  |   mtmValue     |  positionId|
        | TC_011_Ins2_Res2    | ACCOUNT |  [TC_011_Ins2.participant]| [TC_011_Ins2.symbol] | 1000.0           | 75000.0    | -1000.0        | -75000.0 | 75.0       | [TC_011_Ins2.account]   |   -80000.0     |  NOT_EMPTY |

        When  instance "Bond_Test_1" of entity "Instruments" is copied with following values
        | Instance ID  | Symbol               | Size Multiplier|
        | TC_011_Inst2 | random(FR_BOND_CUR,6)|  2             |

        And  "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol                   | type   | value  |
        | TC_011_MD3 | [TC_011_Inst2.Symbol]     | AI     | 20.0   |
        | TC_011_MD4 | [TC_011_Inst2.Symbol]     | LTP    | 90.0   |

        And "Position Update" messages are submitted with following values
        | Instance ID   | account                     | symbol                 | quantity  | price | value   | side  | participant                 | notional |
        | TC_011_Ins3   | [TC_011_Ins1.Account Id]    | [TC_011_Inst2.Symbol]  |  1000     | 60.0  | 60000.0 | SHORT |  [TC_011_Ins1.Participant]  | 100000   |

        Then response of the request "TC_011_Ins3" should be
        | Instance ID       | status   | subStatus   |
        | TC_011_Ins3_Res1  | POSTED   | ACCEPTED  |

        And "Position" messages are filtered by "level,participant,account,shortPosition,symbol" should be
        | Instance ID         | level   | participant               |  symbol              | shortPosition    | shortValue | netPosition    | netValue | avgPrice   | account                 | mtmValue     |
        | TC_011_Ins3_Res2    | ACCOUNT |  [TC_011_Ins3.participant]| [TC_011_Ins3.symbol] | 1000.0           | 80000.0    | -1000.0        | -80000.0 | 80.0       | [TC_011_Ins3.account]   |  -220000.0    |

       Given instance "[TC_011_Ins1.Account Id] " of entity "Accounts" is deleted
       Given instance "[TC_011_Inst.Symbol]" of entity "Instruments" is deleted
       Given instance "[TC_011_Inst2.Symbol]" of entity "Instruments" is deleted

     @done
       Scenario: TC_012 Validate MTM Value when LTP is empty and updated before the next position update

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id     | Name          | Participant    |
        | TC_012_Ins1 | random(RZ-PT-Acc-,4)  | random(RZ-PT-Acn-,4) | PS_001           |

		And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
        | Instance ID | Symbol               |
        | TC_012_Inst | random(FR_BOND_CUR,6)|

        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol                  | type   | value  |
        | TC_012_MD1 | [TC_012_Inst.Symbol]     | AI     | 15.0   |

        And "Position Update" messages are submitted with following values
        | Instance ID   | account                     | symbol                | quantity  | price | value   | side  | participant                 | notional |
        | TC_012_Ins2   | [TC_012_Ins1.Account Id]    | [TC_012_Inst.Symbol]  |  1000     | 60.0  | 60000.0 | SHORT |  [TC_012_Ins1.Participant]  | 100000   |

        Then response of the request "TC_012_Ins2" should be
        | Instance ID       | status   | subStatus   |
        | TC_012_Ins2_Res1  | POSTED   | ACCEPTED  |

        And "Position" messages are filtered by "level,participant,account,mtmValue" should be
        | Instance ID         | level   | participant               |  symbol              | shortPosition    | shortValue | netPosition    | netValue | avgPrice  | account                  |   mtmValue     |
        | TC_012_Ins2_Res2    | ACCOUNT |  [TC_012_Ins2.participant]| [TC_012_Ins2.symbol] | 1000.0           | 75000.0    | -1000.0        | -75000.0 | 75.0       | [TC_012_Ins2.account]   |   -15000.0     |

        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol                  | type   | value  |
        | TC_012_MD2  | [TC_012_Inst.Symbol]    | LTP    | 75.0   |

        When "Position Update" messages are submitted with following values
        | Instance ID   | account                     | symbol                | quantity  | price | value   | side  | participant                 | notional |
        | TC_012_Ins3   | [TC_012_Ins1.Account Id]    | [TC_012_Inst.Symbol]  |  1000     | 60.0  | 60000.0 | SHORT |  [TC_012_Ins1.Participant]  | 100000   |

        Then response of the request "TC_012_Ins3" should be
        | Instance ID       | status   | subStatus   |
        | TC_012_Ins3_Res1  | POSTED   | ACCEPTED    |

        And "Position" messages are filtered by "level,participant,account,shortPosition,mtmValue" should be
        | Instance ID         | level   | participant               |  symbol              | shortPosition    | shortValue  | netPosition    | netValue  | avgPrice   | account                 |   mtmValue     |
        | TC_012_Ins3_Res2    | ACCOUNT | [TC_012_Ins3.participant] | [TC_012_Ins3.symbol] | 2000.0           | 150000.0    | -2000.0        | -150000.0 | 75.0       | [TC_012_Ins3.account]   |   -180000.0     |

       Given instance "[TC_012_Ins1.Account Id] " of entity "Accounts" is deleted
       Given instance "[TC_012_Inst.Symbol]" of entity "Instruments" is deleted

     @done
       Scenario: TC_013 Validate MTM Value when AI is empty and updated

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id     | Name          | Participant    |
        | TC_013_Ins1 | random(RZ-PT-Acc-,4)  | random(RZ-PT-Acn-,4) | PS_001           |

		And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
        | Instance ID | Symbol               |
        | TC_013_Inst | random(FR_BOND_CUR,6)|

        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol                  | type    | value  |
        | TC_013_MD1 | [TC_013_Inst.Symbol]     | LTP     | 55.0   |

        And "Position Update" messages are submitted with following values
        | Instance ID   | account                     | symbol                | quantity  | price | value   | side  | participant                 | notional |
        | TC_013_Ins2   | [TC_013_Ins1.Account Id]    | [TC_013_Inst.Symbol]  |  1000     | 60.0  | 60000.0 | SHORT |  [TC_013_Ins1.Participant]  | 60000   |

        Then response of the request "TC_013_Ins2" should be
        | Instance ID       | status   | subStatus   |
        | TC_013_Ins2_Res1  | POSTED   | ACCEPTED  |

        And "Position" messages are filtered by "level,participant,account,avgPrice,mtmValue" should be
        | Instance ID         | level   | participant               |  symbol              | shortPosition    | shortValue | netPosition    | netValue | avgPrice  | account                  |   mtmValue     |
        | TC_013_Ins2_Res2    | ACCOUNT |  [TC_013_Ins2.participant]| [TC_013_Ins2.symbol] | 1000.0           | 33000.0    | -1000.0        | -33000.0 | 33.0       | [TC_013_Ins2.account]   |   -33000.0     |

        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol                  | type   | value  |
        | TC_013_MD2  | [TC_013_Inst.Symbol]    | AI     | 15.0   |

        Then "Position" messages are filtered by "level,participant,account,shortPosition,avgPrice,mtmValue" should be
        | Instance ID         | level   | participant               |  symbol              | shortPosition    | shortValue  | netPosition    | netValue  | avgPrice   | account                 |   mtmValue     |
        | TC_013_Ins2_Res3    | ACCOUNT | [TC_013_Ins2.participant] | [TC_013_Ins2.symbol] | 1000.0           | 42000.0     | -1000.0        | -42000.0  |   42.0     | [TC_013_Ins2.account]   |   -70000.0     |

       Given instance "[TC_013_Ins1.Account Id] " of entity "Accounts" is deleted
       Given instance "[TC_013_Inst.Symbol]" of entity "Instruments" is deleted



        @AI
     Scenario: TC_014 Validate MTM Value when LTP is empty and updated

     When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol         | type    | value  |
        | TC_014_MD1  | POS_0001       | AI      | 25.0   |
        | TC_014_MD2  | POS_0001       | LTP     |  0.0   |

        Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
        | Instance ID     | symbol               | ai     |
        | TC_014_MD2_Res1 | [TC_014_MD2.symbol]  | 25.0   |

         @LTP
     Scenario: TC_014 Validate MTM Value when LTP is empty and updated9

          When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol                  | type    | value  |
        | TC_014_MD3  | POS_0001              | LTP     | 65.0   |

        Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
        | Instance ID     | symbol               | ltp    |
        | TC_014_MD3_Res1 | [TC_014_MD3.symbol]  | 65.0   |


         @L
     Scenario: TC_014 Validate MTM Value when LTP is empty and updated

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id     | Name          | Participant    |
        | TC_014_Ins1 | random(RZ-PT-Acc-,4)  | random(RZ-PT-Acn-,4) | PS_001           |

#		And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
#        | Instance ID | Symbol               |
#        | TC_014_Inst | random(FR_BOND_CUR,6)|

        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol         | type    | value  |
        | TC_014_MD1  | POS_0001       | AI      | 25.0   |
        | TC_014_MD2  | POS_0001       | LTP     |  0.0   |

        Then "Realtime Risk Factor Value" messages are filtered by "symbol,ai" should be
        | Instance ID     | symbol               | ai     |
        | TC_014_MD2_Res1 | [TC_014_MD2.symbol]  | 25.0   |

        When "Position Update" messages are submitted with following values
        | Instance ID   | account                     | symbol                | quantity  | price | value   | side  | participant                 | notional |
        | TC_014_Ins2   | [TC_014_Ins1.Account Id]    | [TC_014_MD1.symbol]   |  1000     | 60.0  | 60000.0 | SHORT |  [TC_014_Ins1.Participant]  | 60000    |

        Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
        | Instance ID         | level   | participant               |  symbol              | shortPosition    | shortValue | netPosition    | netValue | avgPrice   | account                  |   mtmValue     |
        | TC_014_Ins2_Res1    | ACCOUNT |  [TC_014_Ins2.participant]| [TC_014_Ins2.symbol] | 1000.0           | 51000.0    | -1000.0        | -51000.0  | 51.0       | [TC_014_Ins2.account]    |   -50000.0     |

        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol                  | type    | value  |
        | TC_014_MD3  | [TC_014_MD1.symbol]     | LTP     | 65.0   |

        Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
        | Instance ID     | symbol               | ltp    |
        | TC_014_MD3_Res1 | [TC_014_MD1.symbol]  | 65.0   |

        Then "Position" messages are filtered by "level,participant,account,shortPosition,shortValue,mtmValue" should be
        | Instance ID         | level   | participant               |  symbol              | shortPosition    | shortValue  | netPosition    | netValue  | avgPrice   | account                 |   mtmValue     |
        | TC_014_Ins2_Res2    | ACCOUNT | [TC_014_Ins2.participant] | [TC_014_Ins2.symbol] | 1000.0           | 51000.0     | -1000.0        | -51000.0  |   51.0     | [TC_014_Ins2.account]   |   -180000.0    |

       Given instance "[TC_014_Ins1.Account Id] " of entity "Accounts" is deleted
#       Given instance "[TC_014_Inst.Symbol]" of entity "Instruments" is deleted

      @done
       Scenario: TC_015 Validate Realized MTM Value, Unrealized MTM Value, Unrealized MTM % when Long Position < Short Position , Long Position = Short Position  and Long Position > Short Position

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id            | Name                 | Participant     |
        | TC_015_Ins1 | random(RZ-PT-Acc-,4)  | random(RZ-PT-Acn-,4) | PS_001           |

#		When  instance "Bond_Test_1" of entity "Instruments" is copied with following values
#        | Instance ID  | Symbol               | Size Multiplier|
#        | TC_015_Inst  | random(FR_BOND_CUR,6)|  2             |

        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol         | type   | value   |
		| TC_015_MD2  | POS_0001       | LTP    | 1000.0  |
        | TC_015_MD3  | POS_0001       | AI     |         |

        Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
        | Instance ID     | symbol               | ltp    |
        | TC_015_MD2_Res1 | [TC_015_MD2.symbol]  | 1000.0 |

        When "Position Update" messages are submitted with following values
        | Instance ID   | account                     | symbol                | quantity  | price | value     | side  | participant                 | notional |
        | TC_015_Ins2   | [TC_015_Ins1.Account Id]    | [TC_015_MD2.symbol]  |  1000     | 900.0 | 900000.0  | LONG  | [TC_015_Ins1.Participant]   | 900000   |

        Then  "Position" messages are filtered by "level,participant,account,netPosition" should be
        | Instance ID         | level   | participant               |  symbol              | longPosition    | longValue    | netPosition    | netValue   | avgPrice  | account                  |   mtmValue      | realizedMtmValue | unrealizedMtmValue |unrealizedMtmPercentage |
        | TC_015_Ins2_Res1    | ACCOUNT |  [TC_015_Ins2.participant]| [TC_015_Ins2.symbol] | 1000.0          | 8100000.0    | 1000.0         | 8100000.0  | 8100.0    | [TC_015_Ins2.account]    |   2000000.0     |   0.0            | -6100000.0         | -75.30864197530865     |

        When "Position Update" messages are submitted with following values
        | Instance ID   | account                     | symbol                | quantity  | price | value   | side  | participant                 | notional |
        | TC_015_Ins3   | [TC_015_Ins1.Account Id]    | [TC_015_MD2.symbol]   |  500      | 800.0 | 40000.0 | SHORT |  [TC_015_Ins1.Participant]  | 400000   |

        Then "Position" messages are filtered by "level,participant,account,shortPosition,mtmValue,unrealizedMtmValue" should be
        | Instance ID         | level   | participant               |  symbol              | shortPosition    | shortValue  |longPosition   | longValue    | netPosition | netValue  | avgPrice   | account                 |   mtmValue     |realizedMtmValue | unrealizedMtmValue | unrealizedMtmPercentage| notional |
        | TC_015_Ins3_Res1    | ACCOUNT | [TC_015_Ins3.participant] | [TC_015_Ins3.symbol] | 500.0            | 3200000.0   | 1000.0        | 8100000.0    | 500.0       | 4900000.0 | 9800.0     | [TC_015_Ins3.account]   |  1000000.0     | -850000.0       |   -3900000.0       |  -79.59183673469387     |         |

        When "Position Update" messages are submitted with following values
        | Instance ID   | account                     | symbol                | quantity  | price | value   | side  | participant                 | notional |
        | TC_015_Ins4   | [TC_015_Ins1.Account Id]    | [TC_015_MD2.symbol]   |  500      | 800.0 | 40000.0 | SHORT |  [TC_015_Ins1.Participant]  | 400000   |

        Then "Position" messages are filtered by "level,participant,account,shortPosition,mtmValue,unrealizedMtmValue" should be
        | Instance ID         | level   | participant               |  symbol              | shortPosition    | shortValue  |longPosition   | longValue    | netPosition | netValue  | avgPrice   | account                 |   mtmValue     |realizedMtmValue  | unrealizedMtmValue | unrealizedMtmPercentage|
        | TC_015_Ins4_Res1    | ACCOUNT | [TC_015_Ins4.participant] | [TC_015_Ins4.symbol] | 1000.0           | 6400000.0   | 1000.0        | 8100000.0    | 0.0         | 1700000.0 | 0.0        | [TC_015_Ins4.account]   |  0.0           | 1700000.0        |  -1700000.0         |  -100.0       |

        When "Position Update" messages are submitted with following values
        | Instance ID   | account                     | symbol                | quantity  | price | value   | side  | participant                 | notional |
        | TC_015_Ins5   | [TC_015_Ins1.Account Id]    | [TC_015_MD2.symbol]   |  500      | 800.0 | 40000.0 | SHORT |  [TC_015_Ins1.Participant]  | 400000   |

        Then "Position" messages are filtered by "level,participant,account,shortPosition,mtmValue,unrealizedMtmValue" should be
        | Instance ID         | level   | participant               |  symbol              | shortPosition    | shortValue  |longPosition   | longValue    | netPosition | netValue         | avgPrice   | account                 |   mtmValue     |realizedMtmValue | unrealizedMtmValue |
        | TC_015_Ins5_Res1    | ACCOUNT | [TC_015_Ins5.participant] | [TC_015_Ins5.symbol] | 1500.0           | 9600000.0   | 1000.0        | 8100000.0    | -500.0      | -1500000.0       | 3000.0     | [TC_015_Ins5.account]   |  -1000000.0   | 1700000.0        | 500000.0           |

#     | unrealizedMtmPercentage |33.33333333333333|