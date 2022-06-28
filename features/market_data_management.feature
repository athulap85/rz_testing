Feature: Market Data Management

    Scenario: 1 Realtime Risk Factor Updates
        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol   | type  | value |
        | RFU01       | TST_INS1 | BB    | 1.0   |
        | RFU02       | TST_INS1 | BO    | 2.0   |
        | RFU03       | TST_INS1 | LTP   | 3.0   |

        Then response of the request "RFU01" should be
        | Instance ID  |
        | RFU_Res01    |

        Then "Realtime Risk Factor Update" messages are filtered by "id" should be
        | Instance ID  | id             | status  |
        | RFU_Req01    | [RFU_Res01.id] | POSTED  |


        Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
        | Instance ID | symbol    | bb  | bo  | ltp |
        | RFU_Res1    | TST_INS1  | 1.0 | 2.0 | 3.0 |