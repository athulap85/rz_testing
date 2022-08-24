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

    Given instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID | Position Key Id | Priority | Asset Class | Instrument Type | Trade Type | Currency | Symbol | Expiry Date |
      | Key_002     | RZ_PT_PK_02     | 2        | RATES       | FIXED_RATE_BOND | STANDARD   | YES      | YES    | YES         |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID | Position Key Id | Priority | Asset Class | Instrument Type | Trade Type | Symbol | Currency | Settlement Date |
      | Key_003     | RZ_PT_PK_03     | 1        | RATES       |                 | STANDARD   | YES    | YES      | YES             |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID | Position Key Id | Priority | Asset Class | Instrument Type    | Trade Type | Currency | Symbol | Expiry Date | Settlement Date |
      | Key_004     | RZ_PT_PK_04     | 1        | RATES       | FLOATING_RATE_BOND | STANDARD   | YES      | YES    | YES         | YES             |

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

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID | Position Key Id | Priority | Asset Class | Instrument Type | Trade Type | Currency | Symbol | Market | Trade Date | Settlement Date | Expiry Date | Status   |
      | Key_009     | RZ_PT_PK_09     | 1        | RATES       | FIXED_RATE_BOND | STANDARD   | YES      | YES    | YES    | YES        | YES             | YES         | INACTIVE |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID | Position Key Id | Priority | Asset Class | Instrument Type     | Trade Type | Trade Date | Status |
      | Key_010     | RZ_PT_PK_10     | 1        | RATES       | STEPPED_COUPON_BOND | STANDARD   | YES        | ACTIVE |

    And instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID | Position Key Id | Priority | Asset Class | Instrument Type  | Trade Type | Settlement Date | Status |
      | Key_011     | RZ_PT_PK_11     | 1        | RATES       | ZERO_COUPON_BOND | STANDARD   | YES             | ACTIVE |

  @account
  Scenario: TC_003 Copy & create new Accounts for Position Testing

    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id | Name       | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_001     | RZ-PT-AC-1 | RZ-PT-AC-1 | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_01,RZ_PT_PK_02 |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id | Name       | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_002     | RZ-PT-AC-2 | RZ-PT-AC-2 | RZ-PT-02    | MARGIN | USD              | CLIENT   | RZ_PT_PK_03,RZ_PT_PK_02 |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id | Name       | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_003     | RZ-PT-AC-3 | RZ-PT-AC-3 | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_01,RZ_PT_PK_04 |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id | Name       | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_004     | RZ-PT-AC-4 | RZ-PT-AC-4 | RZ-PT-02    | MARGIN | USD              | CLIENT   | RZ_PT_PK_01,RZ_PT_PK_02 |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id | Name       | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_005     | RZ-PT-AC-5 | RZ-PT-AC-5 | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_01,RZ_PT_PK_03 |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id | Name       | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_006     | RZ-PT-AC-6 | RZ-PT-AC-6 | RZ-PT-02    | MARGIN | USD              | CLIENT   | RZ_PT_PK_04,RZ_PT_PK_03 |

    And instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id | Name       | Participant | Type   | Account Currency | Category | Position Key Ids        |
      | Acc_007     | RZ-PT-AC-7 | RZ-PT-AC-7 | RZ-PT-01    | MARGIN | USD              | CLIENT   | RZ_PT_PK_01,RZ_PT_PK_04 |

  @instrument
  Scenario: TC_004 Copy & create new Instruments for Position Testing

    Given  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol              | Size Multiplier |
      | Inst_001    | RZ_PT_Inst_Bond_003 | 2               |

    And  instance "Bond_Test_1" of entity "Instruments" is copied with following values
      | Instance ID | Symbol              | Size Multiplier | Expiry Date |
      | Inst_002    | RZ_PT_Inst_Bond_001 | 1               | 2024-06-07  |

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
    Given instance "RZ-PT-AC-001" of entity "Accounts" is deleted
    Given instance "RZ-PT-AC-002" of entity "Accounts" is deleted
    Given instance "RZ-PT-AC-003" of entity "Accounts" is deleted
    Given instance "RZ-PT-AC-004" of entity "Accounts" is deleted
    Given instance "RZ-PT-AC-005" of entity "Accounts" is deleted
    Given instance "RZ-PT-AC-006" of entity "Accounts" is deleted
    Given instance "RZ-PT-AC-007" of entity "Accounts" is deleted
    Given instance "RZ-PT-AC-008" of entity "Accounts" is deleted


  @update
  Scenario: Update the Status in an existing PositionKey
    Given instance "RZ_PT_AC_4" of entity "Position Keys" is updated with following values
      | Instance ID | Status   |
      | Update01    | INACTIVE |
