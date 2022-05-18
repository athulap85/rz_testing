Feature: data setup for hedging

  @wip
  Scenario: RefData setup for the Net Spotting

    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol         | Expiry Date | Issue Date | First Coupon Date | Next To Last Date |
      | Ins005      | INS_005       | test_SYM_GB_05 | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        |

    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol         | Expiry Date | Issue Date | First Coupon Date | Next To Last Date |
      | Ins006      | INS_006       | test_SYM_GB_06 | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        |

    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol         | Expiry Date | Issue Date | First Coupon Date | Next To Last Date |
      | Ins007      | INS_007       | test_SYM_GB_07 | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        |

    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol         | Expiry Date | Issue Date | First Coupon Date | Next To Last Date |
      | Ins007      | INS_008       | test_SYM_GB_08 | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        |

    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol         | Expiry Date | Issue Date | First Coupon Date | Next To Last Date |
      | Ins001      | INS_001       | test_SYM_GB_11 | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        |

    Given instance "US91282CCW91" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol         | Expiry Date | Issue Date | First Coupon Date | Next To Last Date |
      | Ins003      | INS_003       | test_SYM_GB_10 | 2027-12-31  | 2022-03-31 | 2022-12-10        | 2023-12-10        |


    Given instance "5-Years-T" of entity "Risk Portfolios" is copied with following values
      | Instance ID | Risk Portfolio Id | Holding Period | Hedge Instrument |
      | RISK03      | testRP_5Y_07      | 5              | test_SYM_GB_05   |

    Given instance "5-Years-T" of entity "Risk Portfolios" is copied with following values
      | Instance ID | Risk Portfolio Id | Holding Period | Hedge Instrument |
      | RISK04      | testRP_5Y_08      | 5              | test_SYM_GB_06   |

    Given instance "5-Years-T" of entity "Risk Portfolios" is copied with following values
      | Instance ID | Risk Portfolio Id | Holding Period | Hedge Instrument |
      | RISK05      | testRP_5Y_09      | 5              | test_SYM_GB_07   |

    Given instance "5-Years-T" of entity "Risk Portfolios" is copied with following values
      | Instance ID | Risk Portfolio Id | Holding Period | Hedge Instrument |
      | RISK06      | testRP_5Y_10      | 5              | test_SYM_GB_08   |

    Given instance "5-Years-T" of entity "Risk Portfolios" is copied with following values
      | Instance ID | Risk Portfolio Id | Holding Period | Hedge Instrument |
      | RISK01      | testRP_5Y_13      | 5              | test_SYM_GB_11   |

    Given instance "5-Years-T" of entity "Risk Portfolios" is copied with following values
      | Instance ID | Risk Portfolio Id | Holding Period | Hedge Instrument |
      | RISK03      | testRP_5Y_12      | 5              | test_SYM_GB_10   |

    Given instance "TSLA_0.75_07-06-26" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol       | Expiry Date | Risk Portfolio | Issue Date | First Coupon Date | Next To Last Date |
      | Ins007      | INS_006       | testSYM_CB_5 | 2027-12-31  | testRP_5Y_07   | 2022-03-31 | 2022-04-01        | 2025-12-15        |

    Given instance "TSLA_0.75_07-06-26" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol       | Expiry Date | Risk Portfolio | Issue Date | First Coupon Date | Next To Last Date |
      | Ins008      | INS_008       | testSYM_CB_6 | 2027-12-31  | testRP_5Y_08   | 2022-03-31 | 2022-04-01        | 2025-12-15        |

    Given instance "TSLA_0.75_07-06-26" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol       | Expiry Date | Risk Portfolio | Issue Date | First Coupon Date | Next To Last Date |
      | Ins009      | INS_009       | testSYM_CB_7 | 2027-12-31  | testRP_5Y_09   | 2022-03-31 | 2022-04-01        | 2025-12-15        |

    Given instance "TSLA_0.75_07-06-26" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol       | Expiry Date | Risk Portfolio | Issue Date | First Coupon Date | Next To Last Date |
      | Ins009      | INS_009       | testSYM_CB_8 | 2027-12-31  | testRP_5Y_10   | 2022-03-31 | 2022-04-01        | 2025-12-15        |

    Given instance "TSLA_0.75_07-06-26" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol       | Expiry Date | Risk Portfolio | Issue Date | First Coupon Date | Next To Last Date |
      | Ins010      | INS_010       | testSYM_CB_9 | 2027-12-31  | testRP_5Y_10   | 2022-03-31 | 2022-04-01        | 2025-12-15        |

    Given instance "TSLA_0.75_07-06-26" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol        | Expiry Date | Risk Portfolio | Issue Date | First Coupon Date | Next To Last Date |
      | Ins012      | INS_012       | testSYM_CB_12 | 2027-12-31  | testRP_5Y_13   | 2022-03-31 | 2022-04-01        | 2025-12-15        |

    Given instance "TSLA_0.75_07-06-26" of entity "Instruments" is copied with following values
      | Instance ID | Instrument ID | Symbol        | Expiry Date | Risk Portfolio | Issue Date | First Coupon Date | Next To Last Date |
      | Ins010      | INS_010       | testSYM_CB_11 | 2027-12-31  | testRP_5Y_11   | 2022-03-31 | 2022-04-01        | 2025-12-15        |

    Given instance of entity "Participants" is created with following values
      | Instance ID | Participant Id | Name                 | LEI Code | Type            | Status |
      | Mem01       | testNP_MEM_2   | Participant Test 002 | LEI_TEST | CLEARING_MEMBER | ACTIVE |





