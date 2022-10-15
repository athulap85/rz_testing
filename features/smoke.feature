Feature: testing

  Scenario: RefData smoke

    Given instance "USD" of entity "Currencies" is copied with following values
    | Instance ID | Currency Id | Description | Currency Precision |
    | Cur01       | AED         | Dirham      | 2                  |

    And instance "AED" of entity "Currencies" is updated with following values
    | Instance ID | Currency Precision |
    | Curr02      | 5                  |

    Then instance "AED" of entity "Currencies" should be
    | Instance ID | Currency Precision | Description        |
    | Curr03      | 5                  | [Cur01.Description]|

    When instance of entity "Currencies" is created with following values
    | Instance ID | Currency Id  | Description  | Currency Precision |
    | Cur04       | AED1         | Dirham1      | 0                  |

    Given instance "AED" of entity "Currencies" is deleted
    Given instance "AED1" of entity "Currencies" is deleted

  @wip
  Scenario: Position smoke

    Given instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
    | Instance ID | Participant  | Account Id           | Name                  |
    | Acc01       | RZ-Base-Firm-1         | random(RZ_SMK_ACC,5) | random(RZ_SMK_ACC,5)  |

    When "Position Update" messages are submitted with following values
    | Instance ID | account             | quantity | value  | participant   |
    | POU1        | [Acc01.Account Id]  | 1000     | 50.2345  | RZ-Base-Firm-1          |

    Then response of the request "POU1" should be
    | Instance ID | status      |
    | POU_Res1    | POSTED      |

    Then "Position" messages are filtered by "level,participant,account" should be
    | Instance ID | participant | account            | level     | symbol       | netValue |
    | POS_Res1    | RZ-Base-Firm-1        | [Acc01.Account Id] | ACCOUNT   | BTCUSD_FUT9  | 50.23    |


    Given instance "[Acc01.Account Id]" of entity "Accounts" is deleted


  Scenario: Market data smoke
    When "Realtime Risk Factor Update" messages are submitted with following values
    | Instance ID | symbol   | type   | value |
    | RFU01       | TST_INS1 | BB     | 1.0   |
    | RFU02       | TST_INS1 | BO     | 2.0   |
    | RFU03       | TST_INS1 | LTP    | 3.0   |

    Then "Realtime Risk Factor Value" messages are filtered by "symbol,bb,bo,ltp" should be
    | Instance ID | symbol    | bb  | bo  | ltp |
    | RFU_Res1    | TST_INS1  | 1.0 | 2.0 | 3.0 |
