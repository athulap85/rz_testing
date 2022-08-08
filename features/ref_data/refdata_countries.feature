Feature: refdata countries add edit delete instance

  Scenario: TC_001 create a new country
    When instance of entity "Countries" is created with following values
      | Instance ID | Country Id | Country Iso Code | Country Name |
      | Cou01       | SL         | SL               | Sri Lanka    |

  Scenario: TC_002 create an new country with existing country ID
    When instance of entity "Countries" is created with following values
      | Instance ID | Country Id | Country Iso Code | Country Name |
      | Cou02       | SL         | SL               | Sri Lanka    |

    Then the request should be rejected with the error "Country Id already exists."

  Scenario: TC_003 create an new country without country ID
    When instance of entity "Countries" is created with following values
      | Instance ID | Country Iso Code | Country Name |
      | Cou02       | SL               | Sri Lanka    |

    Then the request should be rejected with the error "Country Id is required."

  Scenario: TC_004 create an new country without ISO
    When instance of entity "Countries" is created with following values
      | Instance ID | Country Id | Country Name |
      | Cou02       | TE         | Test         |

    Then the request should be rejected with the error "Country ISO is required."

  Scenario: TC_005 Update the Country Name in an existing country
    Given instance "SL" of entity "Countries" is updated with following values
      | Instance ID | Country Name  |
      | Cou01       | The Sri Lanka |

  Scenario: TC_006 Update the ISO in an existing Country
    Given instance "SL" of entity "Countries" is updated with following values
      | Instance ID | Country Iso Code  |
      | Cou01       | LKR               |
#Test passes but no update to field

  Scenario: TC_007 Update the ISO in an existing Country
    Given instance "SL" of entity "Countries" is updated with following values
      | Instance ID | Country Id |
      | Cou01       | LK         |
#Test passes but no update to field

  Scenario: TC_011 Deleting instances
    Given instance "SL" of entity "Countries" is deleted

