Feature: refdata add for position tests

    @participant
  Scenario: TC_001 Copy & create an new Participant

    Given instance "HSBC" of entity "Participants" is copied with following values
      | Instance ID        | Participant Id | Name          |  Type             |
      | TC_001_Req_001     | POS_001        | PART POS 001  |  TRADING_MEMBER   |

    And instance "HSBC" of entity "Participants" is copied with following values
      | Instance ID        | Participant Id | Name          |  Type             |
      | TC_001_Req_002     | POS_002        | PART POS 002  |  TRADING_MEMBER   |

      @positionkeys
    Scenario: TC_002 Copy & create new Position Keys

    Given instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID        | Position Key Id | Priority | Asset Class | Currency | Instrument Type | Symbol |
      | TC_002_Req_001     | PK_Rule1        | 1        | RATES       | YES      | FIXED_RATE_BOND | YES    |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID        | Position Key Id | Priority | Asset Class | Currency | Instrument Type | Symbol |
      | TC_002_Req_002     | PK_Rule2        | 2        | RATES       | YES      | FIXED_RATE_BOND | YES    |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID        | Position Key Id | Priority | Asset Class | Currency | Instrument Type    | Symbol |
      | TC_002_Req_003     | PK_Rule3        | 3        | RATES       | YES      | FLOATING_RATE_BOND | YES    |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID        | Position Key Id | Priority | Asset Class | Currency | Instrument Type    | Symbol |
      | TC_002_Req_004     | PK_Rule4        | 4        | RATES       | YES      | FIXED_RATE_BOND    | YES    |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID        | Position Key Id | Priority | Asset Class | Currency | Instrument Type    | Symbol |
      | TC_002_Req_005     | PK_Rule5        | 5        | RATES       | YES      | FLOATING_RATE_BOND | YES    |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID        | Position Key Id | Priority | Asset Class | Currency | Instrument Type   | Symbol |
      | TC_002_Req_006     | PK_Rule6        | 6        | RATES       | YES      |  null             | YES    |

  @account
  Scenario: TC_003 Copy & create a new Account

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID   | Account Id          | Name                 | Participant    | Type   | Account Currency | Category  |  Position Key Ids |
      | TC_003_Req_001|random(ACC_POS_001,6) |random(ACC Pos 001,6)|POS_001         |MARGIN  |   USD            | CLIENT    |  PK_Rule1         |

   And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID   | Account Id| Name      | Participant    | Type  | Account Currency | Category  |  Position Key Ids |
      | TC_003_Req_002|ACC_POS_002|ACC Pos 002|POS_002         |MARGIN |   USD            | CLIENT    | PK_Rule1,PK_Rule3 |

   And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID   | Account Id| Name      | Participant    | Type  | Account Currency | Category  |  Position Key Ids |
      | TC_003_Req_003|ACC_POS_003|ACC Pos 003|POS_003         |MARGIN |   USD            | CLIENT    | PK_Rule6          |

   And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID   | Account Id| Name      | Participant    | Type  | Account Currency | Category  |  Position Key Ids |
      | TC_003_Req_004|ACC_POS_004|ACC Pos 004|POS_004         |MARGIN |   USD            | CLIENT    | PK_Rule1,PK_Rule6 |

   And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID   | Account Id| Name      | Participant    | Type  | Account Currency | Category  |  Position Key Ids            |
      | TC_003_Req_005|ACC_POS_005|ACC Pos 005|POS_005         |MARGIN |   USD            | CLIENT    | PK_Rule4,PK_Rule5,PK_Rule6   |

   And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID   | Account Id| Name      | Participant    | Type  | Account Currency | Category  |  Position Key Ids |
      | TC_003_Req_006|ACC_POS_006|ACC Pos 006|POS_006         |MARGIN |   USD            | CLIENT    | PK_Rule3,PK_Rule5 |

   And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID   | Account Id| Name      | Participant    | Type  | Account Currency | Category  |  Position Key Ids |
      | TC_003_Req_007|ACC_POS_007|ACC Pos 007|POS_007         |MARGIN |   USD            | CLIENT    | PK_Rule4          |

   And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID   | Account Id| Name      | Participant    | Type  | Account Currency | Category  |  Position Key Ids |
      | TC_003_Req_008|ACC_POS_008|ACC Pos 008|POS_008         |MARGIN |   USD            | CLIENT    | PK_Rule5          |


@delete
  Scenario: Deleting position Keys
  Given instance "PK_Rule1" of entity "Position Keys" is deleted
  Given instance "PK_Rule2" of entity "Position Keys" is deleted
  Given instance "PK_Rule3" of entity "Position Keys" is deleted
  Given instance "PK_Rule4" of entity "Position Keys" is deleted
  Given instance "PK_Rule5" of entity "Position Keys" is deleted
  Given instance "PK_Rule6" of entity "Position Keys" is deleted

  @delete
  Scenario: Deleting Accounts
  Given instance "ACC_POS_001" of entity "Accounts" is deleted
  Given instance "ACC_POS_002" of entity "Accounts" is deleted
  Given instance "ACC_POS_003" of entity "Accounts" is deleted
  Given instance "ACC_POS_004" of entity "Accounts" is deleted
  Given instance "ACC_POS_005" of entity "Accounts" is deleted
  Given instance "ACC_POS_006" of entity "Accounts" is deleted
  Given instance "ACC_POS_007" of entity "Accounts" is deleted
  Given instance "ACC_POS_008" of entity "Accounts" is deleted
