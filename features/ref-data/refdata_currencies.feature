Feature: refdata currencies add edit delete instance

  Scenario: TC_001 create an new currecny
    When instance of entity "Currencies" is created with following values
      | Instance ID | Currency Id | Description | Currency Precision |
      | Cur01       | AED         | Dirham      | 0                  |

  Scenario: TC_002 create an new currecny with same currency ID
    When instance of entity "Currencies" is created with following values
      | Instance ID | Currency Id | Description | Currency Precision |
      | Cur02       | AED         | Dirham      | 0                  |

    Then the request should be rejected with the error "Currency Id already exists."

  Scenario: TC_003 create an new currecny without currency ID
    When instance of entity "Currencies" is created with following values
      | Instance ID | Description | Currency Precision |
      | Cur02       | Dirham      | 0                  |

    Then the request should be rejected with the error "Currency Id is Required."

  Scenario: TC_004 create an new currecny without currency precision
    When instance of entity "Currencies" is created with following values
      | Instance ID | Currency Id | Description |
      | Cur02       | XYZ         | Dirham      |

    Then the request should be rejected with the error "Currency Precision is Required."
#Currency precision is defaluted to 0. GUI validation is available.

   Scenario: TC_005 create an new currecny with currency precision as char value
    When instance of entity "Currencies" is created with following values
      | Instance ID | Currency Id | Description | Currency Precision |
      | Cur03       | ABC         | Test        | abc                |

    Then the request should be rejected with the error "Bad Request"
#failing as bad request

  Scenario: TC_006 Update the description in an existing currency
    Given instance "AED" of entity "Currencies" is updated with following values
      | Instance ID | Description  |
      | Cur01       | UAE Dirham   |

  Scenario: TC_006 Update the description in an existing currency
    Given instance "AED" of entity "Currencies" is updated with following values
      | Instance ID | Description  |
      | Cur01       | UAE Dirham   |

  Scenario: TC_007 Update the currency precision in an existing currency
    Given instance "AED" of entity "Currencies" is updated with following values
      | Instance ID | Currency Precision |
      | Cur01       | 2                  |

  Scenario: TC_008 Update the currency precision in an existing currency
    Given instance "AED" of entity "Currencies" is updated with following values
      | Instance ID | Currency Symbol |
      | Cur01       | AED             |

  Scenario: TC_009 Update the currency Id in an existing currency
    Given instance "AED" of entity "Currencies" is updated with following values
      | Instance ID | Currency Id |
      | Cur01       | UAED        |
#Test passes but field does not get updated

  Scenario: TC_011 Deleting instances
    Given instance "AED" of entity "Currencies" is deleted

