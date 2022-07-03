Feature: Market Data Management

    Scenario: 1 Realtime Risk Factor Updates
        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol   | type  | value |
        | RFU01       | TST_INS1 | BB    | 1.0   |
        | RFU02       | TST_INS1 | AI    | 2.4   |
        | RFU03       | TST_INS1 | LTP   | 3.3   |

        Then response of the request "RFU01" should be
        | Instance ID  |
        | RFU_Res01    |

        Then "Realtime Risk Factor Update" messages are filtered by "id" should be
        | Instance ID  | id             | status  |
        | RFU_Req01    | [RFU_Res01.id] | POSTED  |


        Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp,ai" should be
        | Instance ID | symbol    | bb  | ai  | ltp |
        | RFU_Res1    | TST_INS1  | 1.0 | 2.4 | 3.3 |

    @wip
    Scenario: 2 Realtime Risk Factor Updates errors
        When "Realtime Risk Factor Update" messages are submitted with following values
        | Instance ID | symbol     | type  | value |
        | RFU01       | TST_INS_XX | BB    | 1.0   |


        Then response of the request "RFU01" should be
        | Instance ID  |
        | RFU_Res01    |

        Then "Realtime Risk Factor Update" messages are filtered by "id" should be
        | Instance ID  | id             | status    |
        | RFU_Req01    | [RFU_Res01.id] | REJECTED  |

        And "Realtime Risk Factor Update Error" messages are filtered by "externalId" should be
        | Instance ID  | externalId             | code     | message                             |
        | RRFU_error01 | [RFU_Req01.rfUpdateId] | 30100    | Symbol is not found in the system   |


