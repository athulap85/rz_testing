Feature: data setup for hedging

  @wip
  Scenario: RefData setup for the Net Spotting

#    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
#      | Instance ID | Instrument ID | Symbol           | Expiry Date | Issue Date | First Coupon Date | Next To Last Date | Par Value |
#      | Ins001      | INS_002       | RZ_NP3_SYM_GB_03 | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        | 100       |

    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol           | Expiry Date | Issue Date | First Coupon Date | Next To Last Date | Par Value |
      | Ins002      | INS_003       | RZ_NP1_SYM_GB_16 | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        | 100       |

#    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
#      | Instance ID | Instrument ID | Symbol           | Expiry Date | Issue Date | First Coupon Date | Next To Last Date | Par Value |
#      | Ins003      | INS_004       | RZ_NP2_SYM_GB_09 | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        | 100       |

#    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
#      | Instance ID | Instrument ID | Symbol          | Expiry Date | Issue Date | First Coupon Date | Next To Last Date |Par Value|
#      | Ins004      | INS_006       | RZ_NP_SYM_GB_06 | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        |100|
#
#    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
#      | Instance ID | Instrument ID | Symbol          | Expiry Date | Issue Date | First Coupon Date | Next To Last Date |Par Value|
#      | Ins005      | INS_007       | RZ_NP_SYM_GB_07 | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        |100|
#
#    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
#      | Instance ID | Instrument ID | Symbol           | Expiry Date | Issue Date | First Coupon Date | Next To Last Date | Par Value |
#      | Ins006      | INS_008       | RZ_NP5_SYM_GB_12 | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        | 100       |
#
#    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
#      | Instance ID | Instrument ID | Symbol           | Expiry Date | Issue Date | First Coupon Date | Next To Last Date | Par Value |
#      | Ins007      | INS_009       | RZ_NP6_SYM_GB_10 | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        | 100       |

#    Given instance "5-Years-T" of entity "Risk Portfolios" is copied with following values
#      | Instance ID | Risk Portfolio Id | Holding Period | Hedge Instrument |
#      | RISK01      | RZ_NP3_RP_5Y_03   | 5              | RZ_NP3_SYM_GB_03 |

#    Given instance "5-Years-T" of entity "Risk Portfolios" is copied with following values
#      | Instance ID | Risk Portfolio Id | Holding Period | Hedge Instrument |
#      | RISK02      | RZ_NP_RP_5Y_08    | 5              | RZ_NP_SYM_GB_06  |
#
#    Given instance "5-Years-T" of entity "Risk Portfolios" is copied with following values
#      | Instance ID | Risk Portfolio Id | Holding Period | Hedge Instrument |
#      | RISK03      | RZ_NP_RP_5Y_09    | 5              | RZ_NP_SYM_GB_07  |
#
#    Given instance "5-Years-T" of entity "Risk Portfolios" is copied with following values
#      | Instance ID | Risk Portfolio Id | Holding Period | Hedge Instrument |
#      | RISK04      | RZ_NP5_RP_5Y_14   | 5              | RZ_NP5_SYM_GB_12 |
#
    Given instance "5-Years-T" of entity "Risk Portfolios" is copied with following values
      | Instance ID | Risk Portfolio Id | Holding Period | Hedge Instrument |
      | RISK05      | RZ_NP1_RP_5Y_16   | 5              | RZ_NP1_SYM_GB_16 |

#    Given instance "5-Years-T" of entity "Risk Portfolios" is copied with following values
#      | Instance ID | Risk Portfolio Id | Holding Period | Hedge Instrument |
#      | RISK06      | RZ_NP2_RP_5Y_09   | 5              | RZ_NP2_SYM_GB_09 |

#    Given instance "5-Years-T" of entity "Risk Portfolios" is copied with following values
#      | Instance ID | Risk Portfolio Id | Holding Period | Hedge Instrument |
#      | RISK07      | RZ_NP6_RP_5Y_06   | 5              | RZ_NP6_SYM_GB_10 |

#    Given instance "TSLA_0.75_07-06-26" of entity "Instruments" is copied with following values
#      | Instance ID | Instrument ID | Symbol          | Expiry Date | Risk Portfolio  | Issue Date | First Coupon Date | Next To Last Date | Par Value |
#      | Ins_CP_001  | INS_007       | RZ_NP3_SYM_CB_3 | 2027-12-31  | RZ_NP3_RP_5Y_03 | 2022-03-31 | 2022-04-01        | 2025-12-15        | 100       |

    Given instance "TSLA_0.75_07-06-26" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol           | Expiry Date | Risk Portfolio  | Issue Date | First Coupon Date | Next To Last Date | Par Value |
      | Ins_CP_002  | INS_012       | RZ_NP1_SYM_CB_17 | 2027-12-31  | RZ_NP1_RP_5Y_16 | 2022-03-31 | 2022-04-01        | 2025-12-15        | 100       |

#    Given instance "TSLA_0.75_07-06-26" of entity "Instruments" is copied with following values
#      | Instance ID | Instrument ID | Symbol          | Expiry Date | Risk Portfolio  | Issue Date | First Coupon Date | Next To Last Date | Par Value |
#      | Ins_CP_003  | INS_013       | RZ_NP2_SYM_CB_9 | 2027-12-31  | RZ_NP2_RP_5Y_09 | 2022-03-31 | 2022-04-01        | 2025-12-15        | 100       |

            #    Given instance "TSLA_0.75_07-06-26" of entity "Instruments" is copied with following values
#      | Instance ID | Instrument ID | Symbol         | Expiry Date | Risk Portfolio | Issue Date | First Coupon Date | Next To Last Date |Par Value|
#      | Ins_CP_004      | INS_008       | RZ_NP_SYM_CB_6 | 2027-12-31  | RZ_NP_RP_5Y_08 | 2022-03-31 | 2022-04-01        | 2025-12-15        |100|
#
#    Given instance "TSLA_0.75_07-06-26" of entity "Instruments" is copied with following values
#      | Instance ID | Instrument ID | Symbol         | Expiry Date | Risk Portfolio | Issue Date | First Coupon Date | Next To Last Date |Par Value|
#      | Ins_CP_005      | INS_009       | RZ_NP_SYM_CB_7 | 2027-12-31  | RZ_NP_RP_5Y_09 | 2022-03-31 | 2022-04-01        | 2025-12-15        |100|
#
#    Given instance "TSLA_0.75_07-06-26" of entity "Instruments" is copied with following values
#      | Instance ID | Instrument ID | Symbol           | Expiry Date | Risk Portfolio  | Issue Date | First Coupon Date | Next To Last Date | Par Value |
#      | Ins_CP_006  | INS_010       | RZ_NP5_SYM_CB_13 | 2027-12-31  | RZ_NP5_RP_5Y_14 | 2022-03-31 | 2022-04-01        | 2025-12-15        | 100       |
#
#    Given instance "TSLA_0.75_07-06-26" of entity "Instruments" is copied with following values
#      | Instance ID | Instrument ID | Symbol           | Expiry Date | Risk Portfolio  | Issue Date | First Coupon Date | Next To Last Date | Par Value |
#      | Ins_CP_007  | INS_011       | RZ_NP5_SYM_CB_14 | 2027-12-31  | RZ_NP5_RP_5Y_14 | 2022-03-31 | 2022-04-01        | 2025-12-15        | 100       |
##
#    Given instance "TSLA_0.75_07-06-26" of entity "Instruments" is copied with following values
#      | Instance ID | Instrument ID | Symbol           | Expiry Date | Risk Portfolio  | Issue Date | First Coupon Date | Next To Last Date | Par Value |
#      | Ins_CP_008  | INS_013       | RZ_NP6_SYM_CB_11 | 2027-12-31  | RZ_NP6_RP_5Y_06 | 2022-03-31 | 2022-04-01        | 2025-12-15        | 100       |
#
#
#    Given instance of entity "Participants" is created with following values
#      | Instance ID | Participant Id | Name                 | LEI Code | Type            | Status |
#      | Mem01       | RZ_NP_MEM_1    | Participant Test 001 | LEI_TEST | CLEARING_MEMBER | ACTIVE |
#
#    Given instance "Rule1" of entity "Position Keys" is copied with following values
#      | Instance ID | Position Key Id | Priority | Asset Class | Instrument Type | Market |
#      | Key_001     | RZ_NP_IT_1      | 1        | RATES       | FIXED_RATE_BOND | YES    |





