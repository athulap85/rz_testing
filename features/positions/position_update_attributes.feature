Feature: Position Management


  @negative
  Scenario: TC_PU_001 Validating Symbol - Mandatory Field

    ## Validate Position Update submitted with EMPTY Symbol
    When "Position Update" messages are submitted with following values
      | Instance ID  | account    | value | price | side  | participant | symbol | notional |
      | PosUpdate_01 | RZ-PT-AC-1 | 100   | 50.0  | SHORT | RZ-PT-01    | ""     | 500.0    |

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

  @negative
  Scenario: TC_PU_002 Validating Participant - Mandatory Field

    ## Validate Position Update submitted with EMPTY Participant
    When "Position Update" messages are submitted with following values
      | Instance ID  | account    | value | price | side  | participant | symbol              | notional |
      | PosUpdate_01 | RZ-PT-AC-1 | 100   | 50.0  | SHORT |             | RZ_PT_Inst_Bond_001 | 5000.0   |

    Then response of the request "PosUpdate_01" should be
      | Instance ID       | status   | subStatus           |
      | PosUpdate_01_Res1 | REJECTED | BUSINESS_VALIDATION |

    And "Position Update Error" messages are filtered by "externalId" should be
      | Instance ID          | externalId                           | code  | message                            |
      | PosUpdate_01_error01 | [PosUpdate_01_Res1.positionUpdateId] | 20101 | Participant is not found in the system |

    ## Validate Position Update submitted with INVALID Participant
    When "Position Update" messages are submitted with following values
      | Instance ID  | account    | value | price | side  | participant | symbol              | notional |
      | PosUpdate_02 | RZ-PT-AC-1 | 100   | 50.0  | SHORT | ABCDEFG     | RZ_PT_Inst_Bond_001 | 10000.0  |

    Then response of the request "PosUpdate_02" should be
      | Instance ID       | status   | subStatus           |
      | PosUpdate_02_Res1 | REJECTED | BUSINESS_VALIDATION |

    And "Position Update Error" messages are filtered by "externalId,message" should be
      | Instance ID          | externalId                           | code  | message                            |
      | PosUpdate_02_error01 | [PosUpdate_02_Res1.positionUpdateId] | 20101 | Participant is not found in the system |

    ## Validate Position Update submitted with EMPTY Participant
    When "Position Update" messages are submitted with following values
      | Instance ID  | account | value | price | side  | participant | symbol              | notional |
      | PosUpdate_03 |RZ-PT-AC-1 | 100   | 50.0  | SHORT | ""         | RZ_PT_Inst_Bond_001 | 15000.0  |

    Then response of the request "PosUpdate_03" should be
      | Instance ID       | status   | subStatus           |
      | PosUpdate_03_Res1 | REJECTED | BUSINESS_VALIDATION |

    And "Position Update Error" messages are filtered by "externalId,message" should be
      | Instance ID          | externalId                           | code  | message                            |
      | PosUpdate_03_error01 | [PosUpdate_03_Res1.positionUpdateId] | 20101 | Participant is not found in the system |

  @negative
  Scenario: TC_PU_003 Validating Account

    When "Position Update" messages are submitted with following values
      | Instance ID  | account | value | price | side  | participant | symbol              | notional |
      | PosUpdate_01 |         | 100   | 50.0  | SHORT | RZ-PT-01        | RZ_PT_Inst_Bond_001 | 5000.0   |

    Then response of the request "PosUpdate_01" should be
      | Instance ID       | status   | subStatus           | notional |
      | PosUpdate_01_Res1 | REJECTED | BUSINESS_VALIDATION | 5000.0   |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account | value | price | side  | participant | symbol              | notional |
      | PosUpdate_02 | CITI-H  | 200   | 50.0  | SHORT | RZ-PT-01        | RZ_PT_Inst_Bond_003 | 10000.0  |

    Then response of the request "PosUpdate_02" should be
      | Instance ID       | status   | subStatus           | notional |
      | PosUpdate_02_Res1 | REJECTED | BUSINESS_VALIDATION | 10000.0  |

  @negative1
  Scenario: TC_PU_004 Validating Currency

    When "Position Update" messages are submitted with following values
      | Instance ID  | account | value | price  | side  | participant | symbol              | notional | currency |
      | PosUpdate_01 | Home    | 100   | 60.000 | SHORT | HSBC        | RZ_PT_Inst_Bond_003 | 6000.0   | USD      |

    Then response of the request "PosUpdate_01" should be
      | Instance ID       | status   | subStatus  | notional |
      | PosUpdate_01_Res1 | REJECTED | RISk_ERROR | 6000.0   |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account | value | price | side  | participant | symbol              | notional |
      | PosUpdate_02 | Home    | 200   | 50.0  | SHORT | HSBC        | RZ_PT_Inst_Bond_003 | 10000.0  |

    Then response of the request "PosUpdate_02" should be
      | Instance ID       | status   | subStatus  | notional |
      | PosUpdate_02_Res1 | REJECTED | RISK_ERROR | 10000.0  |
