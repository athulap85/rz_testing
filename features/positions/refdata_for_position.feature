Feature: refdata add for position tests

  @participant
  Scenario: TC_001 Copy & create an new Participant

    Given instance "HSBC" of entity "Participants" is copied with following values
      | Instance ID | Participant Id | Name        | Type           |
      | Part_001    | PS_OO1      | PS_OO1 | CLIENT |

    And instance "HSBC" of entity "Participants" is copied with following values
      | Instance ID | Participant Id | Name        | Type           |
      | Part_002    | PS_002      | PS_002 | CLIENT |

  @positionkeys
  Scenario: TC_002 Copy & create new Position Keys

    Given instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID | Position Key Id | Priority | Asset Class | Currency | Instrument Type | Symbol | Currency | Market |
      | RZ_PT_RULE_001    | RZ_PT_IT_001     | 1        | RATES       | YES      | FIXED_RATE_BOND | YES    | YES      | YES    |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID | Position Key Id | Priority | Asset Class | Currency | Instrument Type | Symbol |
      | RZ_PT_RULE_002    | RZ_PT_IT_002     | 2        | RATES       | YES      | FIXED_RATE_BOND | YES    |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID | Position Key Id | Priority | Asset Class | Currency | Instrument Type | Symbol | Market |
      | RZ_PT_RULE_003    | RZ_PT_IT_003     | 1        | RATES       | YES      |                 | YES    | YES    |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID | Position Key Id | Priority | Asset Class | Currency | Instrument Type | Symbol |
      | RZ_PT_RULE_004    | RZ_PT_IT_004     | 2        | RATES       | YES      | FLOAT_RATE_BOND | YES    |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID | Position Key Id | Priority | Asset Class | Currency | Instrument Type | Symbol | Settlement Date |
      | RZ_PT_RULE_005    | RZ_PT_AC_001     | 1        | RATES       | YES      | FIXED_RATE_BOND | YES    | YES             |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID | Position Key Id | Priority | Asset Class | Currency | Instrument Type | Symbol | Market | Settlement Date |
      | RZ_PT_RULE_006    | RZ_PT_AC_002     | 2        | EQUITY      | YES      |                 | YES    | YES    | YES             |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID | Position Key Id | Priority | Asset Class | Currency | Instrument Type | Symbol | Market |
      | RZ_PT_RULE_005    | RZ_PT_AC_003     | 2        | RATES       | YES      | FIXED_RATE_BOND | YES    | YES    |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID | Position Key Id | Priority | Asset Class | Currency | Instrument Type | Symbol | Market | Settlement Date |
      | RZ_PT_RULE_006    | RZ_PT_AC_004     | 1        | RATES       | YES      | FIXED_RATE_BOND | YES    | YES    | YES             |

  @account
  Scenario: TC_003 Copy & create a new Account

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID    | Account Id      | Name            | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | TC_003_Req_001 | RZ-PT-ACC-001 | RZ-PT-ACC-001_TEST | PS_001   | MARGIN | USD              | CLIENT   | RZ_PT_IT_001,RZ_PT_IT_002 |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID    | Account Id      | Name            | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | TC_003_Req_002 | RZ-PT-ACC-002 | RZ-PT-ACC-002 | PS_002   | MARGIN | USD              | CLIENT   | RZ_PT_IT_003,RZ_PT_IT_002 |

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID    | Account Id      | Name            | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | TC_003_Req_003 | RZ-PT-ACC-003 | RZ-PT-ACC-003 | PS_001   | MARGIN | USD              | CLIENT   | RZ_PT_IT_001,RZ_PT_IT_004 |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID    | Account Id      | Name            | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | TC_003_Req_004 | RZ-PT-Acc-AC-001 | RZ-PT-Acc-AC-001 | PS_002   | MARGIN | USD              | CLIENT   | RZ_PT_AC_001,RZ_PT_AC_002 |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID    | Account Id      | Name            | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | TC_003_Req_005 | RZ-PT-Acc-AC-002 | RZ-PT-Acc-AC-002 | PS_001   | MARGIN | USD              | CLIENT   | RZ_PT_AC_001,RZ_PT_AC_003 |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID    | Account Id      | Name            | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | TC_003_Req_006 | RZ-PT-Acc-AC-003 | RZ-PT-Acc-AC-003 | PS_002   | MARGIN | USD              | CLIENT   | RZ_PT_AC_004,RZ_PT_AC_003 |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID    | Account Id      | Name            | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | TC_003_Req_007 | RZ-PT-Acc-AC-004 | RZ-PT-Acc-AC-004 | PS_001   | MARGIN | USD              | CLIENT   | RZ_PT_AC_001,RZ_PT_AC_004 |

  @instrument
  Scenario: TC_004 Copy & create a new Instrument

#    Given  instance "Bond_Test_1" of entity "Instruments" is copied with following values
#      | Instance ID | Symbol              | Size Multiplier |
#      | TC_015_Inst | RZ_PT_Inst_Bond_003 | 2               |
#
#    And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
#      | Instance ID  | Symbol              | Size Multiplier |
#      | TC_015_Inst1 | RZ_PT_Inst_Bond_001 | 1               |
#
#    And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
#      | Instance ID  | Symbol              | Size Multiplier |
#      | TC_015_Inst2 | RZ_PT_Inst_Bond_002 | 1               |

    Given  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID  | Symbol              | Size Multiplier | Instrument Type   |
      | TC_015_Inst2 | RZ_PT_Inst_Bond_4 | 2               | ZERO_COUPON_BOND |

  @delete
  Scenario: Deleting position Keys
    Given instance "RZ_PT_IT_001" of entity "Position Keys" is deleted
    Given instance "RZ_PT_IT_002" of entity "Position Keys" is deleted
    Given instance "RZ_PT_IT_003" of entity "Position Keys" is deleted
    Given instance "RZ_PT_IT_004" of entity "Position Keys" is deleted
    Given instance "RZ_PT_AC_001" of entity "Position Keys" is deleted
    Given instance "RZ_PT_AC_002" of entity "Position Keys" is deleted
    Given instance "RZ_PT_AC_003" of entity "Position Keys" is deleted
    Given instance "RZ_PT_AC_004" of entity "Position Keys" is deleted

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
