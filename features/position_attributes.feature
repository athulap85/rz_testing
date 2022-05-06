Feature: Position Attributes

   @done
   Scenario: TC_001 Validating PositionID ( not ran with positionID exists)

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id   | Name       | Participant    |
        | TC_001_Ins  | ACC_001      | ACC_001    | HSBC           |

        When "Position_Updates" are submitted with following values
        | Instance ID    | symbol     | quantity | price | side | participant | account     |
        | TC_001_Ins1    | ACH        | 1000     | 50.0  | SHORT|  HSBC       | [TC_001_Ins.Account Id]     |

       Then response of the request "TC_001_Ins1" should be
        | Instance ID       | status    | subStatus            |
        | TC_001_Ins1_Res1  | POSTED    | PROCESSING           |

        Then "Position" messages are filtered by "level,account,participant" should be
        | Instance ID      | symbol     		   | level    | account                          | participant                | shortPosition         | netPosition| positionId |
        | TC_001_Ins1_Res2 | [TC_001_Ins1.symbol]  | ACCOUNT  | [TC_001_Ins1.account]            |  [TC_001_Ins1.participant] | 1000.0                | -1000.0    | exists     |

        Given instance "ACC_001" of entity "Accounts" is deleted

     @done
    Scenario: TC_002 Validating Position Type - Margin

      Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID | Account Id   | Name       | Participant    |
        | TC_002_Ins  | ACC_002      | ACC_002    | HSBC           |

        When "Position_Updates" are submitted with following values
        | Instance ID    | symbol      | quantity | price | side | participant | type   | account |
        | TC_002_Ins1    | ACH         | 1000     | 50.0  | SHORT|  HSBC       | MARGIN | [TC_002_Ins.Account Id] |

        Then response of the request "TC_002_Ins1" should be
        | Instance ID       | status    | subStatus            |
        | TC_002_Ins1_Res1  | POSTED    | PROCESSING           |

        Then "Position" messages are filtered by "level,account,participant" should be
        | Instance ID      | symbol                   | level    | account                       | participant                | type   | shortPosition              | netPosition|
        | TC_002_Ins1_Res2 | [TC_002_Ins1.symbol]     | ACCOUNT  | [TC_002_Ins1.account]         | [TC_002_Ins1.participant]  | MARGIN | 1000.0                     | -1000.0    |

      Given instance "ACC_002" of entity "Accounts" is deleted

       @blocked
    Scenario: TC_003 Validating Position Type - Collateral ? Failed due to a business validation of collateral

        Given instance "Home-Collateral" of entity "Accounts" is copied with following values
        | Instance ID | Account Id   | Name       | Participant    |
        | TC_003_Ins  | ACC_0033      | ACC_0033    | HSBC           |

        When "Position_Updates" are submitted with following values
        | Instance ID    | symbol      | quantity | price | side | participant | type       | account         |
        | TC_003_Ins1    | ACH         | 1000     | 50.0  | SHORT|  HSBC       | COLLATERAL | Home-Collateral |

        Then "Position" messages are filtered by "level,account,participant" should be
        | Instance ID       | symbol                 | level    | account                  | participant               | type       | shortPosition   | netPosition|
        | TC_003_Ins1_Res1  | [TC_003_Ins1.symbol]   | ACCOUNT  | [TC_003_Ins1.account]    | [TC_003_Ins1.participant]  | COLLATERAL | 1000.0          | -1000.0    |


