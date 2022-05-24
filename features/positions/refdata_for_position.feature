Feature: refdata add for position tests

    @participant
  Scenario: TC_001 Copy & create an new Participant

    Given instance "HSBC" of entity "Participants" is copied with following values
      | Instance ID        | Participant Id | Name          |  Type             |
      | TC_001_Req_001     | PS_001        | PART PS 001  |  TRADING_MEMBER   |

    And instance "HSBC" of entity "Participants" is copied with following values
      | Instance ID        | Participant Id | Name          |  Type             |
      | TC_001_Req_002     | PS_002        | PART PS 002  |  TRADING_MEMBER   |

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
      | TC_002_Req_006     | PK_Rule6        | 6        | RATES       | YES      |                   | YES    |

  @account
  Scenario: TC_003 Copy & create a new Account

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID   | Account Id          | Name                 | Participant    | Type   | Account Currency | Category  |  Position Key Ids |
      | TC_003_Req_001|random(ACC_PS_001,6) |random(ACC Pos 001,6)| PS_001   |MARGIN  |   USD            | CLIENT    |  PK_Rule1         |

   And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID   | Account Id| Name      | Participant    | Type  | Account Currency | Category  |  Position Key Ids |
      | TC_003_Req_002|random(ACC_PS_002,6) |random(ACC Pos 002,6)|PS_002    |MARGIN |   USD            | CLIENT    | PK_Rule1,PK_Rule3 |

   Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID   | Account Id| Name      | Participant    | Type  | Account Currency | Category  |  Position Key Ids |
      | TC_003_Req_003|random(ACC_PS_003,6) |random(ACC Pos 003,6)|PS_001    |MARGIN |   USD            | CLIENT    | PK_Rule6          |

   And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID   | Account Id| Name      | Participant    | Type  | Account Currency | Category  |  Position Key Ids |
      | TC_003_Req_004|random(ACC_PS_004,6) |random(ACC Pos 004,6)|PS_002   |MARGIN |   USD            | CLIENT    | PK_Rule1,PK_Rule6 |

   And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID   | Account Id| Name      | Participant    | Type  | Account Currency | Category  |  Position Key Ids            |
      | TC_003_Req_005|random(ACC_PS_005,6) |random(ACC Pos 005,6)|PS_001    |MARGIN |   USD            | CLIENT    | PK_Rule4,PK_Rule5,PK_Rule6   |

   And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID   | Account Id| Name      | Participant    | Type  | Account Currency | Category  |  Position Key Ids |
      | TC_003_Req_006|random(ACC_PS_006,6) |random(ACC Pos 006,6)|PS_002    |MARGIN |   USD            | CLIENT    | PK_Rule3,PK_Rule5 |

   And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID   | Account Id| Name      | Participant    | Type  | Account Currency | Category  |  Position Key Ids |
      | TC_003_Req_007|random(ACC_PS_007,6) |random(ACC Pos 007,6)|PS_001    |MARGIN |   USD            | CLIENT    | PK_Rule4          |

   And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID   | Account Id| Name      | Participant    | Type  | Account Currency | Category  |  Position Key Ids |
      | TC_003_Req_008|random(ACC_PS_008,6) |random(ACC Pos 008,6)|PS_002    |MARGIN |   USD            | CLIENT    | PK_Rule5          |


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
  Given instance "ACC_PS_001" of entity "Accounts" is deleted
  Given instance "ACC_PS_002" of entity "Accounts" is deleted
  Given instance "ACC_PS_003" of entity "Accounts" is deleted
  Given instance "ACC_PS_004" of entity "Accounts" is deleted
  Given instance "ACC_PS_005" of entity "Accounts" is deleted
  Given instance "ACC_PS_006" of entity "Accounts" is deleted
  Given instance "ACC_PS_007" of entity "Accounts" is deleted
  Given instance "ACC_PS_008" of entity "Accounts" is deleted
