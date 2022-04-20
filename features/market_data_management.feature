Feature: Market Data Management

    Scenario: 1 Realtime Risk Factor Updates
        When "Risk_Factor_Updates" are submitted with following values
        | Instance ID | symbol      | type   | value |
        | RFU01       | BTCUSD_FUT9 | BB     | 1.0   |
        | RFU02       | BTCUSD_FUT9 | BO     | 2.0   |
        | RFU03       | BTCUSD_FUT9 | LTP    | 3.0   |
