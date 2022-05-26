Feature: Market Data Management

    Scenario: 1 Realtime Risk Factor Updates
        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol            | type   | value |
        | RFU01       | FR_BOND_CUR654972 | BB     | 1.0   |
        | RFU02       | FR_BOND_CUR654972 | BO     | 2.0   |
        | RFU03       | FR_BOND_CUR654972 | LTP    | 3.0   |

        Then "Realtime Risk Factor Value" messages are filtered by "symbol" should be
        | Instance ID | symbol             | bb  | bo  | ltp |
        | RFU_Res1    | FR_BOND_CUR654972  | 1.0 | 2.0 | 3.0 |