Feature: refdata account add edit delete scenarios
Scenario: TC_001 Copy & create an new Account
    Given instance "Home" of entity "Accounts" is copied with following values
      | Instance ID | Account Id | Name             | Participant    | Risk Model  |
      | Acc01       | ACC_001    | Account Test 001 | MEM_001        | RM_001      |

Scenario: TC_002 create an account without Account ID
    When instance of entity "Accounts" is created with following values
     | Instance ID | Account Id | Name             | Participant    | Type        |Account Currency|Category|Informational|Status    |Position Mode|Position Key Ids|
     | Acc02       |            | Account Test 002 | MEM_001        | Margin      |CAD             |Client  |Yes          |Suspended |Net          |Rule1           |

    Then the request should be rejected with the error "Account Id is missing."
