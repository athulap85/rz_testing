Feature: Position Attributes

   @done
   Scenario: TC_001 Validating PositionID,Symbol with Fixed Rate Bond

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id     | Name         | Participant    |
        | TC_001_Ins  | random(ACC,6)  | random(ACN,6)| HSBC           |

        When "Position Update" messages are submitted with following values
        | Instance ID    | symbol      | quantity | price | side | participant              | account                  | notional  |
        | TC_001_Ins1    | Bond_Test_1 | 1000     | 50.0  | SHORT| [TC_001_Ins.Participant] | [TC_001_Ins.Account Id]  | 1000      |

       Then response of the request "TC_001_Ins1" should be
        | Instance ID       | status    | subStatus            |
        | TC_001_Ins1_Res1  | POSTED    | PROCESSING           |

        Then "Position" messages are filtered by "level,account,participant" should be
        | Instance ID      | symbol     		   | level    | account                    | participant                | shortPosition       | netPosition| positionId |
        | TC_001_Ins1_Res2 | [TC_001_Ins1.symbol]  | ACCOUNT  | [TC_001_Ins.Account Id]    |  [TC_001_Ins1.participant] | 1000.0              | -1000.0    | NOT_EMPTY  |

        Given instance "[TC_001_Ins.Account Id]" of entity "Accounts" is deleted

     @done
    Scenario: TC_002 Validating Position Type, Account ID

      Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id     | Name             | Participant    |
        | TC_002_Ins  | random(ACC,6)  | random(ACN,6)    | HSBC           |

        When "Position Update" messages are submitted with following values
        | Instance ID    | symbol      | quantity | price | side | participant              | type   | account                 |  notional |
        | TC_002_Ins1    | Bond_Test_1 | 1000     | 50.0  | SHORT| [TC_002_Ins.Participant] | MARGIN | [TC_002_Ins.Account Id] |  1000     |

        Then response of the request "TC_002_Ins1" should be
        | Instance ID       | status    | subStatus            |
        | TC_002_Ins1_Res1  | POSTED    | PROCESSING           |

        Then "Position" messages are filtered by "level,account,participant" should be
        | Instance ID      | symbol                   | level    | account                       | participant                | type   | shortPosition   | netPosition|
        | TC_002_Ins1_Res2 | [TC_002_Ins1.symbol]     | ACCOUNT  | [TC_002_Ins.Account Id]       | [TC_002_Ins1.participant]  | MARGIN | 1000.0          | -1000.0    |

      Given instance "[TC_002_Ins.Account Id]" of entity "Accounts" is deleted

       @done
     Scenario: TC_003 Validating Position Key exists

      Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id     | Name             | Participant    |
        | TC_003_Ins  | random(ACC,6)  | random(ACN,6)    | HSBC           |

        When "Position Update" messages are submitted with following values
        | Instance ID    | symbol      | quantity | price | side | participant              | type   | account                 |  notional | Position Key Id |
        | TC_003_Ins1    | Bond_Test_1 | 1000     | 50.0  | SHORT| [TC_003_Ins.Participant] | MARGIN | [TC_003_Ins.Account Id] |  1000     |  1              |

        Then response of the request "TC_003_Ins1" should be
        | Instance ID       | status    | subStatus            |
        | TC_003_Ins1_Res1  | POSTED    | PROCESSING           |

        Then "Position" messages are filtered by "level,account,participant" should be
        | Instance ID      | symbol                   | level    | account                       | participant                | type   | shortPosition   | netPosition |  positionKey  |
        | TC_003_Ins1_Res2 | [TC_003_Ins1.symbol]     | ACCOUNT  | [TC_003_Ins.Account Id]       | [TC_003_Ins1.participant]  | MARGIN | 1000.0          | -1000.0     |  NOT_EMPTY    |

      Given instance "[TC_003_Ins.Account Id]" of entity "Accounts" is deleted

       @done
     Scenario: TC_004 Validating Symbol for Floating Rate Bond

      Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id     | Name             | Participant    |
        | TC_004_Ins  | random(ACC,6)  | random(ACN,6)    | HSBC           |

        And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
        | Instance ID | Instrument Type    | Symbol               |
        | TC_004_Inst | FLOATING_RATE_BOND | random(FR_BO_,6)     |

        When "Position Update" messages are submitted with following values
        | Instance ID    | symbol                   | quantity | price | side | participant              | type   | account                 |  notional | Position Key Id |
        | TC_004_Ins1    | [TC_004_Inst.Symbol]     | 1000     | 50.0  | SHORT| [TC_004_Ins.Participant] | MARGIN | [TC_004_Ins.Account Id] |  1000     |  1              |

        Then response of the request "TC_004_Ins1" should be
        | Instance ID       | status    | subStatus            |
        | TC_004_Ins1_Res1  | POSTED    | PROCESSING           |

        Then "Position" messages are filtered by "level,account,participant" should be
        | Instance ID      | symbol                   | level    | account                       | participant                | type   | shortPosition   | netPosition |  positionKey  |
        | TC_004_Ins1_Res2 | [TC_004_Ins1.symbol]     | ACCOUNT  | [TC_004_Ins.Account Id]       | [TC_004_Ins1.participant]  | MARGIN | 1000.0          | -1000.0     |  NOT_EMPTY    |

      Given instance "[TC_004_Ins.Account Id]" of entity "Accounts" is deleted
      Given instance "[TC_004_Inst.Symbol]" of entity "Instruments" is deleted

     @done @fail
     Scenario: TC_005 Validating Currency ( Bonds with different currencies)

      Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id     | Name             | Participant    |
        | TC_005_Ins  | random(ACC,6)  | random(ACN,6)    | HSBC           |

       And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
        | Instance ID | Symbol               | Currency    |
        | TC_005_Inst | random(FR_BOND_CUR,6)|  BTC        |

        When "Position Update" messages are submitted with following values
        | Instance ID    | symbol     | quantity   | price | side | participant              | type   | account                 |  notional  | market     |
        | TC_005_Ins1    | Bond_Test_1|   1000     | 50.0  | SHORT| [TC_005_Ins.Participant] | MARGIN | [TC_005_Ins.Account Id] |  1000      |  BitStamp  |

        Then response of the request "TC_005_Ins1" should be
        | Instance ID       | status    | subStatus            |
        | TC_005_Ins1_Res1  | POSTED    | PROCESSING           |

        Then "Position" messages are filtered by "level,account,participant,shortPosition" should be
        | Instance ID      |  symbol                |  level    | account                       | participant                | type   | shortPosition   | netPosition |   currency |
        | TC_005_Ins1_Res2 | [TC_005_Ins1.symbol]   | ACCOUNT   | [TC_005_Ins.Account Id]       | [TC_005_Ins1.participant]  | MARGIN | 1000.0          | -1000.0     |   USD      |

	    When "Position Update" messages are submitted with following values
        | Instance ID    | symbol               | quantity | price | side | participant              | type   | account                 |  notional  |
        | TC_005_Ins2    | [TC_005_Inst.Symbol] | 1000     | 50.0  | SHORT| [TC_005_Ins.Participant] | MARGIN | [TC_005_Ins.Account Id] |  1000      |

        Then response of the request "TC_005_Ins1" should be
        | Instance ID       | status    | subStatus            |
        | TC_005_Ins2_Res1  | POSTED    | PROCESSING           |

        Then "Position" messages are filtered by "level,account,participant" should be
        | Instance ID      | symbol                   | level    | account                       | participant                | type   | shortPosition   | netPosition |  currency                 |
        | TC_005_Ins2_Res2 | [TC_005_Ins2.symbol]     | ACCOUNT  | [TC_005_Ins.Account Id]       | [TC_005_Ins2.participant]  | MARGIN | 1000.0          | -1000.0     |  TC_005_Inst.Currency]    |

      Given instance "[TC_005_Ins.Account Id]" of entity "Accounts" is deleted
	  Given instance "[TC_005_Inst.Symbol]" of entity "Instruments" is deleted

     @done @fail
     Scenario: TC_006 Validating Settlement Date

      Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id     | Name             | Participant    |
        | TC_006_Ins  | random(ACC,6)  | random(ACN,6)    | HSBC           |

        When "Position Update" messages are submitted with following values
        | Instance ID    | symbol     | quantity   | price | side | participant                | type   | account                 |  notional  |  settlement Date |
        | TC_006_Ins1    | Bond_Test_1|   1000     | 50.0  | SHORT| [TC_006_Ins.Participant]   | MARGIN | [TC_006_Ins.Account Id] |  1000      |  2022-04-20      |
        Then response of the request "TC_006_Ins1" should be
        | Instance ID       | status    | subStatus            |
        | TC_006_Ins1_Res1  | POSTED    | PROCESSING           |

        Then "Position" messages are filtered by "level,account,participant" should be
        | Instance ID      |  symbol                |  level    | account                       | participant                | type   | shortPosition   | netPosition |    settlementDate					  |
        | TC_006_Ins1_Res2 | [TC_006_Ins1.symbol]   | ACCOUNT   | [TC_006_Ins.Account Id]       | [TC_006_Ins1.participant]  | MARGIN | 1000.0          | -1000.0     |   [TC_006_Ins1.settlement Date]      |

      Given instance "[TC_006_Ins.Account Id]" of entity "Accounts" is deleted

     @done @fail
     Scenario: TC_007 Validating Markets ( Position Updates added with different Markets)

      Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id     | Name             | Participant    |
        | TC_007_Ins  | random(ACC,6)  | random(ACN,6)    | HSBC           |

        When "Position Update" messages are submitted with following values
        | Instance ID    | symbol     | quantity   | price | side | participant              | type   | account                 |  notional  | market   |
        | TC_007_Ins1    | Bond_Test_1|   1000     | 50.0  | SHORT| [TC_007_Ins.Participant] | MARGIN | [TC_007_Ins.Account Id] |  1000      | BitStamp |

        Then response of the request "TC_007_Ins1" should be
        | Instance ID       | status    | subStatus            |
        | TC_007_Ins1_Res1  | POSTED    | PROCESSING           |

        Then "Position" messages are filtered by "level,account,participant,shortPosition" should be
        | Instance ID      |  symbol                |  level    | account                       | participant                | type   | shortPosition   | netPosition |   market                |
        | TC_007_Ins1_Res2 | [TC_007_Ins1.symbol]   | ACCOUNT   | [TC_007_Ins.Account Id]       | [TC_007_Ins1.participant]  | MARGIN | 1000.0          | -1000.0     |   [TC_007_Ins1.market]  |

        When "Position Update" messages are submitted with following values
        | Instance ID    | symbol     | quantity   | price | side | participant              | type   | account                 |  notional  | market   |
        | TC_007_Ins2    | Bond_Test_1|   1000     | 50.0  | SHORT| [TC_007_Ins.Participant] | MARGIN | [TC_007_Ins.Account Id] |  1000      | BINANCE |

        Then response of the request "TC_007_Ins1" should be
        | Instance ID       | status    | subStatus            |
        | TC_007_Ins2_Res1  | POSTED    | PROCESSING           |

        Then "Position" messages are filtered by "level,account,participant,shortPosition" should be
        | Instance ID      |  symbol                |  level    | account                       | participant                | type   | shortPosition   | netPosition |   market               |
        | TC_007_Ins2_Res2 | [TC_007_Ins2.symbol]   | ACCOUNT   | [TC_007_Ins.Account Id]       | [TC_007_Ins2.participant]  | MARGIN | 1000.0          | -1000.0     |   [TC_007_Ins2.market]  |

      Given instance "[TC_007_Ins.Account Id]" of entity "Accounts" is deleted

       @done
      Scenario: TC_008 Validate Values in Long position ( longPosition,longValue, notional, average Price )

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id     | Name               | Participant    |
        | TC_008_Ins  | random(ACC,6)  | random(ACN,6)       | HSBC           |

        And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
        | Instance ID | Symbol               | Currency    |
        | TC_008_Inst | random(FR_BOND_CUR,6)|  USD        |

        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol                  | type   | value |  currency   |
        | TC_008_MD1 | [TC_008_Inst.Symbol]     | AI     | 2.0   |  USD        |

        When "Position Update" messages are submitted with following values
        | Instance ID | account                 | symbol                   |  quantity | price | value   | side | participant               | notional  |
        | TC_008_Ins1 | [TC_008_Ins.Account Id] | [TC_008_Inst.Symbol]     | 6000      | 5.0   | 30000.0 | LONG | [TC_008_Ins.Participant]  | 50000      |

        Then response of the request "TC_008_Ins1" should be
        | Instance ID      | status   | subStatus   |
        | TC_008_Ins1_Res1 | POSTED   | PROCESSING  |

        Then "Position" messages are filtered by "level,participant,account" should be
        | Instance ID     | level   | participant                   |  symbol                  | longPosition   | longValue | netPosition  | netValue | account                  | avgPrice                |  notional    |
        | TC_008_Ins1_Res2| ACCOUNT | [TC_008_Ins1.participant]     | [TC_008_Ins1.symbol]     | 6000.0         | 3500.0    | 6000.0       | 3500.0   | [TC_008_Ins1.account]    | 0.5833333333333334      |  50000.0       |

	   When "Position Update" messages are submitted with following values
        | Instance ID | account                 | symbol                   |  quantity | price | value   | side | participant               | notional  |
        | TC_008_Ins2 | [TC_008_Ins.Account Id] | [TC_008_Inst.Symbol]     |  4000     | 4.0   | 16000.0 | LONG | [TC_008_Ins.Participant]  | 50000     |

        Then response of the request "TC_008_Ins2" should be
        | Instance ID      | status   | subStatus   |
        | TC_008_Ins2_Res1 | POSTED   | PROCESSING  |

        Then "Position" messages are filtered by "level,participant,account,longPosition" should be
        | Instance ID     | level   | participant                   |  symbol                  | longPosition   | longValue | netPosition  | netValue | account                  | avgPrice  |  notional   |
        | TC_008_Ins2_Res2| ACCOUNT | [TC_008_Ins2.participant]     | [TC_008_Ins2.symbol]     | 10000.0        | 6500.0    | 10000.0      | 6500.0   | [TC_008_Ins2.account]    | 0.65      |  100000.0   |

	    Given instance "[TC_008_Ins.Account Id]" of entity "Accounts" is deleted
        Given instance "[TC_008_Inst.Symbol]" of entity "Instruments" is deleted

         @done
      Scenario: TC_009 Validate values in Short Position (shortposition, shortvalue, Average price, notional )

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id        | Name              | Participant    |
        | TC_009_Ins1 | random(ACC,6)     | random(ACN,6)     | HSBC           |

		And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
        | Instance ID | Symbol               | Currency    |
        | TC_009_Inst | random(FR_BOND_CUR,6)|  USD        |

        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol                  | type   | value |  currency   |
        | TC_009_MD1 | [TC_009_Inst.Symbol]     | AI     | 2.0   |  USD        |

        When "Position Update" messages are submitted with following values
        | Instance ID   | account                  | symbol                 |quantity | price | value   | side  | participant                 | notional     |
        | TC_009_Ins2   | [TC_009_Ins1.Account Id] | [TC_009_Inst.Symbol]   |  600      | 50.0  | 30000.0 | SHORT |  [TC_009_Ins1.Participant]  |  30000       |

        Then response of the request "TC_009_Ins2" should be
        | Instance ID      | status   | subStatus   |
        | TC_009_Ins2_Res1 | POSTED   | PROCESSING  |

       And "Position" messages are filtered by "level,participant,account,shortPosition" should be
        | Instance ID        | level   | participant               | symbol                | shortPosition   | shortValue | netPosition  | netValue  | avgPrice | account                 |
        | TC_009_Ins2_Res2   | ACCOUNT | [TC_009_Ins2.participant] | [TC_009_Ins2.symbol]  | 600.0           | 15600.0    | -600.0       | -15600.0  | 26.0     | [TC_009_Ins2.account]   |

        When "Position Update" messages are submitted with following values
        | Instance ID   | account                   | symbol                | quantity  | price | value   | side  | participant               | notional  |
        | TC_009_Ins3   | [TC_009_Ins1.Account Id]  | [TC_009_Inst.Symbol]  |  1000     | 51.0  | 51000.0 | SHORT |  [TC_009_Ins1.Participant]|  30000    |

        Then response of the request "TC_009_Ins3" should be
        | Instance ID      | status   | subStatus   |
        | TC_009_Ins3_Res1 | POSTED   | PROCESSING  |

         And "Position" messages are filtered by "level,participant,account,shortPosition" should be
        | Instance ID       | level   | participant              | symbol                 |  shortPosition   | shortValue | netPosition  | netValue  | avgPrice    | account                 |
        | TC_009_Ins3_Res2  | ACCOUNT | [TC_009_Ins2.participant]| [TC_009_Ins3.symbol]   | 1600.0           | 31500.0    | -1600.0      | -31500.0  | 19.6875     | [TC_009_Ins2.account]   |

      Given instance "[TC_009_Ins1.Account Id]" of entity "Accounts" is deleted
	  Given instance "[TC_009_Inst.Symbol]" of entity "Instruments" is deleted

      @done
    Scenario: TC_010 Validate values in Net position when both positions exit (net value,net position,average price)

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id     | Name          | Participant    |
        | TC_010_Ins1 | random(ACC,6)  | random(ACN,6) | HSBC           |

		And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
        | Instance ID | Symbol               | Currency    |
        | TC_010_Inst | random(FR_BOND_CUR,6)|  USD        |

        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol                  | type   | value |  currency   |
        | TC_010_MD1 | [TC_010_Inst.Symbol]     | AI     | 5.0   |  USD        |

        When "Position Update" messages are submitted with following values
        | Instance ID   | account                     | symbol                | quantity  | price | value   | side  | participant                 | notional |
        | TC_010_Ins2   | [TC_010_Ins1.Account Id]    | [TC_010_Inst.Symbol]  |  800      | 50.0  | 40000.0 | SHORT |  [TC_010_Ins1.Participant]  | 100000   |

        Then response of the request "TC_010_Ins2" should be
        | Instance ID       | status   | subStatus   |
        | TC_010_Ins2_Res1  | POSTED   | PROCESSING  |

        And "Position" messages are filtered by "level,participant,account" should be
        | Instance ID         | level   | participant               |  symbol              | shortPosition   | shortValue | netPosition  | netValue | avgPrice | account                    |
        | TC_010_Ins2_Res2    | ACCOUNT |  [TC_010_Ins1.Participant]| [TC_010_Ins2.symbol] | 800.0           | 55000.0    | -800.0       | -55000.0 | 68.75    | [TC_010_Ins1.Account Id]   |

        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol                  | type   | value |  currency   |
        | TC_010_MD2  | [TC_010_Inst.Symbol]    | AI     | 10.0  |  USD        |

       And  "Position Update" messages are submitted with following values
        | Instance ID  | account                     |  symbol               | quantity | price | value   | side  | participant                      |  notional    |
        | TC_010_Ins3  | [TC_010_Ins1.Account Id]    | [TC_010_Inst.Symbol]  | 1000     | 51.0  | 51000.0 | LONG  |  [TC_010_Ins1.Participant]       |  200000      |

       Then response of the request "TC_010_Ins3" should be
        | Instance ID       | status   | subStatus   |
        | TC_010_Ins3_Res1  | POSTED   | PROCESSING  |

       And "Position" messages are filtered by "level,participant,account,shortPosition,longPosition" should be
        | Instance ID         | level   | participant   | symbol               |  shortPosition   | longPosition  | shortValue | longValue  | netPosition  | netValue  | avgPrice    | account                    |
        | TC_010_Ins3_Res2    | ACCOUNT | HSBC          | [TC_010_Ins3.symbol] |  800.0           | 1000.0        | 55000.0    | 122000.0   | 200.0        | 67000.0   | 335.0       | [TC_010_Ins1.Account Id]   |

       Given instance "[TC_010_Ins1.Account Id] " of entity "Accounts" is deleted
       Given instance "[TC_010_Inst.Symbol]" of entity "Instruments" is deleted

    @done
    Scenario: TC_011 Validate MTM Value when LTP is available for the Instrument

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id     | Name          | Participant    |
        | TC_011_Ins1 | random(ACC,6)  | random(ACN,6) | HSBC           |

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
        | TC_011_Ins2_Res1  | POSTED   | PROCESSING  |

        And "Position" messages are filtered by "level,participant,account" should be
        | Instance ID         | level   | participant               |  symbol              | shortPosition    | shortValue | netPosition    | netValue | avgPrice  | account                  |   mtmValue     |
        | TC_011_Ins2_Res2    | ACCOUNT |  [TC_011_Ins2.participant]| [TC_011_Ins2.symbol] | 1000.0           | 75000.0    | -1000.0        | -75000.0 | 75.0       | [TC_011_Ins2.account]   |   -80000.0     |

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
        | TC_011_Ins3_Res1  | POSTED   | PROCESSING  |

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
        | TC_012_Ins1 | random(ACC,6)  | random(ACN,6) | HSBC           |

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
        | TC_012_Ins2_Res1  | POSTED   | PROCESSING  |

        And "Position" messages are filtered by "level,participant,account" should be
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
        | TC_012_Ins3_Res1  | POSTED   | PROCESSING  |

        And "Position" messages are filtered by "level,participant,account,shortPosition" should be
        | Instance ID         | level   | participant               |  symbol              | shortPosition    | shortValue  | netPosition    | netValue  | avgPrice   | account                 |   mtmValue     |
        | TC_012_Ins3_Res2    | ACCOUNT | [TC_012_Ins3.participant] | [TC_012_Ins3.symbol] | 2000.0           | 150000.0    | -2000.0        | -150000.0 | 75.0       | [TC_012_Ins3.account]   |   -180000.0     |

       Given instance "[TC_012_Ins1.Account Id] " of entity "Accounts" is deleted
       Given instance "[TC_012_Inst.Symbol]" of entity "Instruments" is deleted

       @done @fail
       Scenario: TC_013 Validate MTM Value when AI is empty and updated

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id     | Name          | Participant    |
        | TC_013_Ins1 | random(ACC,6)  | random(ACN,6) | HSBC           |

		And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
        | Instance ID | Symbol               |
        | TC_013_Inst | random(FR_BOND_CUR,6)|

        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol                  | type    | value  |
        | TC_013_MD1 | [TC_013_Inst.Symbol]     | LTP     | 55.0   |

        And "Position Update" messages are submitted with following values
        | Instance ID   | account                     | symbol                | quantity  | price | value   | side  | participant                 | notional |
        | TC_013_Ins2   | [TC_013_Ins1.Account Id]    | [TC_013_Inst.Symbol]  |  1000     | 60.0  | 60000.0 | SHORT |  [TC_013_Ins1.Participant]  | 100000   |

        Then response of the request "TC_013_Ins2" should be
        | Instance ID       | status   | subStatus   |
        | TC_013_Ins2_Res1  | POSTED   | PROCESSING  |

        And "Position" messages are filtered by "level,participant,account" should be
        | Instance ID         | level   | participant               |  symbol              | shortPosition    | shortValue | netPosition    | netValue | avgPrice  | account                  |   mtmValue     |
        | TC_013_Ins2_Res2    | ACCOUNT |  [TC_013_Ins2.participant]| [TC_013_Ins2.symbol] | 1000.0           | 75000.0    | -1000.0        | -75000.0 | 75.0       | [TC_013_Ins2.account]   |   -55000.0     |

        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol                  | type   | value  |
        | TC_013_MD2  | [TC_013_Inst.Symbol]    | AI     | 15.0   |

        Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
        | Instance ID         | level   | participant               |  symbol              | shortPosition    | shortValue  | netPosition    | netValue  | avgPrice   | account                 |   mtmValue     |
        | TC_013_Ins2_Res3    | ACCOUNT | [TC_013_Ins2.participant] | [TC_013_Ins2.symbol] | 1000.0           | 75000.0    | -1000.0        | -75000.0 |   75.0       | [TC_013_Ins2.account]   |   -70000.0     |

       Given instance "[TC_013_Ins1.Account Id] " of entity "Accounts" is deleted
       Given instance "[TC_013_Inst.Symbol]" of entity "Instruments" is deleted

       @done @fail
       Scenario: TC_014 Validate MTM Value when LTP is empty and updated

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id     | Name          | Participant    |
        | TC_014_Ins1 | random(ACC,6)  | random(ACN,6) | HSBC           |

		And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
        | Instance ID | Symbol               |
        | TC_014_Inst | random(FR_BOND_CUR,6)|

        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol                  | type    | value  |
        | TC_014_MD1 | [TC_014_Inst.Symbol]     | AI      | 25.0   |

        And "Position Update" messages are submitted with following values
        | Instance ID   | account                     | symbol                | quantity  | price | value   | side  | participant                 | notional |
        | TC_014_Ins2   | [TC_014_Ins1.Account Id]    | [TC_014_Inst.Symbol]  |  1000     | 60.0  | 60000.0 | SHORT |  [TC_014_Ins1.Participant]  | 100000   |

        Then response of the request "TC_014_Ins2" should be
        | Instance ID       | status   | subStatus   |
        | TC_014_Ins2_Res1  | POSTED   | PROCESSING  |

        And "Position" messages are filtered by "level,participant,account" should be
        | Instance ID         | level   | participant               |  symbol              | shortPosition    | shortValue | netPosition    | netValue | avgPrice   | account                  |   mtmValue     |
        | TC_014_Ins2_Res2    | ACCOUNT |  [TC_014_Ins2.participant]| [TC_014_Ins2.symbol] | 1000.0           | 85000.0    | -1000.0        | -85000.0 | 85.0       | [TC_014_Ins2.account]   |   -25000.0     |

        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol                  | type    | value  |
        | TC_014_MD2  | [TC_014_Inst.Symbol]    | LTP     | 65.0   |

        Then "Position" messages are filtered by "level,participant,account,shortPosition" should be
        | Instance ID         | level   | participant               |  symbol              | shortPosition    | shortValue  | netPosition    | netValue  | avgPrice   | account                 |   mtmValue     |
        | TC_014_Ins2_Res3    | ACCOUNT | [TC_014_Ins2.participant] | [TC_014_Ins2.symbol] | 1000.0           | 90000.0     | -1000.0        | -90000.0  |   90.0     | [TC_014_Ins2.account]   |   -90000.0     |

       Given instance "[TC_014_Ins1.Account Id] " of entity "Accounts" is deleted
       Given instance "[TC_014_Inst.Symbol]" of entity "Instruments" is deleted