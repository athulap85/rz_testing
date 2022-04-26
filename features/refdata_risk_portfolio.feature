Feature: refdata risk portfolio add edit delete scenarios

Scenario: TC_001 Create risk portfolio Successfully
    When instance of entity "Risk Portfolios" is created with following values
      | Instance ID | Risk Portfolio Id  | Risk Measure             | Holding Period    |Risk Measure Multiplier|Hedge Risk Factor|Rf Value|
      | RISK01      | RP_001             | FLAT                     | 1                 | 1                     | DV01            |1000    |

Scenario: TC_002 Create risk portfolio with already existing Risk Portfolio ID
    When instance of entity "Risk Portfolios" is created with following values
      | Instance ID | Risk Portfolio Id  | Risk Measure             | Holding Period    |Risk Measure Multiplier|Hedge Risk Factor|Rf Value|
      | RISK01      | RP_001             | FLAT                     | 1                 | 1                     | DV01            |1000    |
    Then the request should be rejected with the error "Risk Portfolio Id already exists."

Scenario: TC_003 Create risk portfolio without risk portfolio id
    When instance of entity "Risk Portfolios" is created with following values
      | Instance ID | Risk Portfolio Id  | Risk Measure             | Holding Period    |Risk Measure Multiplier|Hedge Risk Factor|Rf Value|
      | RISK02      |                    | FLAT                     | 1                 | 1                     | DV01            |1000    |
    Then the request should be rejected with the error "Risk Portfolio Id is missing."

Scenario: TC_004 Create risk portfolio without Risk Measure
    When instance of entity "Risk Portfolios" is created with following values
      | Instance ID | Risk Portfolio Id  | Risk Measure             | Holding Period    |Risk Measure Multiplier|Hedge Risk Factor|Rf Value|
      | RISK02      |  RP_002            |                          | 1                 | 1                     | DV01            |1000    |
    Then the request should be rejected with the error "Risk Measure is missing."

Scenario: TC_005 Create risk portfolio with invalid Risk Measure
    When instance of entity "Risk Portfolios" is created with following values
      | Instance ID | Risk Portfolio Id  | Risk Measure             | Holding Period    |Risk Measure Multiplier|Hedge Risk Factor|Rf Value|
      | RISK02      |  RP_002            | PROXY TEST               | 1                 | 1                     | DV01            |1000    |
    Then the request should be rejected with the error "Invalid Risk Measure value."

Scenario: TC_006 Create risk portfolio without Holding Period
    When instance of entity "Risk Portfolios" is created with following values
      | Instance ID | Risk Portfolio Id  | Risk Measure             | Holding Period    |Risk Measure Multiplier|Hedge Risk Factor|Rf Value|
      | RISK02      |  RP_002            |  FLAT                    |                   | 1                     | DV01            |1000    |
    Then the request should be rejected with the error "Holding Period is missing."

Scenario: TC_007 Create risk portfolio with invalid Holding Period Value
    When instance of entity "Risk Portfolios" is created with following values
      | Instance ID | Risk Portfolio Id  | Risk Measure             | Holding Period    |Risk Measure Multiplier|Hedge Risk Factor|Rf Value|
      | RISK02      |  RP_002            |  FLAT                    |  TEST             | 1                     | DV01            |1000    |
    Then the request should be rejected with the error "Invalid Holding Period value."

Scenario: TC_008 Create risk portfolio with invalid Risk Measure Multiplier Value
    When instance of entity "Risk Portfolios" is created with following values
      | Instance ID | Risk Portfolio Id  | Risk Measure             | Holding Period    |Risk Measure Multiplier|Hedge Risk Factor|Rf Value|
      | RISK02      |  RP_002            |  FLAT                    |  1                | TEST                  | DV01            |1000    |
    Then the request should be rejected with the error "Invalid Risk Measure Multiplier value."

Scenario: TC_009 Create risk portfolio with invalid Hedge Risk Factor Value
    When instance of entity "Risk Portfolios" is created with following values
      | Instance ID | Risk Portfolio Id  | Risk Measure             | Holding Period    |Risk Measure Multiplier|Hedge Risk Factor|Rf Value|
      | RISK02      |  RP_002            |  FLAT                    |  1                | TEST                  | DV01 TEST       |1000    |
    Then the request should be rejected with the error "Invalid Hedge Risk Factor value."

Scenario: TC_010 Create risk portfolio with invalid Rf Value
    When instance of entity "Risk Portfolios" is created with following values
      | Instance ID | Risk Portfolio Id  | Risk Measure             | Holding Period    |Risk Measure Multiplier|Hedge Risk Factor|Rf Value|
      | RISK02      |  RP_002            |  FLAT                    |  1                | TEST                  | DV01            |TEST    |
    Then the request should be rejected with the error "Invalid Rf Value."

Scenario: TC_011 Create risk portfolio with invalid Flat Rate Value
    When instance of entity "Risk Portfolios" is created with following values
      | Instance ID | Risk Portfolio Id  | Risk Measure             | Holding Period    |Risk Measure Multiplier|Hedge Risk Factor|Rf Value|Flat Rate|
      | RISK02      |  RP_002            |  FLAT                    |  1                | TEST                  | DV01            |1000    |TEST     |
    Then the request should be rejected with the error "Invalid Flat Rate value."

Scenario: TC_012 Update the Risk Measure in an existing Risk Portfolio
    And instance "RP_001" of entity "Risk Portfolios" is updated with following values
      | Instance ID | Risk Measure             |
      | RISK01      | PRIMARY                  |

Scenario: TC_013 Update the Holding Period in an existing Risk Portfolio
    And instance "RP_001" of entity "Risk Portfolios" is updated with following values
      | Instance ID | Holding Period          |
      | RISK01      | 10                      |

Scenario: TC_014 Update the Holding Period Multiplier/Risk Measure Multiplier/Flat Rate in an existing Risk Portfolio
    And instance "RP_001" of entity "Risk Portfolios" is updated with following values
      | Instance ID | Holding Period Multiplier |Risk Measure Multiplier|Flat Rate|
      | RISK01      | 5                         |5                      |5        |

Scenario: TC_015 Update the Hedge Risk Factor in an existing Risk Portfolio
    And instance "RP_001" of entity "Risk Portfolios" is updated with following values
      | Instance ID | Hedge Risk Factor         |
      | RISK01      | MODIFIED_DURATION         |

Scenario: TC_016 Update the Rf Value in an existing Risk Portfolio
    And instance "RP_001" of entity "Risk Portfolios" is updated with following values
      | Instance ID | Rf Value    |
      | RISK01      | 500         |

Scenario: TC_017 Update the multiple fields in an existing Risk Portfolio
    And instance "RP_001" of entity "Risk Portfolios" is updated with following values
      | Instance ID | Risk Measure    |Holding Period Multiplier|Risk Measure Multiplier|Hedge Risk Factor|Flat Rate|Rf Value |Hedge Instrument|
      | RISK01      | FLAT            |1                        |1                      |DV01             |         |1000     |SYM_002         |
