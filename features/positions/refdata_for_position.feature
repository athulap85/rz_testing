Feature: refdata add for position tests

  @participant
  Scenario: TC_001 Copy & create new Participants for Position Testing

    Given instance "HSBC" of entity "Participants" is copied with following values
      | Instance ID | Participant Id | Name     | Type   |
      | Part_001    | RZ-PT-01       | RZ-PT-01 | CLIENT |

    And instance "HSBC" of entity "Participants" is copied with following values
      | Instance ID | Participant Id | Name     | Type   |
      | Part_002    | RZ-PT-02       | RZ-PT-02 | CLIENT |

  @positionkeys
  Scenario: TC_002 Copy & create new Position Keys for Position Testing

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID | Position Key Id | Priority | Asset Class | Instrument Type | Trade Type | Currency | Symbol | Expiry Date |
      | Key_002     | RZ_PT_PK_02     | 2        | RATES       | FIXED_RATE_BOND | STANDARD   | YES      | YES    | YES        |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID | Position Key Id | Priority | Asset Class | Instrument Type | Trade Type | Symbol | Currency | Settlement Date |
      | Key_003     | RZ_PT_PK_03     | 1        | RATES       |                 | STANDARD   | YES    | YES      | YES             |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID | Position Key Id | Priority | Asset Class | Instrument Type | Trade Type | Currency | Symbol | Expiry Date |
      | Key_004     | RZ_PT_PK_04     | 1        | RATES       | FLOATING_RATE_BOND | STANDARD   | YES      | YES    | YES         |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID | Position Key Id | Priority | Asset Class | Instrument Type | Trade Type | Currency | Symbol | Expiry Date |
      | Key_005     | RZ_PT_PK_05     | 2        | RATES       | FIXED_RATE_BOND |            | YES      | YES    | YES         |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID | Position Key Id | Priority | Asset Class | Instrument Type | Trade Type | Currency | Symbol | Trade Date | Settlement Date |
      | Key_006     | RZ_PT_PK_06     | 1        | EQUITY      |                 | STANDARD   | YES      | YES    | YES        | YES             |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID | Position Key Id | Priority | Asset Class | Instrument Type | Trade Type | Currency | Symbol | Market | Settlement Date | Status   |
      | Key_007     | RZ_PT_PK_07     | 1        | RATES       | FIXED_RATE_BOND |            | YES      | YES    | YES    | YES             | INACTIVE |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID | Position Key Id | Priority | Asset Class | Instrument Type | Trade Type | Currency | Symbol | Market | Trade Date | Status   |
      | Key_008     | RZ_PT_PK_08     | 1        | RATES       | FIXED_RATE_BOND | STANDARD   | YES      | YES    | YES    | YES        | INACTIVE |

  @account
  Scenario: TC_003 Copy & create new Accounts for Position Testing

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id    | Name               | Participant | Type   | Account Currency | Category | Position Key Ids          |
      | Acc_001     | RZ-PT-ACC-1 | RZ-PT-ACC-001_TEST | PS_001      | MARGIN | USD              | CLIENT   | RZ_PT_PK_01,RZ_PT_PK_02 |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id    | Name          | Participant | Type   | Account Currency | Category | Position Key Ids          |
      | Acc_002     | RZ-PT-ACC-002 | RZ-PT-ACC-002 | PS_002      | MARGIN | USD              | CLIENT   | RZ_PT_PK_003,RZ_PT_PK_002 |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id    | Name          | Participant | Type   | Account Currency | Category | Position Key Ids          |
      | Acc_003     | RZ-PT-ACC-003 | RZ-PT-ACC-003 | PS_001      | MARGIN | USD              | CLIENT   | RZ_PT_PK_001,RZ_PT_PK_004 |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id       | Name             | Participant | Type   | Account Currency | Category | Position Key Ids          |
      | Acc_004     | RZ-PT-Acc-AC-001 | RZ-PT-Acc-AC-001 | PS_002      | MARGIN | USD              | CLIENT   | RZ_PT_AC_001,RZ_PT_AC_002 |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id       | Name             | Participant | Type   | Account Currency | Category | Position Key Ids          |
      | Acc_005     | RZ-PT-Acc-AC-002 | RZ-PT-Acc-AC-002 | PS_001      | MARGIN | USD              | CLIENT   | RZ_PT_AC_001,RZ_PT_AC_003 |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id       | Name             | Participant | Type   | Account Currency | Category | Position Key Ids          |
      | Acc_006     | RZ-PT-Acc-AC-003 | RZ-PT-Acc-AC-003 | PS_002      | MARGIN | USD              | CLIENT   | RZ_PT_AC_004,RZ_PT_AC_003 |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id       | Name             | Participant | Type   | Account Currency | Category | Position Key Ids          |
      | Acc_007     | RZ-PT-Acc-AC-004 | RZ-PT-Acc-AC-004 | PS_001      | MARGIN | USD              | CLIENT   | RZ_PT_AC_001,RZ_PT_AC_004 |

  @instrument
  Scenario: TC_004 Copy & create new Instruments for Position Testing

    Given  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol              | Size Multiplier |
      | Inst_001    | RZ_PT_Inst_Bond_003 | 2               |

    And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol              | Size Multiplier |
      | Inst_002    | RZ_PT_Inst_Bond_001 | 1               |

    And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol              | Size Multiplier |
      | Inst_003    | RZ_PT_Inst_Bond_002 | 1               |

    And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol              | Size Multiplier | Instrument Type |
      | Inst_004    | RZ_PT_Inst_Bond_004 | 2               | FLOAT_RATE_BOND |

    And  instance "GOOG" of entity "Instruments" is copied with following values
      | Instance ID | Symbol              | Size Multiplier | Instrument Type |
      | Inst_005    | RZ_PT_Inst_Equity_1 | 2               | SPOT

    And  instance "GOOG" of entity "Instruments" is copied with following values
      | Instance ID | Symbol              | Size Multiplier | Instrument Type |
      | Inst_005    | RZ_PT_Inst_Equity_1 | 1               | SPOT            |


  @deletekey
  Scenario: Delete position Keys created for Position Testing
    Given instance "RZ_PT_PK_01" of entity "Position Keys" is deleted
    Given instance "RZ_PT_PK_02" of entity "Position Keys" is deleted
    Given instance "RZ_PT_PK_03" of entity "Position Keys" is deleted
    Given instance "RZ_PT_PK_04" of entity "Position Keys" is deleted
    Given instance "RZ_PT_AC_01" of entity "Position Keys" is deleted
    Given instance "RZ_PT_AC_02" of entity "Position Keys" is deleted
    Given instance "RZ_PT_AC_03" of entity "Position Keys" is deleted
    Given instance "RZ_PT_AC_04" of entity "Position Keys" is deleted

  @delete
  Scenario: Delete Accounts created for Position Testing
    Given instance "RZ-PT-Acc-001" of entity "Accounts" is deleted
    Given instance "RZ-PT-Acc-002" of entity "Accounts" is deleted
    Given instance "RZ-PT-Acc-003" of entity "Accounts" is deleted
    Given instance "RZ-PT-Acc-004" of entity "Accounts" is deleted
    Given instance "RZ-PT-Acc-005" of entity "Accounts" is deleted
    Given instance "RZ-PT-Acc-006" of entity "Accounts" is deleted
    Given instance "RZ-PT-Acc-007" of entity "Accounts" is deleted
    Given instance "RZ-PT-Acc-008" of entity "Accounts" is deleted


  @update
  Scenario: Update the Status in an existing PositionKey
    Given instance "RZ_PT_AC_4" of entity "Position Keys" is updated with following values
      | Instance ID | Status   |
      | Update01    | INACTIVE |
