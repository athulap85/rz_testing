Feature: Position Management


    Scenario: 1 Submitting a position update request

        When "Position Update" messages are submitted with following values
        | Instance ID | account | value | price | side | participant |
        | POU1        | Home1   | 1000  | 50.0  | SHORT|  CITI       |

        Then response of the request "POU1" should be
        | Instance ID | status   |
        | POU_Res1    | REJECTED |


    Scenario: 2 Validating the position message
        Then "Position" messages are filtered by "level,participant,account,symbol" should be
        | Instance ID | participant | account   | level     | symbol       | shortPosition |
        | POU_Res1    | HSBC        | Home      | ACCOUNT   | BTCUSD_FUT9  | 0.0           |