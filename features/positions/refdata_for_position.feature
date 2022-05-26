Feature: refdata add for position tests

    @participant
  Scenario: TC_001 Copy & create an new Participant

    Given instance "HSBC" of entity "Participants" is copied with following values
      | Instance ID        | Participant Id  | Name          |  Type             |
      | TC_001_Req_001     | RZ-PT-001        | PART PS 001  |  TRADING_MEMBER   |

    And instance "HSBC" of entity "Participants" is copied with following values
      | Instance ID        | Participant Id   | Name           |  Type             |
      | TC_001_Req_002     | RZ-PT-002        | PART PS 002    |  TRADING_MEMBER   |

      @positionkeys
    Scenario: TC_002 Copy & create new Position Keys

    Given instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID        | Position Key Id | Priority | Asset Class | Currency | Instrument Type | Symbol | Currency | Market  |
      | TC_002_Req_001     | RZ_PT_IT_01     | 1        | RATES       | YES      | FIXED_RATE_BOND | YES    |  YES     |  YES    |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID        | Position Key Id | Priority | Asset Class | Currency | Instrument Type | Symbol | Market  |
      | TC_002_Req_002     | RZ_PT_IT_02     | 2        | RATES       | YES      | FIXED_RATE_BOND | YES    |  NO     |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID        | Position Key Id | Priority | Asset Class | Currency | Instrument Type    | Symbol | Market   |
      | TC_002_Req_003     | RZ_PT_IT_03     | 1        | RATES       | YES      |                    | YES    |  YES     |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID        | Position Key Id | Priority | Asset Class | Currency | Instrument Type    | Symbol | Market   |
      | TC_002_Req_004     | RZ_PT_IT_04     | 2        | RATES       | YES      | FLOAT_RATE_BOND    | YES    |  NO      |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID        | Position Key Id | Priority | Asset Class | Currency | Instrument Type    | Symbol | Market   | Settlement Date |
      | TC_002_Req_005     | RZ_PT_AC_01     | 1        | RATES       | YES      | FIXED_RATE_BOND    | YES    | NO       | YES             |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID        | Position Key Id | Priority | Asset Class | Currency | Instrument Type   | Symbol |Market   | Settlement Date |
      | TC_002_Req_006     | RZ_PT_AC_02     | 2        | EQUITY      | YES      |                   | YES    | YES     | YES             |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID        | Position Key Id | Priority | Asset Class | Currency | Instrument Type    | Symbol | Market    | Settlement Date |
      | TC_002_Req_005     | RZ_PT_AC_03     | 2        | RATES       | YES      | FIXED_RATE_BOND    | YES    | YES       | NO              |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID        | Position Key Id | Priority | Asset Class | Currency | Instrument Type   | Symbol |Market   | Settlement Date |
      | TC_002_Req_006     | RZ_PT_AC_04     | 1        | RATES       | YES      |  FIXED_RATE_BOND  | YES    | YES     | YES             |

  @account
  Scenario: TC_003 Copy & create a new Account

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID   | Account Id             | Name                  | Participant    | Type   | Account Currency | Category  |  Position Key Ids        |
      | TC_003_Req_001|  RZ-PT-Acc-IT-01       | RZ-PT-Acc-IT-01       | RZ-PT-001      |MARGIN  |   USD            | CLIENT    |  RZ_PT_IT_01,RZ_PT_IT_02 |

   And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID   | Account Id             | Name                  | Participant    | Type  | Account Currency | Category  |  Position Key Ids       |
      | TC_003_Req_002|RZ-PT-Acc-IT-02         |RZ-PT-Acc-IT-02        |RZ-PT-002       |MARGIN |   USD            | CLIENT    | RZ_PT_IT_03,RZ_PT_IT_02 |

   Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID   | Account Id             | Name                  | Participant    | Type  | Account Currency | Category  |  Position Key Ids        |
      | TC_003_Req_003|RZ-PT-Acc-IT-03         |RZ-PT-Acc-IT-03        |RZ-PT-001       |MARGIN |   USD            | CLIENT    | RZ_PT_IT_01,RZ_PT_IT_04  |

   And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID   | Account Id             | Name                  | Participant    | Type  | Account Currency | Category  |  Position Key Ids       |
      | TC_003_Req_004|RZ-PT-Acc-AC-01         | RZ-PT-Acc-AC-01       |RZ-PT-002       |MARGIN |   USD            | CLIENT    | RZ_PT_AC_01,RZ_PT_AC_02 |

   And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID   | Account Id             | Name                  | Participant    | Type  | Account Currency | Category  |  Position Key Ids            |
      | TC_003_Req_005|RZ-PT-Acc-AC-02         |RZ-PT-Acc-AC-02        |RZ-PT-001       |MARGIN |   USD            | CLIENT    | RZ_PT_AC_01,RZ_PT_AC_03      |

   And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID   | Account Id             | Name                  | Participant    | Type  | Account Currency | Category  |  Position Key Ids        |
      | TC_003_Req_006|RZ-PT-Acc-AC-03         |RZ-PT-Acc-AC-03        |RZ-PT-002       |MARGIN |   USD            | CLIENT    | RZ_PT_AC_04,RZ_PT_AC_03  |

   And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID   | Account Id             | Name                  | Participant    | Type  | Account Currency | Category  |  Position Key Ids         |
      | TC_003_Req_007|RZ-PT-Acc-AC-04         |RZ-PT-Acc-AC-04        |RZ-PT-001       |MARGIN |   USD            | CLIENT    | RZ_PT_AC_01,RZ_PT_AC_04   |
    
  @instrument
  Scenario: TC_004 Copy & create a new Instrument

    When  instance "Bond_Test_1" of entity "Instruments" is copied with following values
       | Instance ID  | Symbol               | Size Multiplier|
       | TC_015_Inst  | POS_0001             |  2             |

@delete
  Scenario: Deleting position Keys
  Given instance "RZ_PT_IT_01" of entity "Position Keys" is deleted
  Given instance "RZ_PT_IT_02" of entity "Position Keys" is deleted
  Given instance "RZ_PT_IT_03" of entity "Position Keys" is deleted
  Given instance "RZ_PT_IT_04" of entity "Position Keys" is deleted
  Given instance "RZ_PT_AC_01" of entity "Position Keys" is deleted
  Given instance "RZ_PT_AC_02" of entity "Position Keys" is deleted
  Given instance "RZ_PT_AC_03" of entity "Position Keys" is deleted
  Given instance "RZ_PT_AC_04" of entity "Position Keys" is deleted

  @delete
  Scenario: Deleting Accounts
  Given instance "RZ-PT-Acc-001" of entity "Accounts" is deleted
  Given instance "RZ-PT-Acc-002" of entity "Accounts" is deleted
  Given instance "RZ-PT-Acc-003" of entity "Accounts" is deleted
  Given instance "RZ-PT-Acc-004" of entity "Accounts" is deleted
  Given instance "RZ-PT-Acc-005" of entity "Accounts" is deleted
  Given instance "RZ-PT-Acc-006" of entity "Accounts" is deleted
  Given instance "RZ-PT-Acc-007" of entity "Accounts" is deleted
  Given instance "RZ-PT-Acc-008" of entity "Accounts" is deleted
