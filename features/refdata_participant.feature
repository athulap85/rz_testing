Feature: refdata participant add edit delete scenarios

Scenario: TC_001 create an new Participant
    Given instance of entity "Participants" is created with following values
     | Instance ID | Participant Id | Name                 | LEI Code | Type             |Status|
     | Mem01       |  MEM_001       | Participant Test 001 | LEI_TEST | CLEARING_MEMBER  |ACTIVE|

Scenario: TC_002 Create Participant with already existing Participant ID
    When instance of entity "Participants" is created with following values
     | Instance ID | Participant Id | Name                 | LEI Code | Type             |Status|
     | Mem01       |  MEM_001       | Participant Test 001 | LEI_TEST | CLEARING_MEMBER  |ACTIVE|

    Then the request should be rejected with the error "Participant already exists"

Scenario: TC_003 create an Participant without Participant ID
    When instance of entity "Participants" is created with following values
     | Instance ID | Name                 | LEI Code | Type             |Status|
     | Mem02       | Participant Test 002 | LEI_TEST | CLEARING_MEMBER  |ACTIVE|

    Then the request should be rejected with the error "Participant id is required."

Scenario: TC_004 create an Participant without Name
    When instance of entity "Participants" is created with following values
     | Instance ID | Participant Id | LEI Code | Type             |Status|
     | Mem02       | MEM_002        | LEI_TEST | CLEARING_MEMBER  |ACTIVE|

    Then the request should be rejected with the error "Participant name is required."

Scenario: TC_005 Update the Name in an existing Participant
    Given instance "MEM_001" of entity "Participants" is updated with following values
      | Instance ID | Name                 |
      | Mem01       | Participant Test 011 |

Scenario: TC_006 create an Participant without Type
    When instance of entity "Participants" is created with following values
     | Instance ID | Participant Id | Name                 | LEI Code | Status|
     | Mem02       | MEM_002        | Participant Test 002 | LEI_TEST | ACTIVE|

    Then the request should be rejected with the error "Participant type is required."

Scenario: TC_007 create an Participant with invalid Type
    When instance of entity "Participants" is created with following values
     | Instance ID | Participant Id | Name                 | LEI Code | Type             |Status|
     | Mem02       | MEM_002        | Participant Test 002 | LEI_TEST | CLIENT TEST      |ACTIVE|

    Then the request should be rejected with the error "Invalid Type."

Scenario: TC_008 create an Participant without Status
    When instance of entity "Participants" is created with following values
     | Instance ID | Participant Id | Name                 | LEI Code | Type             |
     | Mem02       | MEM_002        | Participant Test 002 | LEI_TEST | CLIENT TEST      |

    Then the request should be rejected with the error "Status is missing."

Scenario: TC_009 create an Participant with invalid Status
    When instance of entity "Participants" is created with following values
     | Instance ID | Participant Id | Name                 | LEI Code | Type             |Status|
     | Mem02       | MEM_002        | Participant Test 002 | LEI_TEST | CLIENT TEST      | TEST |

    Then the request should be rejected with the error "Invalid Status."

Scenario: TC_010 Update the Status in an existing Participant
    Given instance "MEM_001" of entity "Participants" is updated with following values
      | Instance ID | Status   |
      | Mem01       | INACTIVE |

Scenario: TC_011 create an Participant with invalid Gross Exposure Limit
    When instance of entity "Participants" is created with following values
     | Instance ID | Participant Id | Name                 | LEI Code | Type             |Status|Gross Exposure Limit|
     | Mem02       | MEM_002        | Participant Test 002 | LEI_TEST | CLIENT TEST      |ACTIVE|TEST                |

    Then the request should be rejected with the error "Invalid Gross Exposure Limit."

Scenario: TC_012 create an Participant with invalid Net Exposure Limit
    When instance of entity "Participants" is created with following values
     | Instance ID | Participant Id | Name                 | LEI Code | Type             |Status|Net Exposure Limit|
     | Mem02       | MEM_002        | Participant Test 002 | LEI_TEST | CLIENT TEST      |ACTIVE|TEST              |

    Then the request should be rejected with the error "Invalid Net Exposure Limit."

Scenario: TC_013 create an Participant with invalid Margin Limit
    When instance of entity "Participants" is created with following values
     | Instance ID | Participant Id | Name                 | LEI Code | Type             |Status|Margin Limit|
     | Mem02       | MEM_002        | Participant Test 002 | LEI_TEST | CLIENT TEST      |ACTIVE|TEST        |

    Then the request should be rejected with the error "Invalid Margin Limit."

Scenario: TC_014 Update the LEI Code in an existing Participant
    Given instance "MEM_001" of entity "Participants" is updated with following values
      | Instance ID | LEI Code      |
      | Mem01       | LEI_TEST 1212 |

Scenario: TC_015 Update the Gross Exposure Limit/Net Exposure Limit/Margin Limit in an existing Participant
    Given instance "MEM_001" of entity "Participants" is updated with following values
      | Instance ID | Gross Exposure Limit |Net Exposure Limit|Margin Limit |
      | Mem01       | 0.5                  |0.5               |0.5          |
    And instance "MEM_001" of entity "Participants" is deleted