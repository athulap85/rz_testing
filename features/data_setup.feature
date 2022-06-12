Feature: data setup for hedging

  @wip
  Scenario: RefData setup for the Net Spotting

    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol          | Expiry Date | Issue Date | First Coupon Date | Next To Last Date |
      | Ins001      | INS_001       | RZ_NP_SYM_GB_05 | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        |

    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol          | Expiry Date | Issue Date | First Coupon Date | Next To Last Date |
      | Ins002      | INS_002       | RZ_NP_SYM_GB_06 | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        |

    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol          | Expiry Date | Issue Date | First Coupon Date | Next To Last Date |
      | Ins003      | INS_003       | RZ_NP_SYM_GB_07 | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        |

    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol          | Expiry Date | Issue Date | First Coupon Date | Next To Last Date |
      | Ins004      | INS_004       | RZ_NP_SYM_GB_08 | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        |

    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol          | Expiry Date | Issue Date | First Coupon Date | Next To Last Date |
      | Ins005      | INS_005       | RZ_NP_SYM_GB_11 | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        |

    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol          | Expiry Date | Issue Date | First Coupon Date | Next To Last Date |
      | Ins006      | INS_006       | RZ_NP_SYM_GB_10 | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        |


    Given instance "5-Years-T" of entity "Risk Portfolios" is copied with following values
      | Instance ID | Risk Portfolio Id | Holding Period | Hedge Instrument |
      | RISK03      | RZ_NP_RP_5Y_07    | 5              | RZ_NP_SYM_GB_05  |

    Given instance "5-Years-T" of entity "Risk Portfolios" is copied with following values
      | Instance ID | Risk Portfolio Id | Holding Period | Hedge Instrument |
      | RISK04      | RZ_NP_RP_5Y_08    | 5              | RZ_NP_SYM_GB_06  |

    Given instance "5-Years-T" of entity "Risk Portfolios" is copied with following values
      | Instance ID | Risk Portfolio Id | Holding Period | Hedge Instrument |
      | RISK05      | RZ_NP_RP_5Y_09    | 5              | RZ_NP_SYM_GB_07  |

    Given instance "5-Years-T" of entity "Risk Portfolios" is copied with following values
      | Instance ID | Risk Portfolio Id | Holding Period | Hedge Instrument |
      | RISK06      | RZ_NP_RP_5Y_10    | 5              | RZ_NP_SYM_GB_08  |

    Given instance "5-Years-T" of entity "Risk Portfolios" is copied with following values
      | Instance ID | Risk Portfolio Id | Holding Period | Hedge Instrument |
      | RISK01      | RZ_NP_RP_5Y_13    | 5              | RZ_NP_SYM_GB_11  |

    Given instance "5-Years-T" of entity "Risk Portfolios" is copied with following values
      | Instance ID | Risk Portfolio Id | Holding Period | Hedge Instrument |
      | RISK03      | RZ_NP_RP_5Y_12    | 5              | RZ_NP_SYM_GB_10  |

    Given instance "TSLA_0.75_07-06-26" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol         | Expiry Date | Risk Portfolio | Issue Date | First Coupon Date | Next To Last Date |
      | Ins007      | INS_007       | RZ_NP_SYM_CB_5 | 2027-12-31  | RZ_NP_RP_5Y_07 | 2022-03-31 | 2022-04-01        | 2025-12-15        |

    Given instance "TSLA_0.75_07-06-26" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol         | Expiry Date | Risk Portfolio | Issue Date | First Coupon Date | Next To Last Date |
      | Ins008      | INS_008       | RZ_NP_SYM_CB_6 | 2027-12-31  | RZ_NP_RP_5Y_08 | 2022-03-31 | 2022-04-01        | 2025-12-15        |

    Given instance "TSLA_0.75_07-06-26" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol         | Expiry Date | Risk Portfolio | Issue Date | First Coupon Date | Next To Last Date |
      | Ins009      | INS_009       | RZ_NP_SYM_CB_7 | 2027-12-31  | RZ_NP_RP_5Y_09 | 2022-03-31 | 2022-04-01        | 2025-12-15        |

    Given instance "TSLA_0.75_07-06-26" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol         | Expiry Date | Risk Portfolio | Issue Date | First Coupon Date | Next To Last Date |
      | Ins010      | INS_010       | RZ_NP_SYM_CB_8 | 2027-12-31  | RZ_NP_RP_5Y_10 | 2022-03-31 | 2022-04-01        | 2025-12-15        |

    Given instance "TSLA_0.75_07-06-26" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol         | Expiry Date | Risk Portfolio | Issue Date | First Coupon Date | Next To Last Date |
      | Ins011      | INS_011       | RZ_NP_SYM_CB_9 | 2027-12-31  | RZ_NP_RP_5Y_10 | 2022-03-31 | 2022-04-01        | 2025-12-15        |

    Given instance "TSLA_0.75_07-06-26" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol          | Expiry Date | Risk Portfolio | Issue Date | First Coupon Date | Next To Last Date |
      | Ins012      | INS_012       | RZ_NP_SYM_CB_12 | 2027-12-31  | RZ_NP_RP_5Y_13 | 2022-03-31 | 2022-04-01        | 2025-12-15        |

    Given instance "TSLA_0.75_07-06-26" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol          | Expiry Date | Risk Portfolio | Issue Date | First Coupon Date | Next To Last Date |
      | Ins013      | INS_013       | RZ_NP_SYM_CB_11 | 2027-12-31  | RZ_NP_RP_5Y_12 | 2022-03-31 | 2022-04-01        | 2025-12-15        |

    Given instance of entity "Participants" is created with following values
      | Instance ID | Participant Id | Name                 | LEI Code | Type            | Status |
      | Mem01       | RZ_NP_MEM_1    | Participant Test 001 | LEI_TEST | CLEARING_MEMBER | ACTIVE |

    Given instance "Rule1" of entity "Position Keys" is copied with following values
      | Instance ID | Position Key Id | Priority | Asset Class | Instrument Type | Market |
      | Key_001     | RZ_NP_IT_1      | 1        | RATES       | FIXED_RATE_BOND | YES    |





