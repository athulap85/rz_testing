Feature: testing

  @wip
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


  Scenario: Position smoke

    Given instance "HSBC" of entity "Participants" is copied with following values
    | Instance ID| Participant Id    |
    | Part01     | TEST_HSBC        |

    And instance "Home" of entity "Accounts" is copied with following values
    | Instance ID | Participant  | Account Id | Name       |
    | Acc01       | TEST_HSBC    | TestAcc    | TestAcc    |

    When "Position_Updates" are submitted with following values
    | Instance ID | account    | quantity | price | participant  |
    | POU1        | TestAcc    | 1000     | 50.0  | TEST_HSBC    |

    Then response of the request "POU1" should be
    | Instance ID | status      |
    | POU_Res1    | POSTED      |

    Then "Position" messages are filtered by "level,participant,account" should be
    | Instance ID | participant | account   | level     | symbol       |
    | POS_Res1    | TEST_HSBC   | TestAcc   | ACCOUNT   | BTCUSD_FUT9  |


    Given instance "TestAcc" of entity "Accounts" is deleted
    Given instance "TEST_HSBC" of entity "Participants" is deleted




  Scenario: Market data smoke
    When "Realtime_Risk_Factor_Updates" are submitted with following values
    | Instance ID | symbol   | type   | value |
    | RFU01       | TST_INS1 | BB     | 1.0   |
    | RFU02       | TST_INS1 | BO     | 2.0   |
    | RFU03       | TST_INS1 | LTP    | 3.0   |
