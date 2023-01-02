Feature: Position Management

  @negative3
  Scenario: TC_PU_001 Validating Symbol - Mandatory Field

    ## Validate Position Update submitted with EMPTY Symbol
    When "Position Update" messages are submitted with following values
      | Instance ID  | account    | value | price | side  | participant | symbol | notional |
      | PosUpdate_01 | RZ-PT-AC-1 | 100   | 50.0  | SHORT | RZ-PT-01    |        | 500.0    |

    Then response of the request "PosUpdate_01" should be
      | Instance ID       | status   | subStatus           | positionUpdateId |
      | PosUpdate_01_Res1 | REJECTED | BUSINESS_VALIDATION | NOT_EMPTY        |

    And "Position Update Error" messages are filtered by "externalId" should be
      | Instance ID          | externalId                           | code  | message                               |
      | PosUpdate_01_error01 | [PosUpdate_01_Res1.positionUpdateId] | 20100 | Instrument is not found in the system |

    ## Validate Position Update submitted with NULL Symbol
    When "Position Update" messages are submitted with following values
      | Instance ID  | account    | value | price | side  | participant | symbol | notional |
      | PosUpdate_02 | RZ-PT-AC-1 | 100   | 50.0  | SHORT | RZ-PT-01    |        | 10000.0  |

    Then response of the request "PosUpdate_02" should be
      | Instance ID       | status   | subStatus           | positionUpdateId |
      | PosUpdate_02_Res1 | REJECTED | BUSINESS_VALIDATION | NOT_EMPTY        |

    And "Position Update Error" messages are filtered by "externalId" should be
      | Instance ID          | externalId                           | code  | message                               |
      | PosUpdate_02_error01 | [PosUpdate_02_Res1.positionUpdateId] | 20100 | Instrument is not found in the system |

    ## Validate Position Update submitted with INVALID Symbol
    When "Position Update" messages are submitted with following values
      | Instance ID  | account    | value | price | side  | participant | symbol    | notional |
      | PosUpdate_03 | RZ-PT-AC-1 | 100   | 50.0  | SHORT | RZ-PT-01    | PQRST1234 | 15000.0  |

    Then response of the request "PosUpdate_03" should be
      | Instance ID       | status   | subStatus           | positionUpdateId |
      | PosUpdate_03_Res1 | REJECTED | BUSINESS_VALIDATION | NOT_EMPTY        |

    And "Position Update Error" messages are filtered by "externalId" should be
      | Instance ID          | externalId                           | code  | message                               |
      | PosUpdate_03_error01 | [PosUpdate_03_Res1.positionUpdateId] | 20100 | Instrument is not found in the system |

  @negative2
  Scenario: TC_PU_002 Validating Participant - Mandatory Field

    ## Validate Position Update submitted with EMPTY Participant
    When "Position Update" messages are submitted with following values
      | Instance ID  | account    | value | price | side  | participant | symbol              | notional |
      | PosUpdate_01 | RZ-PT-AC-1 | 100   | 50.0  | SHORT |             | RZ_PT_Inst_Bond_001 | 5000.0   |

    Then response of the request "PosUpdate_01" should be
      | Instance ID       | status   | subStatus           |
      | PosUpdate_01_Res1 | REJECTED | BUSINESS_VALIDATION |

    And "Position Update Error" messages are filtered by "externalId,message" should be
      | Instance ID          | externalId                           | code  | message                            |
      | PosUpdate_01_error01 | [PosUpdate_01_Res1.positionUpdateId] | 20113 | Account is not found in the system |

    ## Validate Position Update submitted with INVALID Participant
    When "Position Update" messages are submitted with following values
      | Instance ID  | account    | value | price | side  | participant | symbol              | notional |
      | PosUpdate_02 | RZ-PT-AC-1 | 100   | 50.0  | SHORT | ABCDEFG     | RZ_PT_Inst_Bond_001 | 10000.0  |

    Then response of the request "PosUpdate_02" should be
      | Instance ID       | status   | subStatus           |
      | PosUpdate_02_Res1 | REJECTED | BUSINESS_VALIDATION |

    And "Position Update Error" messages are filtered by "externalId,message" should be
      | Instance ID          | externalId                           | code  | message                                |
      | PosUpdate_02_error01 | [PosUpdate_02_Res1.positionUpdateId] | 20101 | Participant is not found in the system |

    And "Position Update Error" messages are filtered by "externalId,message" should be
      | Instance ID          | externalId                           | code  | message                            |
      | PosUpdate_02_error02 | [PosUpdate_02_Res1.positionUpdateId] | 20113 | Account is not found in the system |

    ## Validate Position Update submitted with EMPTY Participant
    When "Position Update" messages are submitted with following values
      | Instance ID  | account    | value | price | side  | participant | symbol              | notional |
      | PosUpdate_03 | RZ-PT-AC-1 | 100   | 50.0  | SHORT | ""          | RZ_PT_Inst_Bond_001 | 15000.0  |

    Then response of the request "PosUpdate_03" should be
      | Instance ID       | status   | subStatus           |
      | PosUpdate_03_Res1 | REJECTED | BUSINESS_VALIDATION |

    And "Position Update Error" messages are filtered by "externalId,message" should be
      | Instance ID          | externalId                           | code  | message                                |
      | PosUpdate_03_error01 | [PosUpdate_03_Res1.positionUpdateId] | 20101 | Participant is not found in the system |

    And "Position Update Error" messages are filtered by "externalId,message" should be
      | Instance ID          | externalId                           | code  | message                            |
      | PosUpdate_03_error02 | [PosUpdate_03_Res1.positionUpdateId] | 20113 | Account is not found in the system |

  @negative
  Scenario: TC_PU_003 Validating Account

    When "Position Update" messages are submitted with following values
      | Instance ID  | account | value | price | side  | participant | symbol              | notional |
      | PosUpdate_01 |         | 100   | 50.0  | SHORT | RZ-PT-01    | RZ_PT_Inst_Bond_001 | 5000.0   |

    Then response of the request "PosUpdate_01" should be
      | Instance ID       | status   | subStatus           | notional |
      | PosUpdate_01_Res1 | REJECTED | BUSINESS_VALIDATION | 5000.0   |

    And "Position Update Error" messages are filtered by "externalId,message" should be
      | Instance ID          | externalId                           | code  | message                                |
      | PosUpdate_01_error01 | [PosUpdate_01_Res1.positionUpdateId] | 20101 | Participant is not found in the system |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account | value | price | side  | participant | symbol              | notional |
      | PosUpdate_02 | CITI-H  | 200   | 50.0  | SHORT | RZ-PT-01    | RZ_PT_Inst_Bond_003 | 10000.0  |

    Then response of the request "PosUpdate_02" should be
      | Instance ID       | status   | subStatus           | notional |
      | PosUpdate_02_Res1 | REJECTED | BUSINESS_VALIDATION | 10000.0  |

    And "Position Update Error" messages are filtered by "externalId,message" should be
      | Instance ID          | externalId                           | code  | message                                |
      | PosUpdate_02_error01 | [PosUpdate_02_Res1.positionUpdateId] | 20101 | Participant is not found in the system |

  @negative
  Scenario: TC_PU_004 Validating Currency - Mandatory Field

      ## Validate Position Update submitted with EMPTY Currency
    When "Position Update" messages are submitted with following values
      | Instance ID  | account    | value | price  | side  | participant | symbol              | notional | currency |
      | PosUpdate_01 | RZ-PT-AC-1 | 100   | 60.000 | SHORT | RZ-PT-01    | RZ_PT_Inst_Bond_003 | 6000.0   |          |

    Then response of the request "PosUpdate_01" should be
      | Instance ID       | status   | subStatus           |
      | PosUpdate_01_Res1 | REJECTED | BUSINESS_VALIDATION |

    And "Position Update Error" messages are filtered by "externalId,message" should be
      | Instance ID          | externalId                           | code  | message                             |
      | PosUpdate_01_error01 | [PosUpdate_01_Res1.positionUpdateId] | 20102 | Currency is not found in the system |

     ## Validate Position Update submitted with INVALID Currency
    When "Position Update" messages are submitted with following values
      | Instance ID  | account    | value | price | side  | participant | symbol              | notional | currency |
      | PosUpdate_02 | RZ-PT-AC-1 | 200   | 50.0  | SHORT | RZ-PT-01    | RZ_PT_Inst_Bond_003 | 10000.0  | ABC      |

    Then response of the request "PosUpdate_02" should be
      | Instance ID       | status   | subStatus           | notional |
      | PosUpdate_02_Res1 | REJECTED | BUSINESS_VALIDATION | 10000.0  |

    And "Position Update Error" messages are filtered by "externalId,message" should be
      | Instance ID          | externalId                           | code  | message                             |
      | PosUpdate_02_error01 | [PosUpdate_02_Res1.positionUpdateId] | 20102 | Currency is not found in the system |

  @negative
  Scenario: TC_PU_005 Validating Type - Mandatory Field

      ## Validate Position Update submitted with EMPTY Type
    When "Position Update" messages are submitted with following values
      | Instance ID  | account    | value | price | side  | participant | symbol              | notional | type |
      | PosUpdate_01 | RZ-PT-AC-1 | 100   | 60.0  | SHORT | RZ-PT-01    | RZ_PT_Inst_Bond_003 | 6000.0   |      |

    Then response of the request "PosUpdate_01" should be
      | Instance ID       | status   | subStatus           |
      | PosUpdate_01_Res1 | REJECTED | BUSINESS_VALIDATION |

    And "Position Update Error" messages are filtered by "externalId,message" should be
      | Instance ID          | externalId                           | code  | message                             |
      | PosUpdate_01_error01 | [PosUpdate_01_Res1.positionUpdateId] | 20102 | Currency is not found in the system |

     ## Validate Position Update submitted with INVALID Type
    When "Position Update" messages are submitted with following values
      | Instance ID  | account    | value | price | side  | participant | symbol              | notional | type |
      | PosUpdate_02 | RZ-PT-AC-1 | 200   | 50.0  | SHORT | RZ-PT-01    | RZ_PT_Inst_Bond_003 | 10000.0  | ABC  |

    Then response of the request "PosUpdate_02" should be
      | Instance ID       | status   | subStatus           | notional |
      | PosUpdate_02_Res1 | REJECTED | BUSINESS_VALIDATION | 10000.0  |

    And "Position Update Error" messages are filtered by "externalId,message" should be
      | Instance ID          | externalId                           | code  | message                             |
      | PosUpdate_02_error01 | [PosUpdate_02_Res1.positionUpdateId] | 20102 | Currency is not found in the system |

  @negative6
  Scenario: TC_PU_006 Validating Side - Mandatory Field

      ## Validate Position Update submitted with EMPTY Side
    When "Position Update" messages are submitted with following values
      | Instance ID  | account    | value | price | side  | participant | symbol              | notional |
      | PosUpdate_01 | RZ-PT-AC-1 | 100   | 60.0  |  | RZ-PT-01    | RZ_PT_Inst_Bond_003 | 6000.0   |

    Then response of the request "PosUpdate_01" should be
      | Instance ID       | status   | subStatus           |
      | PosUpdate_01_Res1 | REJECTED | BUSINESS_VALIDATION |

    And "Position Update Error" messages are filtered by "externalId,message" should be
      | Instance ID          | externalId                           | code  | message                             |
      | PosUpdate_01_error01 | [PosUpdate_01_Res1.positionUpdateId] |  | |

     ## Validate Position Update submitted with INVALID Side
    When "Position Update" messages are submitted with following values
      | Instance ID  | account    | value | price | side  | participant | symbol              | notional |
      | PosUpdate_02 | RZ-PT-AC-1 | 200   | 50.0  | SRT | RZ-PT-01    | RZ_PT_Inst_Bond_003 | 10000.0  |

    Then response of the request "PosUpdate_02" should be
      | Instance ID       | status   | subStatus           | notional |
      | PosUpdate_02_Res1 | REJECTED | BUSINESS_VALIDATION | 10000.0  |

    And "Position Update Error" messages are filtered by "externalId,message" should be
      | Instance ID          | externalId                           | code  | message                             |
      | PosUpdate_02_error01 | [PosUpdate_02_Res1.positionUpdateId] |  |  |

  @negative7
  Scenario: TC_PU_007 Validating Quantity - Mandatory Field

      ## Validate Position Update submitted with EMPTY Quantity
    When "Position Update" messages are submitted with following values
      | Instance ID  | account    | value | price | side  | participant | symbol              | notional | quantity |
      | PosUpdate_01 | RZ-PT-AC-1 | 100   | 60.0  |  SHORT| RZ-PT-01    | RZ_PT_Inst_Bond_003 | 6000.0   |               |

    Then response of the request "PosUpdate_01" should be
      | Instance ID       | status   | subStatus           |
      | PosUpdate_01_Res1 | REJECTED | BUSINESS_VALIDATION |

    And "Position Update Error" messages are filtered by "externalId,message" should be
      | Instance ID          | externalId                           | code  | message                             |
      | PosUpdate_01_error01 | [PosUpdate_01_Res1.positionUpdateId] |  | |

     ## Validate Position Update submitted with INVALID Quantity
    When "Position Update" messages are submitted with following values
      | Instance ID  | account    | value | price | side  | participant | symbol              | notional | quantity |
      | PosUpdate_02 | RZ-PT-AC-1 | 200   | 50.0  | SRT | RZ-PT-01    | RZ_PT_Inst_Bond_003 | 10000.0  | ABC        |

    Then response of the request "PosUpdate_02" should be
      | Instance ID       | status   | subStatus           | notional |
      | PosUpdate_02_Res1 | REJECTED | BUSINESS_VALIDATION | 10000.0  |

    And "Position Update Error" messages are filtered by "externalId,message" should be
      | Instance ID          | externalId                           | code  | message                             |
      | PosUpdate_02_error01 | [PosUpdate_02_Res1.positionUpdateId] |  |  |

  @negative8
  Scenario: TC_PU_008 Validating Notional - Mandatory Field

      ## Validate Position Update submitted with EMPTY Notional
    When "Position Update" messages are submitted with following values
      | Instance ID  | account    | value | price | side  | participant | symbol              | notional |
      | PosUpdate_01 | RZ-PT-AC-1 | 100   | 60.0  |  SHORT| RZ-PT-01    | RZ_PT_Inst_Bond_003 |               |

    Then response of the request "PosUpdate_01" should be
      | Instance ID       | status   | subStatus           |
      | PosUpdate_01_Res1 | REJECTED | BUSINESS_VALIDATION |

    And "Position Update Error" messages are filtered by "externalId,message" should be
      | Instance ID          | externalId                           | code  | message                             |
      | PosUpdate_01_error01 | [PosUpdate_01_Res1.positionUpdateId] |20141  | Notional is required|

     ## Validate Position Update submitted with INVALID Notional
    When "Position Update" messages are submitted with following values
      | Instance ID  | account    | value | price | side  | participant | symbol              | notional |
      | PosUpdate_02 | RZ-PT-AC-1 | 200   | 50.0  | SRT | RZ-PT-01    | RZ_PT_Inst_Bond_003 | ABC |

    Then response of the request "PosUpdate_02" should be
      | Instance ID       | status   | subStatus           |
      | PosUpdate_02_Res1 | REJECTED | BUSINESS_VALIDATION |

    And "Position Update Error" messages are filtered by "externalId,message" should be
      | Instance ID          | externalId                           | code  | message                             |
      | PosUpdate_02_error01 | [PosUpdate_02_Res1.positionUpdateId] |  |  |

  @negative9
  Scenario: TC_PU_009 Validating Status - Mandatory Field

      ## Validate Position Update submitted with EMPTY Status
    When "Position Update" messages are submitted with following values
      | Instance ID  | account    | value | price | side  | participant | symbol              | notional | status |
      | PosUpdate_01 | RZ-PT-AC-1 | 10   | 60.0  |  SHORT| RZ-PT-01    | RZ_PT_Inst_Bond_003 |     600.0          | |

    Then response of the request "PosUpdate_01" should be
      | Instance ID       | status   | subStatus           |
      | PosUpdate_01_Res1 | REJECTED | BUSINESS_VALIDATION |

    And "Position Update Error" messages are filtered by "externalId,message" should be
      | Instance ID          | externalId                           | code  | message                             |
      | PosUpdate_01_error01 | [PosUpdate_01_Res1.positionUpdateId] |  | |

     ## Validate Position Update submitted with INVALID Status
    When "Position Update" messages are submitted with following values
      | Instance ID  | account    | value | price | side  | participant | symbol              | status |
      | PosUpdate_02 | RZ-PT-AC-1 | 20   | 50.0  | SRT | RZ-PT-01    | RZ_PT_Inst_Bond_003 | ABC |

    Then response of the request "PosUpdate_02" should be
      | Instance ID       | status   | subStatus           |
      | PosUpdate_02_Res1 | REJECTED | BUSINESS_VALIDATION |

    And "Position Update Error" messages are filtered by "externalId,message" should be
      | Instance ID          | externalId                           | code  | message                             |
      | PosUpdate_02_error01 | [PosUpdate_02_Res1.positionUpdateId] |  |  |

  @negative10
  Scenario: TC_PU_010 Validating Sub Status - Mandatory Field

      ## Validate Position Update submitted with EMPTY Sub status
    When "Position Update" messages are submitted with following values
      | Instance ID  | account    | value | price | side  | participant | symbol              | notional | subStatus |
      | PosUpdate_01 | RZ-PT-AC-1 | 10   | 60.0  |  SHORT| RZ-PT-01    | RZ_PT_Inst_Bond_003 |     600.0          | |

    Then response of the request "PosUpdate_01" should be
      | Instance ID       | status   | subStatus           |
      | PosUpdate_01_Res1 | REJECTED | BUSINESS_VALIDATION |

    And "Position Update Error" messages are filtered by "externalId,message" should be
      | Instance ID          | externalId                           | code  | message                             |
      | PosUpdate_01_error01 | [PosUpdate_01_Res1.positionUpdateId] |  | |

     ## Validate Position Update submitted with INVALID Sub status
    When "Position Update" messages are submitted with following values
      | Instance ID  | account    | value | price | side  | participant | symbol              | subStatus |
      | PosUpdate_02 | RZ-PT-AC-1 | 20   | 50.0  | SRT | RZ-PT-01    | RZ_PT_Inst_Bond_003 | ABC |

    Then response of the request "PosUpdate_02" should be
      | Instance ID       | status   | subStatus           |
      | PosUpdate_02_Res1 | REJECTED | BUSINESS_VALIDATION |

    And "Position Update Error" messages are filtered by "externalId,message" should be
      | Instance ID          | externalId                           | code  | message                             |
      | PosUpdate_02_error01 | [PosUpdate_02_Res1.positionUpdateId] |  |  |
