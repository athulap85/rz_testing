Feature: Market Data Management

    Scenario: 1 Realtime Risk Factor Updates
        When "Realtime_Risk_Factor_Updates" are submitted with following values
        | Instance ID | symbol   | type   | value |
        | RFU01       | TST_INS1 | BB     | 1.0   |
        | RFU02       | TST_INS1 | BO     | 2.0   |
        | RFU03       | TST_INS1 | LTP    | 3.0   |

    @wip
    Scenario: 2 Validating Realtime Risk Factor Updates
        Then "Realtime_Risk_Factor_Values" messages are filtered by "symbol" should be
        | Instance ID | symbol    | bb  | bo  | ltp |
        | RFU_Res1    | TST_INS1  | 1.0 | 2.0 | 3.0 |