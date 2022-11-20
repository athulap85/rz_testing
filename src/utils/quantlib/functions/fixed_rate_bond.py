import logging

import QuantLib as ql
from src.utils.quantlib.data_classes import Instrument

date_format = '%Y-%m-%d'


def get_clean_price(todays_date: str, bond: Instrument, spot_rates: dict):
    logging.info("====  get_clean_price ====")
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

    issueDate =  bond.issue_date
    maturityDate = bond.maturity_date
    firstCouponDate = bond.first_coupon_date
    nextToLastDate = bond.next_to_last_date
    tenor = ql.Period(bond.coupon_frequency)
    bussinessConvention = bond.business_day_convention
    dateGeneration = ql.DateGeneration.Forward
    monthEnd = False

    schedule = ql.Schedule(issueDate, maturityDate, tenor, calendar, bussinessConvention, bussinessConvention,
                            dateGeneration, monthEnd, firstCouponDate, nextToLastDate)

    if bond.instrument_type == "Stepped Coupon Bond":
        coupon = bond.coupon_rate
        coupons = []
        dates = list(schedule)
        for date in dates:
            coupon_val = bond.coupon_schedule.get(date, -1.0)
            if coupon_val != -1.0:
                coupon = coupon_val
            coupons.append(coupon)
        print("Coupons : ", coupons)
        coupons = [val / 100 for val in coupons]
    else:
        coupons = [bond.coupon_rate/100]

    settlementDays = 0
    faceValue = bond.face_value
    dayCount_bond = bond.day_count_convention

    fixedRateBond = ql.FixedRateBond(settlementDays, faceValue, schedule, coupons, dayCount_bond, bussinessConvention)

    bondEngine = ql.DiscountingBondEngine(spotCurveHandle)
    fixedRateBond.setPricingEngine(bondEngine)

    # print("FixedRateBond.NPV() =",fixedRateBond.NPV())
    # print("DirtyPrice = ",fixedRateBond.dirtyPrice())
    # print("AccruedAmount = ",fixedRateBond.accruedAmount())
    # print("DayCounter =",fixedRateBond.dayCounter())
    # print("SettlementDate =",fixedRateBond.settlementDate())
    # print("")

    print("CleanPrice = ", fixedRateBond.cleanPrice()) #this is the stressed price



    # printing cashflows and other intermediate steps
    # for i, c in enumerate(fixedRateBond.cashflows()):
    #     if c.date()>=todaysDate:
    #         spotRate = spotCurveHandle.zeroRate(c.date(), dayCount, compounding, compoundingFrequency, True)
    #         print(c.date(),"\n", spotRate)
    # print("")
    #
    # spotDatesISO = [i.ISO() for i in spotDates]
    # cashflow_dates=[]
    #
    # print ('%20s %12s %12s' % ("Date", "Amount", "disc Fac"))
    #
    # for i, c in enumerate(fixedRateBond.cashflows()):
    #     if c.date()>=todaysDate:
    #         print ('%20s %12f %12f' % (c.date(), c.amount(),spotCurve.discount(c.date())))
    #         cashflow_dates.append(c.date().ISO())

    return fixedRateBond.cleanPrice()