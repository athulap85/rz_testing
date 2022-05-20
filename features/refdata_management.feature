Feature: refdata add edit delete instances

   Scenario: TC_003 Copy & create an new Participant
    Given instance "HSBC" of entity "Participants" is copied with following values
      | Instance ID | Participant Id | Name                 | LEI Code | Type             |
      | Mem01       | MEM_001        | Participant Test 001 | LEI_TEST | CLEARING_MEMBER  |

  Scenario: TC_004 Update an existing Currency
    And instance "EUR" of entity "Currencies" is updated with following values
      | Instance ID | Currency Precision |
      | Curr01      | 5                  |

  Scenario: TC_005 Copy & create an new Time Zone
    Given instance "Timezone" of entity "Time Zones" is copied with following values
      | Instance ID | Time Zone Id | Name             |
      | TZ01        | TZ_001       | America/New York |

  Scenario: TC_006 Copy & create an new Risk Model.
    Given instance "RiskModel1" of entity "Risk Models" is copied with following values
      | Instance ID | Risk Model Id |
      | Rm01        | RM_001        |

  Scenario: TC_007 Copy & create an new Account
    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id | Name             | Participant    | Risk Model  |
      | Acc01       | ACC_001    | Account Test 001 | MEM_001        | RM_001      |

  Scenario: TC_008 Successfully adding an new currency
    Given instance of entity "Currencies" is created with following values
      | Instance ID | Currency Id  | Description  | Currency Precision |
      | Cur01       | AED1         | Dirham1      | 0                  |

  Scenario: TC_009 Duplicate Currency
    When instance of entity "Currencies" is created with following values
      | Instance ID | Currency Id  | Description  | Currency Precision |
      | Cur01       | AED1         | Dirham1      | 0                  |

    Then the request should be rejected with the error "Currency Id already exists."

  Scenario: TC_010 Copy & create an new Market
    Given instance "BINANCE" of entity "Markets" is copied with following values
      | Instance ID | Market Id   | Description  |
      | Mark01      | BINANCE1    | BINANCE 1    |

    Then instance "BINANCE1" of entity "Markets" should be
      | Instance ID | Market Id          | Description          |
      | Res01       | [Mark01.Market Id] | [Mark01.Description] |

    @test
      Scenario: TC_002 Copy & create an new Instrument
    Given instance "test_SYM_GB_01" of entity "Instruments" is copied with following values
      | Instance ID |Symbol          |
      | INST_1      | SL_DEV_BOND         |

@final
  Scenario: TC_011 Deleting instances
  Given instance "HNK_Short" of entity "Accounts" is deleted
  Given instance "HNK_Long" of entity "Accounts" is deleted
  Given instance "HN_Long" of entity "Accounts" is deleted
  Given instance "HN_Short" of entity "Accounts" is deleted
  Given instance "H_Long" of entity "Accounts" is deleted
  Given instance "H_Short" of entity "Accounts" is deleted
  Given instance "Home_NKG1" of entity "Accounts" is deleted

