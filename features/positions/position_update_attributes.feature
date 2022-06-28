Feature: Position Management


  @negative
  Scenario: TC_PU_001 Validating Symbol - Mandatory Field

    When "Position Update" messages are submitted with following values
      | Instance ID  | account | value | price | side  | participant | symbol | notional |
      | PosUpdate_01 | Home    | 100   | 50.0  | SHORT | HSBC        | ""     | 500.0    |

    Then response of the request "PosUpdate_01" should be
      | Instance ID       | status   | subStatus           | value |
      | PosUpdate_01_Res1 | REJECTED | BUSINESS_VALIDATION | 100.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account | value | price | side  | participant | symbol | notional |
      | PosUpdate_02 | Home    | 200   | 50.0  | SHORT | HSBC        |        | 10000.0  |

    Then response of the request "PosUpdate_02" should be
      | Instance ID       | status   | subStatus           | value |
      | PosUpdate_02_Res1 | REJECTED | BUSINESS_VALIDATION | 200.0 |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account | value | price | side  | participant | symbol    | notional |
      | PosUpdate_03 | Home    | 300   | 50.0  | SHORT | HSBC        | PQRST1234 | 15000.0  |

    Then response of the request "PosUpdate_03" should be
      | Instance ID       | status   | subStatus           | value |
      | PosUpdate_03_Res1 | REJECTED | BUSINESS_VALIDATION | 300.0 |


  @negative
  Scenario: TC_PU_002 Validating Participant - Mandatory Field

    When "Position Update" messages are submitted with following values
      | Instance ID  | account | value | price | side  | participant | symbol              | notional |
      | PosUpdate_01 | Home    | 100   | 50.0  | SHORT |             | RZ_PT_Inst_Bond_003 | 5000.0   |

    Then response of the request "PosUpdate_01" should be
      | Instance ID       | status   | subStatus           | notional |
      | PosUpdate_01_Res1 | REJECTED | BUSINESS_VALIDATION | 5000.0   |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account | value | price | side  | participant | symbol              | notional |
      | PosUpdate_02 | Home    | 200   | 50.0  | SHORT | ABCDEFG     | RZ_PT_Inst_Bond_003 | 10000.0  |

    Then response of the request "PosUpdate_02" should be
      | Instance ID       | status   | subStatus           | notional |
      | PosUpdate_02_Res1 | REJECTED | BUSINESS_VALIDATION | 10000.0  |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account | value | price | side  | participant | symbol              | notional |
      | PosUpdate_03 | Home    | 300   | 50.0  | SHORT | " "         | RZ_PT_Inst_Bond_003 | 15000.0  |

    Then response of the request "PosUpdate_03" should be
      | Instance ID       | status   | subStatus           | notional |
      | PosUpdate_01_Res3 | REJECTED | BUSINESS_VALIDATION | 15000.0  |

  @negative
  Scenario: TC_PU_003 Validating Account

    When "Position Update" messages are submitted with following values
      | Instance ID  | account | value | price | side  | participant | symbol              | notional |
      | PosUpdate_01 |         | 100   | 50.0  | SHORT | HSBC        | RZ_PT_Inst_Bond_003 | 5000.0   |

    Then response of the request "PosUpdate_01" should be
      | Instance ID       | status   | subStatus           | notional |
      | PosUpdate_01_Res1 | REJECTED | BUSINESS_VALIDATION | 5000.0   |

    When "Position Update" messages are submitted with following values
      | Instance ID  | account | value | price | side  | participant | symbol              | notional |
      | PosUpdate_02 | CITI-H  | 200   | 50.0  | SHORT | HSBC        | RZ_PT_Inst_Bond_003 | 10000.0  |

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
