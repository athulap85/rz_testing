Feature: refdata account add edit delete scenarios
Scenario: TC_001 Copy & create an new Account
    Given instance "RZ-Base-Acc-01" of entity "Accounts" is copied with following values
      | Instance ID | Account Id | Name             | Participant    | Risk Model  |
      | Acc01       | ACC_001    | Account Test 001 | MEM_002        | RM-1        |

#participant and Risk model changed to exisitng values.
Scenario: TC_011 Deleting instances
    Given instance "ACC_001" of entity "Accounts" is deleted

Scenario: TC_002 create an account without Account ID
     Given instance "ACC_001" of entity "Accounts" is copied with following values
     | Instance ID | Account Id | Name             | Participant    | Type        | Collateral Account |Account Currency|Category|Informational|Status    |Position Mode| Risk Model  |
     | Acc02       |            | Account Test 002 | MEM_002        | MARGIN      | ACC_001            |CAD             |CLIENT  |YES          |SUSPENDED |NET          | RM-1        |

    Then the request should be rejected with the error "Account Id is missing."


Scenario: TC_003 create an account without Account Name
    When instance of entity "Accounts" is created with following values
     | Instance ID | Account Id | Name             | Participant    | Type        |Account Currency|Category|Informational|Status    |Position Mode| Risk Model  |Position Key Ids|
     | Acc03       | ACC_003    |                  | MEM_002        | Margin      |CAD             |Client  |Yes          |SUSPENDED |NET          | RM-1        |RZ-Base-Pos-Key-01           |

    Then the request should be rejected with the error "Account Name is missing."

Scenario: TC_004 create an account without Participant
    When instance of entity "Accounts" is created with following values
     | Instance ID | Account Id | Name             | Participant    | Type        |Account Currency|Category|Informational|Status    |Position Mode|Position Key Ids|
     | Acc02       | ACC_002    | Account Test 002 |                | Margin      |CAD             |Client  |Yes          |Suspended |Net          |RZ-Base-Pos-Key-01           |

    Then the request should be rejected with the error "Participant is missing."

Scenario: TC_005 create an account with invalid Participant
    When instance of entity "Accounts" is created with following values
     | Instance ID | Account Id | Name             | Participant    | Type        |Account Currency|Category|Informational|Status    |Position Mode|Position Key Ids|
     | Acc02       | ACC_002    | Account Test 002 | Test           | Margin      |CAD             |Client  |Yes          |Suspended |Net          |RZ-Base-Pos-Key-01           |

    Then the request should be rejected with the error "Invalid Participant."

Scenario: TC_006 create an account without Type
    When instance of entity "Accounts" is created with following values
     | Instance ID | Account Id | Name             | Participant    | Type        |Account Currency|Category|Informational|Status    |Position Mode|Position Key Ids|
     | Acc02       | ACC_002    | Account Test 002 | MEM_001        |             |CAD             |Client  |Yes          |Suspended |Net          |RZ-Base-Pos-Key-01           |

    Then the request should be rejected with the error "Type is missing."

Scenario: TC_007 create an account with invalid Type
    When instance of entity "Accounts" is created with following values
     | Instance ID | Account Id | Name             | Participant    | Type        |Account Currency|Category|Informational|Status    |Position Mode|Position Key Ids|
     | Acc02       | ACC_002    | Account Test 002 | MEM_001        | Margin Test |CAD             |Client  |Yes          |Suspended |Net          |RZ-Base-Pos-Key-01           |

    Then the request should be rejected with the error "Invalid Type."

Scenario: TC_008 create an account without Collateral Account when Type = Margin invalid Type
    When instance of entity "Accounts" is created with following values
     | Instance ID | Account Id | Name             | Participant    | Type     |Collateral Account | Account Currency|Category|Informational|Status    |Position Mode|Position Key Ids|
     | Acc02       | ACC_002    | Account Test 002 | MEM_001        | Margin   |                   |CAD             |Client  |Yes          |Suspended |Net          |RZ-Base-Pos-Key-01           |

    Then the request should be rejected with the error "Collateral Account is missing."

Scenario: TC_009 create an account without Account Currency
    When instance of entity "Accounts" is created with following values
     | Instance ID | Account Id | Name             | Participant    | Type       | Account Currency|Category|Informational|Status    |Position Mode|Position Key Ids|
     | Acc02       | ACC_002    | Account Test 002 | MEM_001        | Collateral |                 |Client  |Yes          |Suspended |Net          |RZ-Base-Pos-Key-01           |

    Then the request should be rejected with the error "Account Currency is missing."

Scenario: TC_010 create an account with invalid Account Currency
    When instance of entity "Accounts" is created with following values
     | Instance ID | Account Id | Name             | Participant    | Type       | Account Currency|Category|Informational|Status    |Position Mode|Position Key Ids|
     | Acc02       | ACC_002    | Account Test 002 | MEM_001        | Collateral |  XXX            |Client  |Yes          |Suspended |Net          |RZ-Base-Pos-Key-01           |

    Then the request should be rejected with the error "Invalid Account Currency."

Scenario: TC_011 create an account without Category
    When instance of entity "Accounts" is created with following values
     | Instance ID | Account Id | Name             | Participant    | Type       | Account Currency|Category|Informational|Status    |Position Mode|Position Key Ids|
     | Acc02       | ACC_002    | Account Test 002 | MEM_001        | Collateral |  CAD            |        |Yes          |Suspended |Net          |RZ-Base-Pos-Key-01           |

    Then the request should be rejected with the error "Category is missing."

Scenario: TC_012 create an account with invalid Category
    When instance of entity "Accounts" is created with following values
     | Instance ID | Account Id | Name             | Participant    | Type       | Account Currency|Category|Informational|Status    |Position Mode|Position Key Ids|
     | Acc02       | ACC_002    | Account Test 002 | MEM_001        | Collateral |  CAD            | TEST   |Yes          |Suspended |Net          |RZ-Base-Pos-Key-01           |

    Then the request should be rejected with the error "Invalid Category."

Scenario: TC_013 create an account with invalid Classification
    When instance of entity "Accounts" is created with following values
     | Instance ID | Account Id | Name             | Participant    | Type       | Account Currency|Category|Classification|Informational|Status    |Position Mode|Position Key Ids|
     | Acc02       | ACC_002    | Account Test 002 | MEM_001        | Collateral |  CAD            | Client | House ISA    |Yes          |Suspended |Net          |RZ-Base-Pos-Key-01           |

    Then the request should be rejected with the error "Invalid Classification."

Scenario: TC_014 create an account without Informational
    When instance of entity "Accounts" is created with following values
     | Instance ID | Account Id | Name             | Participant    | Type       | Account Currency|Category|Classification|Informational|Status    |Position Mode|Position Key Ids|
     | Acc02       | ACC_002    | Account Test 002 | MEM_001        | Collateral |  CAD            | Client | ISA          |             |Suspended |Net          |RZ-Base-Pos-Key-01           |

    Then the request should be rejected with the error "Informational is missing."

Scenario: TC_015 create an account with invalid Informational
    When instance of entity "Accounts" is created with following values
     | Instance ID | Account Id | Name             | Participant    | Type       | Account Currency|Category|Classification|Informational|Status    |Position Mode|Position Key Ids|
     | Acc02       | ACC_002    | Account Test 002 | MEM_001        | Collateral |  CAD            | Client | ISA          | TRUE        |Suspended |Net          |RZ-Base-Pos-Key-01           |

    Then the request should be rejected with the error "Invalid Informational."

Scenario: TC_016 create an account without Status
    When instance of entity "Accounts" is created with following values
     | Instance ID | Account Id | Name             | Participant    | Type       | Account Currency|Category|Classification|Informational|Status    |Position Mode|Position Key Ids|
     | Acc02       | ACC_002    | Account Test 002 | MEM_001        | Collateral |  CAD            | Client | ISA          | Yes         |          |Net          |RZ-Base-Pos-Key-01           |

    Then the request should be rejected with the error "Status is missing."

Scenario: TC_017 create an account with invalid Status
    When instance of entity "Accounts" is created with following values
     | Instance ID | Account Id | Name             | Participant    | Type       | Account Currency|Category|Classification|Informational|Status    |Position Mode|Position Key Ids|
     | Acc02       | ACC_002    | Account Test 002 | MEM_001        | Collateral |  CAD            | Client | ISA          | Yes         | NEW      |Net          |RZ-Base-Pos-Key-01           |

    Then the request should be rejected with the error "Invalid Status."

Scenario: TC_018 create an account without Position Mode
    When instance of entity "Accounts" is created with following values
     | Instance ID | Account Id | Name             | Participant    | Type       | Account Currency|Category|Classification|Informational|Status    |Position Mode|Position Key Ids|
     | Acc02       | ACC_002    | Account Test 002 | MEM_001        | Collateral |  CAD            | Client | ISA          | Yes         |Suspended |             |RZ-Base-Pos-Key-01           |

    Then the request should be rejected with the error "Position Mode is missing."

Scenario: TC_019 create an account with invalid Position Mode
    When instance of entity "Accounts" is created with following values
     | Instance ID | Account Id | Name             | Participant    | Type       | Account Currency|Category|Classification|Informational|Status    |Position Mode|Position Key Ids|
     | Acc02       | ACC_002    | Account Test 002 | MEM_001        | Collateral |  CAD            | Client | ISA          | Yes         |Suspended | TEST        |RZ-Base-Pos-Key-01           |

    Then the request should be rejected with the error "Invalid Position Mode."

Scenario: TC_020 create an account without Position Key Id's
    When instance of entity "Accounts" is created with following values
     | Instance ID | Account Id | Name             | Participant    | Type       | Account Currency|Category|Classification|Informational|Status    |Position Mode|Position Key Ids|
     | Acc02       | ACC_002    | Account Test 002 | MEM_001        | Collateral |  CAD            | Client | ISA          | Yes         |Suspended | Net         |                |

    Then the request should be rejected with the error "Position Key Ids missing."

