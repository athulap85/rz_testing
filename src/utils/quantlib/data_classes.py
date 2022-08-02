import QuantLib as ql
import datetime
from enum import Enum

date_format = '%Y-%m-%d'


class Instrument:
    class CouponFrequency(Enum):
        MONTHLY = 1
        QUARTERLY = 2
        SEMI_ANNUAL = 3
        ANNUAL = 4

    class BusinessDayConvention(Enum):
        DAY_FOLLOWING = 1
        DAY_PRECEDING = 2
        UNADJUSTED = 3
        MODIFIED_FOLLOWING = 4
        MODIFIED_PRECEDING = 5

    class DayCountConvention(Enum):
        THIRTY_DIVIDED_THREE_HUNDRED_AND_SIXTY = 1
        THIRTY_E_DIVIDED_THREE_HUNDRED_AND_SIXTY_ISDA = 2
        THIRTY_E_DIVIDED_THREE_HUNDRED_AND_SIXTY = 3
        THIRTY_A_DIVIDED_THREE_HUNDRED_AND_SIXTY = 4
        ACTUAL_DIVIDED_ACTUAL_ICMA = 5
        ACTUAL_DIVIDED_ACTUAL_ISDA = 6
        ACTUAL_DIVIDED_THREE_HUNDRED_AND_SIXTY_FIVE_FIXED = 7
        ACTUAL_DIVIDED_THREE_HUNDRED_AND_SIXTY = 8
        ACTUAL_DIVIDED_ACTUAL_AFB = 9
        ACTUAL_DIVIDED_THREE_HUNDRED_AND_SIXTY_FOUR = 10
        ACTUAL_DIVIDED_THREE_HUNDRED_AND_SIXTY_FIVE_L = 11
        BUS_DIVIDED_TWO_HUNDRED_AND_FIFTY_TWO = 12

    def __init__(self):
        self._issue_date = None
        self._maturity_date = None
        self._first_coupon_date = None
        self._next_to_last_date = None
        self._coupon_frequency = None
        self._business_day_convention = None
        self._coupon_rate = None
        self._face_value = None
        self._day_count_convention = None

    @property
    def issue_date(self):
        return ql.Date(self._issue_date, date_format)

    @property
    def maturity_date(self):
        return ql.Date(self._maturity_date, date_format)

    @property
    def first_coupon_date(self):
        return ql.Date(self._first_coupon_date, date_format)

    @property
    def next_to_last_date(self):
        return ql.Date(self._next_to_last_date, date_format)

    @property
    def coupon_frequency(self):
        if self._coupon_frequency == Instrument.CouponFrequency.MONTHLY:
            return ql.Monthly
        elif self._coupon_frequency == Instrument.CouponFrequency.QUARTERLY:
            return ql.Quarterly
        elif self._coupon_frequency == Instrument.CouponFrequency.SEMI_ANNUAL:
            return ql.Semiannual
        elif self._coupon_frequency == Instrument.CouponFrequency.ANNUAL:
            return ql.Annual

    @property
    def business_day_convention(self):
        if self._business_day_convention == Instrument.BusinessDayConvention.DAY_FOLLOWING:
            return ql.Following
        elif self._business_day_convention == Instrument.BusinessDayConvention.DAY_PRECEDING:
            return ql.Preceding
        elif self._business_day_convention == Instrument.BusinessDayConvention.UNADJUSTED:
            return ql.Unadjusted
        elif self._business_day_convention == Instrument.BusinessDayConvention.MODIFIED_FOLLOWING:
            return ql.ModifiedFollowing
        elif self._business_day_convention == Instrument.BusinessDayConvention.MODIFIED_PRECEDING:
            return ql.ModifiedPreceding

    @property
    def coupon_rate(self):
        return self._coupon_rate

    @property
    def face_value(self):
        return self._face_value

    @property
    def day_count_convention(self):
        if self._day_count_convention == Instrument.DayCountConvention.THIRTY_DIVIDED_THREE_HUNDRED_AND_SIXTY:
            return ql.Thirty360()
        elif self._day_count_convention == Instrument.DayCountConvention.THIRTY_E_DIVIDED_THREE_HUNDRED_AND_SIXTY_ISDA:
            return ql.Thirty360(ql.Thirty360.ISDA)
        elif self._day_count_convention == Instrument.DayCountConvention.THIRTY_E_DIVIDED_THREE_HUNDRED_AND_SIXTY:
            pass
        elif self._day_count_convention == Instrument.DayCountConvention.THIRTY_A_DIVIDED_THREE_HUNDRED_AND_SIXTY:
            return ql.Actual360()
        elif self._day_count_convention == Instrument.DayCountConvention.ACTUAL_DIVIDED_ACTUAL_ICMA:
            return ql.ActualActual(ql.ActualActual.ICMA)
        elif self._day_count_convention == Instrument.DayCountConvention.ACTUAL_DIVIDED_ACTUAL_ISDA:
            return ql.ActualActual(ql.ActualActual.ISDA)
        elif self._day_count_convention == Instrument.DayCountConvention.ACTUAL_DIVIDED_THREE_HUNDRED_AND_SIXTY_FIVE_FIXED:
            return ql.Actual365Fixed()
        elif self._day_count_convention == Instrument.DayCountConvention.ACTUAL_DIVIDED_THREE_HUNDRED_AND_SIXTY:
            return ql.Actual360()
        elif self._day_count_convention == Instrument.DayCountConvention.ACTUAL_DIVIDED_ACTUAL_AFB:
            pass
        elif self._day_count_convention == Instrument.DayCountConvention.ACTUAL_DIVIDED_THREE_HUNDRED_AND_SIXTY_FOUR:
            return ql.Actual364()
        elif self._day_count_convention == Instrument.DayCountConvention.ACTUAL_DIVIDED_THREE_HUNDRED_AND_SIXTY_FIVE_L:
            pass
        elif self._day_count_convention == Instrument.DayCountConvention.BUS_DIVIDED_TWO_HUNDRED_AND_FIFTY_TWO:
            pass

    @issue_date.setter
    def issue_date(self, issue_date):
        self.validate_date(issue_date)
        self._issue_date = issue_date

    @maturity_date.setter
    def maturity_date(self, maturity_date):
        self.validate_date(maturity_date)
        self._maturity_date = maturity_date

    @first_coupon_date.setter
    def first_coupon_date(self, first_coupon_date):
        self.validate_date(first_coupon_date)
        self._first_coupon_date = first_coupon_date

    @next_to_last_date.setter
    def next_to_last_date(self, next_to_last_date):
        self.validate_date(next_to_last_date)
        self._next_to_last_date = next_to_last_date

    @coupon_frequency.setter
    def coupon_frequency(self, coupon_frequency: CouponFrequency):
        self._coupon_frequency = coupon_frequency

    @business_day_convention.setter
    def business_day_convention(self, business_day_convention: BusinessDayConvention):
        self._business_day_convention = business_day_convention

    @coupon_rate.setter
    def coupon_rate(self, coupon_rate: float):
        self._coupon_rate = coupon_rate

    @face_value.setter
    def face_value(self, face_value: float):
        self._face_value = face_value

    @day_count_convention.setter
    def day_count_convention(self, day_count_convention: DayCountConvention):
        self._day_count_convention = day_count_convention

    def validate_date(self, date_string):
        try:
            date_obj = datetime.datetime.strptime(date_string, date_format)
        except ValueError:
            assert False, f"Incorrect data format, should be YYYY-MM-DD, received {date_string}"


