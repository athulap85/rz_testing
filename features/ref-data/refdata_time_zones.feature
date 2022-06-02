Feature: refdata time zones add edit delete instance

  Scenario: TC_001 create a new time zone
    When instance of entity "Time Zones" is created with following values
      | Instance ID | Time Zone Id | Offset | Name        |
      | TiZ01       | TZ_002       | 4      | Test Zone   |

  Scenario: TC_002 create a new time zone with same time zone ID
    When instance of entity "Time Zones" is created with following values
      | Instance ID | Time Zone Id | Offset | Name         |
      | TiZ02       | TZ_002       | 5      | Test Zone1   |

    Then the request should be rejected with the error "Time zone Id already exists."

   Scenario: TC_003 create a new time zone without time zone ID
    When instance of entity "Time Zones" is created with following values
      | Instance ID | Offset | Name         |
      | TiZ02       | 5      | Test Zone1   |

    Then the request should be rejected with the error "Time Zone Id is Required."

   Scenario: TC_004 create a new time zone without time zone offset
    When instance of entity "Time Zones" is created with following values
      | Instance ID | Time Zone Id | Name         |
      | TiZ03       | TZ_003       | Test Zone2   |

    Then the request should be rejected with the error "Valid Time Zone Offset is Required."

   Scenario: TC_005 create a new time zone without time zone name
    When instance of entity "Time Zones" is created with following values
      | Instance ID | Time Zone Id | Offset |
      | TiZ03       | TZ_003       | 5      |

    Then the request should be rejected with the error "Time Zone Name is Required."

   Scenario: TC_005 create a new time zone without time zone offset as char
    When instance of entity "Time Zones" is created with following values
      | Instance ID | Time Zone Id | Offset | Name         |
      | TiZ03       | TZ_003       | A      | Test Zone2   |

    Then the request should be rejected with the error "Time Zone Offset is Required."
 # Fails with bad request

  Scenario: TC_011 Deleting instances
    Given instance "TZ_002" of entity "Time Zones" is deleted