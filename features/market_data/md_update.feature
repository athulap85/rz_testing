Feature: Market Data Management Scenarios

  @wip
  Scenario: Reference Data Setup
#    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
#      | Instance ID | Instrument ID | Symbol       | Expiry Date | Issue Date | First Coupon Date | Next To Last Date | Par Value |
#      | Ins001      | INS_001       | RZ_MD_INS_01 | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        | 100       |
#    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
#      | Instance ID | Instrument ID | Symbol       | Expiry Date | Issue Date | First Coupon Date | Next To Last Date | Par Value | Calculation Price Type |
#      | Ins002      | INS_002       | RZ_MD_INS_02 | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        | 100       | THEORETICAL_PRICE      |
#    Given instance "RZ_ST_Rate1M" of entity "Instruments" is copied with following values
#      | Instance ID | Instrument ID | Symbol       | Expiry Date | Issue Date | First Coupon Date | Next To Last Date | Par Value |
#      | Ins003      | INS_003       | RZ_MD_INS_03 | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        | 100       |
    Given instance "FR_BO_472557" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol       | Expiry Date | Issue Date | First Coupon Date | Next To Last Date | Par Value | Coupon Benchmark |
      | Ins004      | INS_004       | RZ_MD_INS_04 | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        | 100       | TNX40            |

  @wip1
  Scenario: TC_MD_001 MD update for LTP with data class=VALUE & sub class=THEORETICAL/ACTUAL
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | type | value | dataClass | subClass    |
      | RFU01       | RZ_MD_INS_01 | LTP  | 33.0  | VALUE     | THEORETICAL |
    Then response of the request "RFU01" should be
      | Instance ID |
      | RFU_Res01   |
    Then "Realtime Risk Factor Update" messages are filtered by "id" should be
      | Instance ID | id             | status   |
      | RFU_Req01   | [RFU_Res01.id] | REJECTED |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | type | value | dataClass | subClass |
      | RFU02       | RZ_MD_INS_01 | LTP  | 33.0  | VALUE     | ACTUAL   |
    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp  |
      | RFU_Res2    | RZ_MD_INS_01 | 33.0 |

  @wip2
  Scenario: TC_MD_002 MD update for the LTP with negative & Lengthy values where data class=RATE/STATISTIC/price
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | type | value                       | dataClass | venue |
      | RFU01       | RZ_MD_INS_01 | LTP  | 100000000000000000000000000 | RATE      | CME   |
    Then response of the request "RFU01" should be
      | Instance ID |
      | RFU_Res01   |
    Then "Realtime Risk Factor Update" messages are filtered by "id" should be
      | Instance ID | id             | status   |
      | RFU_Req01   | [RFU_Res01.id] | REJECTED |
    And "Realtime Risk Factor Update Error" messages are filtered by "externalId" should be
      | Instance ID  | externalId             | code  | message                                            |
      | RRFU_error01 | [RFU_Req01.rfUpdateId] | 30108 | Asset class and Instrument type should be matched. |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | type | value | dataClass | venue |
      | RFU02       | RZ_ST_Rate1M | LTP  | 500   | RATE      | CME   |
    Then response of the request "RFU02" should be
      | Instance ID |
      | RFU_Res02   |
    Then "Realtime Risk Factor Update" messages are filtered by "id" should be
      | Instance ID | id             | status |
      | RFU_Req02   | [RFU_Res02.id] | POSTED |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | type | value  | dataClass |
      | RFU03       | RZ_MD_INS_01 | LTP  | -55.99 | STATISTIC |
    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp    |
      | RFU_Res3    | RZ_MD_INS_01 | -55.99 |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | type | value | dataClass | venue |
      | RFU04       | RZ_MD_INS_01 | LTP  | 400   | PRICE     | CME   |
    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp   |
      | RFU_Res4    | RZ_MD_INS_01 | 400.0 |

  @wip3
  Scenario: TC_MD_003 MD update with invalid value for data class/Sub Class/Venue/type/SYMBOL
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol          | type | value | dataClass | venue | subClass |
      | RFU01       | RZ_MD_INS1_TEST | LTP  | 5000  | STATISTIC | CME   | ACTUAL   |
    Then response of the request "RFU01" should be
      | Instance ID |
      | RFU_Res01   |
    Then "Realtime Risk Factor Update" messages are filtered by "id" should be
      | Instance ID | id             | status   |
      | RFU_Req01   | [RFU_Res01.id] | REJECTED |
    And "Realtime Risk Factor Update Error" messages are filtered by "externalId" should be
      | Instance ID  | externalId             | code  | message                           |
      | RRFU_error01 | [RFU_Req01.rfUpdateId] | 30100 | Symbol is not found in the system |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol | type | value | dataClass | venue | subClass |
      | RFU02       |        | LTP  | 5000  | STATISTIC | CME   | ACTUAL   |
    Then response of the request "RFU02" should be
      | Instance ID |
      | RFU_Res02   |
    Then "Realtime Risk Factor Update" messages are filtered by "id" should be
      | Instance ID | id             | status   |
      | RFU_Req02   | [RFU_Res02.id] | REJECTED |
    And "Realtime Risk Factor Update Error" messages are filtered by "externalId" should be
      | Instance ID  | externalId             | code  | message                           |
      | RRFU_error02 | [RFU_Req02.rfUpdateId] | 30100 | Symbol is not found in the system |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | type | value | dataClass | venue | subClass | currency |
      | RFU03       | RZ_MD_INS_01 | LTP  | 5000  | STATISTIC | CME   | ACTUAL   | TEST     |
    Then response of the request "RFU03" should be
      | Instance ID |
      | RFU_Res03   |
    Then "Realtime Risk Factor Update" messages are filtered by "id" should be
      | Instance ID | id             | status   |
      | RFU_Req03   | [RFU_Res03.id] | REJECTED |
    And "Realtime Risk Factor Update Error" messages are filtered by "externalId" should be
      | Instance ID  | externalId             | code  | message                             |
      | RRFU_error03 | [RFU_Req03.rfUpdateId] | 30101 | Currency is not found in the system |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | type | value | dataClass | venue | subClass | currency |
      | RFU04       | RZ_MD_INS_01 | LTP  | 5000  | STATISTIC | CME   | ACTUAL   | CAD      |
    Then response of the request "RFU04" should be
      | Instance ID |
      | RFU_Res04   |
    Then "Realtime Risk Factor Update" messages are filtered by "id" should be
      | Instance ID | id             | status   |
      | RFU_Req04   | [RFU_Res04.id] | REJECTED |
    And "Realtime Risk Factor Update Error" messages are filtered by "externalId" should be
      | Instance ID  | externalId             | code  | message                             |
      | RRFU_error04 | [RFU_Req04.rfUpdateId] | 30101 | Currency is not found in the system |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | type | value   | dataClass | venue | subClass |
      | RFU06       | RZ_MD_INS_01 | LTP  | 1000000 | STATISTIC | test  | ACTUAL   |
    Then response of the request "RFU06" should be
      | Instance ID |
      | RFU_Res06   |
    Then "Realtime Risk Factor Update" messages are filtered by "id" should be
      | Instance ID | id             | status   |
      | RFU_Req06   | [RFU_Res06.id] | REJECTED |
    And "Realtime Risk Factor Update Error" messages are filtered by "externalId" should be
      | Instance ID  | externalId             | code  | message                          |
      | RRFU_error06 | [RFU_Req06.rfUpdateId] | 30105 | Venue is not found in the system |

  @wip4
  Scenario: TC_MD_004 MD update for the BB/BO/LTP/MID/AI/CONVEXITY/MACAULAY_DURATION with valid values
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | type              | value   |
      | RFU01       | RZ_MD_INS_01 | BB                | 14.0    |
      | RFU02       | RZ_MD_INS_01 | BO                | 0.88    |
      | RFU03       | RZ_MD_INS_01 | MID               | 0.0089  |
      | RFU04       | RZ_MD_INS_01 | LTP               | 88.88   |
      | RFU05       | RZ_MD_INS_01 | AI                | 800     |
      | RFU06       | RZ_MD_INS_01 | CONVEXITY         | 1236.99 |
      | RFU07       | RZ_MD_INS_01 | MACAULAY_DURATION | 0.99    |
      | RFU08       | RZ_MD_INS_01 | DV01              | 65      |
    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | bb   | bo   | ltp   | mid    | ai    | convexity | macaulayDuration | dv01 |
      | RFU_Res1    | RZ_MD_INS_01 | 14.0 | 0.88 | 88.88 | 0.0089 | 800.0 | 1236.99   | 0.99             | 65.0 |

  @wip5
  Scenario: TC_MD_005 MD update for the BB/BO/MID/AI/CONVEXITY/MACAYLAY_DURATION/DV01 with negative values
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | type              | value    |
      | RFU01       | RZ_MD_INS_01 | BB                | -24.0    |
      | RFU02       | RZ_MD_INS_01 | BO                | -10.88   |
      | RFU03       | RZ_MD_INS_01 | MID               | -1.9     |
      | RFU04       | RZ_MD_INS_01 | AI                | -800     |
      | RFU05       | RZ_MD_INS_01 | CONVEXITY         | -2000.99 |
      | RFU06       | RZ_MD_INS_01 | MACAULAY_DURATION | -99      |
      | RFU07       | RZ_MD_INS_01 | DV01              | -65      |
    Then "Realtime Risk Factor Value" messages are filtered by "symbol" should be
      | Instance ID | symbol       | bb    | bo     | mid  | ai     | dv01  | convexity | macaulayDuration |
      | RFU_Res1    | RZ_MD_INS_01 | -24.0 | -10.88 | -1.9 | -800.0 | -65.0 | -2000.99  | -99.0            |

  @wip6
  Scenario: TC_MD_006 MD update for the BB/BO/MID/AI/CONVEXITY/MACAYLAY_DURATION/DV01 with lengthy values
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | type              | value                       |
      | RFU01       | RZ_MD_INS_01 | BB                | 200000000000000000000000000 |
      | RFU02       | RZ_MD_INS_01 | BO                | 100000000000000000000000099 |
      | RFU03       | RZ_MD_INS_01 | MID               | 300000000000000000000000999 |
      | RFU04       | RZ_MD_INS_01 | AI                | 600000000000000000000000000 |
      | RFU05       | RZ_MD_INS_01 | CONVEXITY         | 700000000000000000000000000 |
      | RFU06       | RZ_MD_INS_01 | MACAULAY_DURATION | 800000000000000000000000000 |
      | RFU07       | RZ_MD_INS_01 | DV01              | 900000000000000009999999999 |
    Then "Realtime Risk Factor Value" messages are filtered by "symbol" should be
      | Instance ID | symbol       | bb                          | bo                          | mid                         | ai                          | dv01                        | convexity                   | macaulayDuration            |
      | RFU_Res1    | RZ_MD_INS_01 | 200000000000000000000000000 | 100000000000000000000000099 | 300000000000000000000000999 | 600000000000000000000000000 | 900000000000000009999999999 | 700000000000000000000000000 | 800000000000000000000000000 |

  @wip7
  Scenario: TC_MD_007 MD update for the BB/BO/LTP/MID/AI/CONVEXITY/MACAULAY_DURATION with subClass=THEORETICAL
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | type              | value   | subClass    |
      | RFU01       | RZ_MD_INS_01 | BB                | 14.0    | THEORETICAL |
      | RFU02       | RZ_MD_INS_01 | BO                | 0.88    | THEORETICAL |
      | RFU03       | RZ_MD_INS_01 | MID               | 0.0089  | THEORETICAL |
      | RFU04       | RZ_MD_INS_01 | LTP               | 88.88   | THEORETICAL |
      | RFU05       | RZ_MD_INS_01 | AI                | 800     | THEORETICAL |
      | RFU06       | RZ_MD_INS_01 | CONVEXITY         | 1236.99 | THEORETICAL |
      | RFU07       | RZ_MD_INS_01 | MACAULAY_DURATION | 0.99    | THEORETICAL |
      | RFU08       | RZ_MD_INS_01 | DV01              | 65      | THEORETICAL |
    Then response of the request "RFU01" should be
      | Instance ID |
      | RFU_Res01   |
    Then "Realtime Risk Factor Update" messages are filtered by "id" should be
      | Instance ID | id             | status   |
      | RFU_Req01   | [RFU_Res01.id] | REJECTED |
    And "Realtime Risk Factor Update Error" messages are filtered by "externalId" should be
      | Instance ID  | externalId             | code  | message                                                            |
      | RRFU_error01 | [RFU_Req01.rfUpdateId] | 30106 | Pricing Function is required for all THEORETICAL sub class updates |
    Then response of the request "RFU02" should be
      | Instance ID |
      | RFU_Res02   |
    Then "Realtime Risk Factor Update" messages are filtered by "id" should be
      | Instance ID | id             | status   |
      | RFU_Req02   | [RFU_Res02.id] | REJECTED |
    And "Realtime Risk Factor Update Error" messages are filtered by "externalId" should be
      | Instance ID  | externalId             | code  | message                                                            |
      | RRFU_error02 | [RFU_Req02.rfUpdateId] | 30106 | Pricing Function is required for all THEORETICAL sub class updates |
    Then response of the request "RFU03" should be
      | Instance ID |
      | RFU_Res03   |
    Then "Realtime Risk Factor Update" messages are filtered by "id" should be
      | Instance ID | id             | status   |
      | RFU_Req03   | [RFU_Res03.id] | REJECTED |
    And "Realtime Risk Factor Update Error" messages are filtered by "externalId" should be
      | Instance ID  | externalId             | code  | message                                                            |
      | RRFU_error03 | [RFU_Req03.rfUpdateId] | 30106 | Pricing Function is required for all THEORETICAL sub class updates |
    Then response of the request "RFU04" should be
      | Instance ID |
      | RFU_Res04   |
    Then "Realtime Risk Factor Update" messages are filtered by "id" should be
      | Instance ID | id             | status   |
      | RFU_Req04   | [RFU_Res04.id] | REJECTED |
    And "Realtime Risk Factor Update Error" messages are filtered by "externalId" should be
      | Instance ID  | externalId             | code  | message                                                            |
      | RRFU_error04 | [RFU_Req04.rfUpdateId] | 30106 | Pricing Function is required for all THEORETICAL sub class updates |
    Then response of the request "RFU05" should be
      | Instance ID |
      | RFU_Res05   |
    Then "Realtime Risk Factor Update" messages are filtered by "id" should be
      | Instance ID | id             | status   |
      | RFU_Req05   | [RFU_Res05.id] | REJECTED |
    And "Realtime Risk Factor Update Error" messages are filtered by "externalId" should be
      | Instance ID  | externalId             | code  | message                                                            |
      | RRFU_error05 | [RFU_Req05.rfUpdateId] | 30106 | Pricing Function is required for all THEORETICAL sub class updates |
    Then response of the request "RFU06" should be
      | Instance ID |
      | RFU_Res06   |
    Then "Realtime Risk Factor Update" messages are filtered by "id" should be
      | Instance ID | id             | status   |
      | RFU_Req06   | [RFU_Res06.id] | REJECTED |
    And "Realtime Risk Factor Update Error" messages are filtered by "externalId" should be
      | Instance ID  | externalId             | code  | message                                                            |
      | RRFU_error06 | [RFU_Req06.rfUpdateId] | 30106 | Pricing Function is required for all THEORETICAL sub class updates |
    Then response of the request "RFU07" should be
      | Instance ID |
      | RFU_Res07   |
    Then "Realtime Risk Factor Update" messages are filtered by "id" should be
      | Instance ID | id             | status   |
      | RFU_Req07   | [RFU_Res07.id] | REJECTED |
    And "Realtime Risk Factor Update Error" messages are filtered by "externalId" should be
      | Instance ID  | externalId             | code  | message                                                            |
      | RRFU_error07 | [RFU_Req07.rfUpdateId] | 30106 | Pricing Function is required for all THEORETICAL sub class updates |
    Then response of the request "RFU08" should be
      | Instance ID |
      | RFU_Res08   |
    Then "Realtime Risk Factor Update" messages are filtered by "id" should be
      | Instance ID | id             | status   |
      | RFU_Req08   | [RFU_Res08.id] | REJECTED |
    And "Realtime Risk Factor Update Error" messages are filtered by "externalId" should be
      | Instance ID  | externalId             | code  | message                                                            |
      | RRFU_error08 | [RFU_Req08.rfUpdateId] | 30106 | Pricing Function is required for all THEORETICAL sub class updates |

  @wip8
  Scenario: TC_MD_008 MD update for the BB/BO/LTP/MID/AI/CONVEXITY/MACAULAY_DURATION with different venues
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | type | value | venue    |
      | RFU01       | RZ_MD_INS_01 | BB   | 17.0  | CoinBase |
      | RFU02       | RZ_MD_INS_01 | BO   | 6.88  | CCCAGG   |
      | RFU03       | RZ_MD_INS_01 | MID  | 55.89 | INT      |
    Then "Realtime Risk Factor Value" messages are filtered by "symbol,mid" should be
      | Instance ID | symbol       | bb   | bo   | mid   | venue |
      | RFU_Res1    | RZ_MD_INS_01 | 17.0 | 6.88 | 55.89 |       |

  @wip9
  Scenario: TC_MD_009 Multiple MD update for the LTP with different VALUES
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | type | value |
      | RFU01       | RZ_MD_INS_01 | LTP  | 55.0  |
      | RFU02       | RZ_MD_INS_01 | LTP  | 65.88 |
      | RFU03       | RZ_MD_INS_01 | LTP  | 35.89 |
    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp   |
      | RFU_Res1    | RZ_MD_INS_01 | 35.89 |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | type | value    | venue  |
      | RFU01       | RZ_MD_INS_01 | LTP  | 75.0     | CME    |
      | RFU02       | RZ_MD_INS_01 | LTP  | 22227.88 | INT    |
      | RFU03       | RZ_MD_INS_01 | LTP  | 350.09   | CCCAGG |
    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp    |
      | RFU_Res1    | RZ_MD_INS_01 | 350.09 |

  @wip10
  Scenario: TC_MD_10 MD update for the LTP with 0
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | type | value |
      | RFU01       | RZ_MD_INS_01 | LTP  | 0     |
    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp |
      | RFU_Res1    | RZ_MD_INS_01 | 0   |

  @wip11
  Scenario: TC_MD_11 MD update without subClass/dataClass
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | type | value | subClass |
      | RFU01       | RZ_MD_INS_01 | LTP  | 553   |          |
    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp |
      | RFU_Res1    | RZ_MD_INS_01 | 553 |
    When "Realtime Risk Factor Update" messages are submitted with following values
      | Instance ID | symbol       | type | value | dataClass |
      | RFU01       | RZ_MD_INS_01 | LTP  | 553   |           |
    Then "Realtime Risk Factor Value" messages are filtered by "symbol,ltp" should be
      | Instance ID | symbol       | ltp |
      | RFU_Res1    | RZ_MD_INS_01 | 553 |
