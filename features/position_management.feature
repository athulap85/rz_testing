Feature: Position Management


    @negative
    Scenario: TC_001 Validating Symbol - Mandatory Field

        When "Position_Updates" are submitted with following values
        | Instance ID | symbol  |
        | TC_001_Ins1 | ""      |

        Then response of the request "TC_001_Ins1" should be
        | Instance ID       | status    | subStatus            |
        | TC_001_Ins1_Res1  | REJECTED  | BUSINESS_VALIDATION  |

    @negative
    Scenario: TC_002 Validating Symbol - Invalid

        When "Position_Updates" are submitted with following values
        | Instance ID      | symbol           |
        | TC_002_Ins1      | invalid_symbol   |

        Then response of the request "TC_002_Ins1" should be
        | Instance ID       | status   | subStatus            |
        | TC_002_Ins1_Res1  | REJECTED | BUSINESS_VALIDATION  |

    @negative
    Scenario: TC_003 Validating Firm - Mandatory

        When "Position_Updates" are submitted with following values
        | Instance ID        | participant  |
        | TC_003_Ins1        |  ""          |

        Then response of the request "TC_003_Ins1" should be
        | Instance ID         | status   | subStatus            |
        | TC_003_Ins1_Res1    | REJECTED | BUSINESS_VALIDATION  |

    @negative
    Scenario: TC_004 Validating Firm - Invalid

        When "Position_Updates" are submitted with following values
        | Instance ID        | participant    |
        | TC_004_Ins1        | invalid-Firm   |

        Then response of the request "TC_004_Ins1" should be
        | Instance ID         | status   | subStatus            |
        | TC_004_Ins1_Res1    | REJECTED | BUSINESS_VALIDATION  |

        @hello
    Scenario: TC_005 Validating Account - Margin Account Valid

#        Given instance "Home_NK118" of entity "Accounts" is deleted

#        Given instance "Home" of entity "Accounts" is copied with following values
#        | Instance ID       | Account Id   | Name       | Participant    |
#        | TC005Ins1         | Home_NK118    | Home_NK118  | HSBC           |

        Given "Position_Updates" are submitted with following values
        | Instance ID | account                      | quantity | price | side | participant             | type    |
        | TC005Ins2   | Home_NN     | 1000     | 50.0  | SHORT| HSBC | MARGIN  |

        Then response of the request "TC005Ins2" should be
        | Instance ID         | status   | subStatus   |
        | TC005Ins2_Res1      | POSTED   | PROCESSING  |

        Then "Position" messages are filtered by "level,participant,account" should be
        | Instance ID         | level  | participant                    | shortPosition   | account                     |  type   |
        | TC005Ins2_Res2      | SYSTEM | [TC005Ins2.participant]        | 1000.0          | [TC005Ins2.account]      |  MARGIN |


#        Given instance "Home_NK12" of entity "Accounts" is deleted

    Scenario: TC_006 Validating Account - Optional   ???

#        Given instance "Home_NKG1" of entity "Accounts" is deleted

        Given instance "Home" of entity "Accounts" is copied with following values
        | Instance ID       | Account Id   | Name       | Participant    |
        | TC_006_Ins1       | null         | null       | HSBC           |

        When "Position_Updates" are submitted with following values
        | Instance ID | account      | quantity | price | side  | participant | type    |
        | TC_006_Ins2 | Home_NKG4    | 1000     | 50.0  | SHORT |  HSBC       | MARGIN  |

        Then response of the request "TC_006_Ins2" should be
        | Instance ID         | status   | subStatus   |
        | TC_006_Ins2_Res1    | POSTED   | PROCESSING  |

        Then "Position" messages are filtered by "level,participant,account" should be
        | Instance ID         | level  | participant   | shortPosition   | account       |  type   |
        | TC_006_Ins2_Res2    | SYSTEM | HSBC          | 1000.0          | null          |  MARGIN |

