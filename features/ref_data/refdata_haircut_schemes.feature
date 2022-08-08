Feature: refdata haircut schemes add edit delete instance

  Scenario: TC_001 create an new haircut scheme
    When instance of entity "Haircut Schemes" is created with following values
      | Instance ID | Haircut Scheme Id | Collateral Type | Haircut Type | Haircut Rate |
      | HaC01       | Test Scheme-1     | Gov_Bonds       | VAR          | 0.1          |

  Scenario: TC_002 create an new haircut scheme with same haircut scheme ID
    When instance of entity "Haircut Schemes" is created with following values
      | Instance ID | Haircut Scheme Id | Collateral Type | Haircut Type | Haircut Rate |
      | HaC02       | Test Scheme-1     | Agency MBS      | FLAT         | 0.2          |

     Then the request should be rejected with the error "Haircut Scheme Id already exists."

   Scenario: TC_003 create an new haircut scheme without haircut scheme ID
    When instance of entity "Haircut Schemes" is created with following values
      | Instance ID | Collateral Type | Haircut Type | Haircut Rate |
      | HaC02       | Agency MBS      | FLAT         | 0.2          |

     Then the request should be rejected with the error "Haircut Scheme Id is required."

   Scenario: TC_004 create an new haircut scheme without collateral type specified
     When instance of entity "Haircut Schemes" is created with following values
      | Instance ID | Haircut Scheme Id | Haircut Type | Haircut Rate |
      | HaC02       | Test Scheme-2     | FLAT         | 0.2          |

     Then the request should be rejected with the error "Collateral type is required."
#Creates haircut scheme. GUI validation is also not available. Can create haircut scheme with only Id.

   Scenario: TC_005 create an new haircut scheme with collateral type not in drop down
     When instance of entity "Haircut Schemes" is created with following values
      | Instance ID | Haircut Scheme Id | Haircut Type | Haircut Rate | Collateral Type |
      | HaC03       | Test Scheme-3     | FLAT         | 0.1          | Test_bond       |

     Then the request should be rejected with the error "Collateral type is required."
#does not get created but does not throw error as well.

   Scenario: TC_006 create an new haircut scheme with haircut type
     When instance of entity "Haircut Schemes" is created with following values
      | Instance ID | Haircut Scheme Id | Haircut Rate | Collateral Type |
      | HaC04       | Test Scheme-4     | 0.1          | Gov_Bonds       |

     Then the request should be rejected with the error "Collateral type is required."
#Creates haircut scheme. GUI validation is also not available. Can create haircut scheme with only Id.

   Scenario: TC_007 create an new haircut scheme with haircut type not in drop down
     When instance of entity "Haircut Schemes" is created with following values
      | Instance ID | Haircut Scheme Id | Haircut Rate | Collateral Type | Haircut Type |
      | HaC05       | Test Scheme-5     | 0.1          | Gov_Bonds       | IM           |

     Then the request should be rejected with the error "Collateral type is required."
#fails with bad request

  Scenario: TC_008 create an new haircut scheme with haircut rate with char
    When instance of entity "Haircut Schemes" is created with following values
      | Instance ID | Haircut Scheme Id | Collateral Type | Haircut Type | Haircut Rate |
      | HaC06       | Test Scheme-6     | Gov_Bonds       | VAR          | A            |

    Then the request should be rejected with the error "Haircut type is invalid."
#fails with bad request

  Scenario: TC_011 Deleting instances
    Given instance "Test Scheme-1" of entity "Haircut Schemes" is deleted