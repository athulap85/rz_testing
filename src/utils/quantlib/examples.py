from src.utils.quantlib.data_classes import Instrument
from src.utils.quantlib.functions.fixed_rate_bond import get_clean_price
from src.utils.quantlib.functions.zero_coupon_bond import get_zero_coupon_clean_price

bond = Instrument()
bond.issue_date = "2021-09-29"
bond.maturity_date = "2026-09-29"
bond.first_coupon_date = "2022-03-29"
bond.next_to_last_date = "2026-03-29"
bond.business_day_convention = Instrument.BusinessDayConvention.UNADJUSTED
bond.day_count_convention = Instrument.DayCountConvention.ACTUAL_DIVIDED_ACTUAL_ISDA
bond.coupon_frequency = Instrument.CouponFrequency.SEMI_ANNUAL
bond.face_value = 100.0
bond.coupon_rate = 4.75


spot_rates = {
            "1D":   0.0083,
            "1M":   0.0083,
            "3M":   0.0106,
            "6M":   0.0158,
            "1Y":   0.0209,
            "2Y":   0.0255,
            "3Y":   0.0288,
            "5Y":   0.0290,
            "7Y":   0.0295,
            "10Y":  0.0305,
            "20Y":  0.0325,
            "30Y":  0.0335
            }


clean_price = get_clean_price("2022-08-07", bond, spot_rates)
print(f"Clean Price : {clean_price}")

clean_price = get_zero_coupon_clean_price("2022-08-07", bond, spot_rates)
print(f"Zero Coupon Clean Price : {clean_price}")
