import logging
import re
from src.utils.instance_registry import InstanceRegistry
from random import randint
from datetime import datetime
from dateutil.relativedelta import relativedelta
from src.refdata.refdata_manager import RefDataManager
from src.transaction_data.interfaceManager import InterfaceManager
from src.utils.data_query import DataQuery, Operator

from src.utils.quantlib.data_classes import Instrument
from src.utils.quantlib.functions.fixed_rate_bond import get_clean_price

BLUESHIFT_API = "BLUESHIFT_API"


class ResolverChain:
    instance = None
    resolver = None

    def __new__(cls):
        if cls.instance is None:
            cls.instance = super(ResolverChain, cls).__new__(cls)
            cls.build_chain(cls)
        return cls.instance

    def build_chain(self):
        self.resolver = InstanceResolver(DateTimeResolver(StringResolver(QuantLibFunctionsResolver(None))))

    def resolve(self, value):
        return self.resolver.resolve(value)


class Resolver:

    def __init__(self, next_resolver):
        self.next_resolver = next_resolver

    def resolve(self, value):
        value_out = self.process(value)
        if str(value_out) != str(value):
            logging.info(f"{self.__class__.__name__} In=>Out : {value}=>{value_out}")
        if self.next_resolver is not None:
            return self.next_resolver.resolve(value_out)
        else:
            return value_out

    def process(self, value):
        return value


class InstanceResolver(Resolver):

    def __init__(self, next_resolver):
        self.next_resolver = next_resolver
        self.instance_pattern = re.compile(r"\[(.+)\.(.+)\]")
        self.table_pattern = re.compile(r"\[(.+)\\]")

    def process(self, value):
        match = self.instance_pattern.search(str(value))
        if match is not None:
            instance_key = match.group(1)
            field_name = match.group(2)

            instance = InstanceRegistry().get_instance(instance_key)
            field_value = instance.get_field_value(field_name)
            if field_value is not None:
                value = field_value
            else:
                assert False, f"In {value}, field [{field_name}] is unknown"
        elif match := self.table_pattern.search(value):
            logging.debug("Table found.")
            table_key = match.group(1)

        return value


class DateTimeResolver(Resolver):

    def __init__(self, next_resolver):
        self.next_resolver = next_resolver
        self.date_pattern = re.compile(r"date\(today(([+-]?)(\d+)([dmY]))?,(.+)\)")

    def process(self, value):
        match = self.date_pattern.search(str(value))

        if match is not None:
            date = datetime.today()
            date_format = match.group(5)
            if match.group(1) is not None:
                operator = match.group(2)
                number = int(match.group(3))
                delta_type = match.group(4)

                if delta_type == 'd':
                    delta = relativedelta(days=number)
                elif delta_type == 'm':
                    delta = relativedelta(months=number)
                elif delta_type == 'Y':
                    delta = relativedelta(years=number)

                if operator == '+':
                    date = date + delta
                elif operator == '-':
                    date = date - delta

            value = date.strftime(date_format)

        return value


class StringResolver(Resolver):

    def process(self, value):
        match = re.search(r"random\((.+),(\d+)\)", str(value))

        if match is not None:
            prefix = match.group(1)
            length = int(match.group(2))

            random_num = str(randint(0, 10 ** length))
            temp_number = random_num.zfill(length)
            value = prefix + str(temp_number)

        return value


class QuantLibFunctionsResolver(Resolver):

    def __init__(self, next_resolver):
        self.next_resolver = next_resolver
        self.current_value_pattern = re.compile(r"calculate_current_value\((.+),(.+),(.+)\)")
        self.current_value_pos_level_pattern = re.compile(r"calculate_current_value\((.+),(.+),(.+),(.+)\)")
        self.stressed_value_pattern = re.compile(r"calculate_stressed_value\((.+),(.+),(.+)\)")
        self.stressed_value_pos_level_pattern = re.compile(r"calculate_stressed_value\((.+),(.+),(.+),(.+)\)")

    def process(self, value):
        match = self.current_value_pattern.search(str(value))

        if match is not None:
            logging.info("TEMP Matched " + value)
            participant = match.group(1)
            account = match.group(2)
            scenario = match.group(3)

            query = DataQuery("Position")
            query.add_filter("participant", Operator.EQUAL, participant)
            query.add_filter("account", Operator.EQUAL, account)
            query.add_filter("level", Operator.EQUAL, "ACCOUNT")
            responses, error_message = InterfaceManager().query_data(BLUESHIFT_API, query)
            assert error_message is None, f"Unable to fetch positions for participant [{participant}] and " \
                                          f"Account [{account}]. Error : [{error_message}]"

            current_value = 0.0
            stressed_value = 0.0
            for position in responses:
                symbol = position.get_field_value("symbol")
                stressed_value = stressed_value + self.calculate_stressed_value(position, scenario)
                current_value = current_value + self.calculate_current_value(position)

                logging.info(f"Stress Results Symbol: {symbol}, Current Value: {current_value},"
                             f" Stressed Value: {stressed_value}")

        return value


    def calculate_value(self, position, scenario_id=None):
        logging.info(f"calculate_stressed_value")
        symbol = position.get_field_value("symbol")
        net_position = position.get_field_value("netPosition")

        instrument_msg, error_msg = RefDataManager().get_instance("Instruments", symbol)
        assert error_msg is None, f"Unable to fetch instrument with symbol: [{symbol}]. Error : [{error_msg}]"

        bond_obj = self.create_bond_instrument(instrument_msg)

        spot_rates = self.get_spot_rates(instrument_msg.get_field_value("Discount Curve"))
        if scenario_id is not None:
            spot_rates = self.adjust_spot_rates(spot_rates, scenario_id)

        spot_rates = {k[0]: v for k, v in sorted(spot_rates.items(), key=lambda item: item[1])}
        logging.info(spot_rates)

        clean_price = get_clean_price(datetime.today().strftime('%Y-%m-%d'), bond_obj, spot_rates)
        print(f"Clean Price : {clean_price}")
        return clean_price * net_position

    def adjust_spot_rates(self, spot_rates, scenario_id):
        scenario_msg, error_msg = RefDataManager().get_instance("Stress Scenarios", scenario_id)
        assert error_msg is None, f"Unable to fetch stress scenario with ID: [{scenario_id}]. Error : [{error_msg}]"

        shift_ids = scenario_msg.get_field_value("Shift")

        shift_id_list = shift_ids.split(",")
        for key in shift_id_list:
            shift_msg, error_msg = RefDataManager().get_instance("Shifts", key)
            assert error_msg is None, f"Unable to fetch shifts with ID: [{scenario_id}]. Error : [{error_msg}]"

            risk_factor_type = shift_msg.get_field_value("Risk Factor Type")
            shift_symbol = shift_msg.get_field_value("Symbol")
            shift_type = shift_msg.get_field_value("Shift Type")
            shift_percentage = shift_msg.get_field_value("Shift Percentage")

            if risk_factor_type != "INTEREST_RATE":
                continue

            for (tenor, symbol), rate in spot_rates.items():
                if symbol != shift_symbol:
                    continue

                value = rate
                if shift_percentage == "ABSOLUTE":
                    value = rate + shift_percentage
                elif shift_percentage == "RELATIVE":
                    value = rate + (rate * shift_percentage / 100)

                spot_rates[(tenor, symbol)] = value

        return spot_rates

    def create_bond_instrument(self, instrument_msg):
        bond = Instrument()
        bond.issue_date = instrument_msg.get_field_value("Issue Date")
        bond.maturity_date = instrument_msg.get_field_value("Expiry Date")
        bond.first_coupon_date = instrument_msg.get_field_value("First Coupon Date")
        bond.next_to_last_date = instrument_msg.get_field_value("Next To Last Date")
        bond.business_day_convention = Instrument.BusinessDayConvention[
            self.to_upper(instrument_msg.get_field_value("Business Day Convention"))]
        bond.day_count_convention = Instrument.DayCountConvention[
            self.to_upper(instrument_msg.get_field_value("Day Count Convention"))]
        bond.coupon_frequency = Instrument.CouponFrequency[
            self.to_upper(instrument_msg.get_field_value("Coupon Frequency"))]
        bond.face_value = instrument_msg.get_field_value("Par Value")
        bond.coupon_rate = instrument_msg.get_field_value("Coupon")

        return bond

    @staticmethod
    def get_spot_rates(curve_identifier):
        query = DataQuery("Realtime Interest Curve Value")
        query.add_filter("curveIdentifier", Operator.EQUAL, curve_identifier)
        responses, error_message = InterfaceManager().query_data(BLUESHIFT_API, query)
        logging.info("Spot Rate Response: ")
        # spot_rates = {"0": 0.0002}
        spot_rates = {}
        for response in responses:
            tenor = response.get_field_value('tenor')
            symbol = response.get_field_value('symbol')
            rate = response.get_field_value('ltp')
            logging.info(f"{tenor} : {rate}")
            spot_rates[(tenor, symbol)] = round(rate/100, 4)

        return spot_rates

    @staticmethod
    def to_upper(value):
        return value.replace(" ", "_").upper()
