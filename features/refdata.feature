Feature: RefData Management

    Scenario: 1 validation refdata instance

        Given instance "AAPL" of entity "Instruments" is updated with following values
        |Instance ID | Display ID | Currency |
        |Ins02       | ISIN       | EUR      |

        Then instance "AAPL" of entity "Instruments" is filtered via "Ref Data API" should be
        |Instance ID | Asset Class   | Symbol |Size Multiplier | Currency         |
        |Ins03       | Equity        | AAPL   |3               | [Ins02.Currency] |


    Scenario: 2 validation refdata instance

        Given instance "AAPL" of entity "Instrument" is copied with following values
        |Instance ID | Size Multiplier | Symbol |
        |Ins04       | 1               | AAPL3  |

    @wip
    Scenario: Duplicate Currency
        When instance "AED1" of entity "Currencies" is updated with following values
        | Instance ID | Currency Id  | Description  | Currency Precision |
        | Cur02       | AED1         | Dirham1      | 5                  |

        Then the request should be rejected with the error "Currency Id already exists."



    Scenario: 4 validation refdata instance
        Given instance "ACC_001" of entity "Accounts" is deleted
        Given instance "AED" of entity "Currencies" is deleted
        Given instance "MEM_001" of entity "Participants" is deleted
        Given instance "TZ_001" of entity "Time Zones" is deleted
        Given instance "RM_001" of entity "Risk Models" is deleted
        Given instance "AED1" of entity "Currencies" is deleted







