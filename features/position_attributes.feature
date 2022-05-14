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

       @done  @issue
     Scenario: TC_004 Validating Symbol for Floating Rate Bond

      Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id     | Name             | Participant    |
        | TC_004_Ins  | random(ACC,6)  | random(ACN,6)    | HSBC           |

#        And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
#        | Instance ID | Instrument Type  | Symbol            |  Calculation Price Type  |
#        | TC_004_Inst | FIXED_RATE_BOND  | random(FR_BOND_,6)|  LTP                    |


        When "Position Update" messages are submitted with following values
        | Instance ID    | symbol               | quantity | price | side | participant              | type   | account                 |  notional | Position Key Id |
        | TC_004_Ins1    | FR_BOND              | 1000     | 50.0  | SHORT| [TC_004_Ins.Participant] | MARGIN | [TC_004_Ins.Account Id] |  1000     |  1              |

        Then response of the request "TC_004_Ins1" should be
        | Instance ID       | status    | subStatus            |
        | TC_004_Ins1_Res1  | POSTED    | PROCESSING           |

        Then "Position" messages are filtered by "level,account,participant" should be
        | Instance ID      | symbol                   | level    | account                       | participant                | type   | shortPosition   | netPosition |  positionKey  |
        | TC_004_Ins1_Res2 | [TC_004_Ins1.symbol]     | ACCOUNT  | [TC_004_Ins.Account Id]       | [TC_004_Ins1.participant]  | MARGIN | 1000.0          | -1000.0     |  NOT_EMPTY    |

      Given instance "[TC_004_Ins.Account Id]" of entity "Accounts" is deleted

     @wip
     Scenario: TC_005 Validating Currency

      Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id     | Name             | Participant    |
        | TC_005_Ins  | random(ACC,6)  | random(ACN,6)    | HSBC           |

       And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
        | Instance ID | Symbol            | Currency    |
        | TC_005_Inst | random(FR_BOND_,6)|  BTC        |


        When "Position Update" messages are submitted with following values
        | Instance ID    | symbol               | quantity | price | side | participant              | type   | account                 |  notional  |
        | TC_005_Ins1    | Bond_Test_1          | 1000     | 50.0  | SHORT| [TC_005_Ins.Participant] | MARGIN | [TC_005_Ins.Account Id] |  1000      |

        Then response of the request "TC_005_Ins1" should be
        | Instance ID       | status    | subStatus            |
        | TC_005_Ins1_Res1  | POSTED    | PROCESSING           |

        Then "Position" messages are filtered by "level,account,participant" should be
        | Instance ID      | symbol                   | level    | account                       | participant                | type   | shortPosition   | netPosition |   currency |
        | TC_005_Ins1_Res2 | [TC_005_Ins1.symbol]     | ACCOUNT  | [TC_005_Ins.Account Id]       | [TC_005_Ins1.participant]  | MARGIN | 1000.0          | -1000.0     |   USD      |

	    When "Position Update" messages are submitted with following values
        | Instance ID    | symbol               | quantity | price | side | participant              | type   | account                 |  notional  |
        | TC_005_Ins2    | [TC_005_Inst.Symbol] | 1000     | 50.0  | SHORT| [TC_005_Ins.Participant] | MARGIN | [TC_005_Ins.Account Id] |  1000      |

        Then response of the request "TC_005_Ins1" should be
        | Instance ID       | status    | subStatus            |
        | TC_005_Ins2_Res1  | POSTED    | PROCESSING           |

        Then "Position" messages are filtered by "level,account,participant" should be
        | Instance ID      | symbol                   | level    | account                       | participant                | type   | shortPosition   | netPosition |  currency |
        | TC_005_Ins2_Res2 | [TC_005_Ins2.symbol]     | ACCOUNT  | [TC_005_Ins.Account Id]       | [TC_005_Ins2.participant]  | MARGIN | 1000.0          | -1000.0     |  BTC      |


      Given instance "[TC_005_Ins.Account Id]" of entity "Accounts" is deleted
	  Given instance "[TC_005_Inst.Symbol]" of entity "Accounts" is deleted


