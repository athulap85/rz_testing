import logging

import QuantLib as ql
from src.utils.quantlib.data_classes import Instrument

date_format = '%Y-%m-%d'


def get_zero_coupon_clean_price(todays_date: str, bond: Instrument, spot_rates: dict):
    logging.info("====  Zero Coupon Bond :: get_clean_price ====")
    logging.info(f"Input : Bond Instrument : {bond.to_string()}")
    logging.info(f"Input : Spot Rates : \n{str(spot_rates)}\n")

    todaysDate = ql.Date(todays_date, date_format)
    calendar = ql.UnitedStates(ql.UnitedStates.Settlement)

    ql.Settings.instance().evaluationDate = todaysDate

    spotRates = []
    spotDates = []

    spotDates.append(todaysDate)
    spotRates.append(list(spot_rates.values())[0])

    for tenor, spot_rate in spot_rates.items():
        spotDates.append(calendar.advance(todaysDate, ql.Period(tenor), ql.Unadjusted))
        spotRates.append(spot_rate)

    print('spotdates:', spotDates)

    dayCount = ql.ActualActual(ql.ActualActual.ISDA)
    interpolation = ql.Linear()
    compounding = ql.Compounded 
    compoundingFrequency = ql.Semiannual

    #creating spot curve
    spotCurve = ql.ZeroCurve(spotDates, spotRates, dayCount, calendar, interpolation, compounding, compoundingFrequency)
    spotCurve.enableExtrapolation()
    spotCurveHandle = ql.YieldTermStructureHandle(spotCurve)

    print(spotCurve.nodes())

    maturityDate = bond.maturity_date

    settlementDays = 2
    faceValue = bond.face_value

    zeroCouponBond = ql.ZeroCouponBond(settlementDays, calendar, faceValue, maturityDate)

    bondEngine = ql.DiscountingBondEngine(spotCurveHandle)
    zeroCouponBond.setPricingEngine(bondEngine)

    print("FixedRateBond.NPV() =", zeroCouponBond.NPV())
    print("DirtyPrice = ", zeroCouponBond.dirtyPrice())
    print("AccruedAmount = ", zeroCouponBond.accruedAmount())
    print("SettlementDate =", zeroCouponBond.settlementDate())

    print("Zero Coupon CleanPrice = ", zeroCouponBond.cleanPrice()) #this is the stressed price

    return zeroCouponBond.cleanPrice()
