Feature: Position Management


    Scenario: 1 Submitting a position update request

        When "Position Update" messages are submitted with following values
        | Instance ID | account | value | price | side | participant |
        | POU1        | Home1   | 1000  | 50.0  | SHORT|  CITI       |

        Then response of the request "POU1" should be
        | Instance ID | status   |
        | POU_Res1    | REJECTED |


    Scenario: 2 Validating the position message

        Given instance "HomeX" of entity "Accounts" is copied with following values
        | Instance ID | Participant   | Account Id          | Name            |
        | Acc01       | HSBC          | random(RZ_ST_ACC,5) | random(RZ_ST,5) |

        When "Position Update" messages are submitted with following values
        | Instance ID | account            | symbol       | price   | participant       | notional |
        | POU1        | [Acc01.Account Id] | BTCUSD_FUT9  | 99.0  | [Acc01.Participant] | 200      |
        | POU2        | [Acc01.Account Id] | BTCUSD_FUT9  | 98.0  | [Acc01.Participant] | 100      |

        Then "Position" messages are filtered by "level,participant,account,symbol,notional" should be
        | Instance ID | participant         | account            | level     | symbol       | notional |
        | POS_Res1    | [Acc01.Participant] | [Acc01.Account Id] | ACCOUNT   | BTCUSD_FUT9  | 300.0    |

        And "Position History" messages are filtered by "positionId,notional" should be
        | Instance ID   | participant         | account            | positionId             | symbol       | notional |
        | POS_History01 | [Acc01.Participant] | [Acc01.Account Id] | [POS_Res1.positionId]  | BTCUSD_FUT9  | 200.0    |
