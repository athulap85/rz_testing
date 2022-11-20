import logging
import re

from datetime import datetime

from configs.global_config import system_config
from src.utils.resolvers.resolver import Resolver
from src.refdata.refdata_manager import RefDataManager
from src.transaction_data.interfaceManager import InterfaceManager
from src.utils.data_query import DataQuery, Operator

from src.utils.quantlib.data_classes import Instrument
from src.utils.quantlib.functions.fixed_rate_bond import get_clean_price
from src.utils.quantlib.functions.zero_coupon_bond import get_zero_coupon_clean_price

BLUESHIFT_API = "BLUESHIFT_API"


class QuantLibFunctionsResolver(Resolver):

    def __init__(self, next_resolver):
        self.next_resolver = next_resolver
        self.current_value_pattern = re.compile(r"current_value\((.+),(.+)\)")
        self.current_value_pos_level_pattern = re.compile(r"current_value\((.+),(.+),(.+)\)")
        self.stressed_value_pattern = re.compile(r"stressed_value\((.+),(.+),(.+)\)")
        self.stressed_value_pos_level_pattern = re.compile(r"stressed_value\((.+),(.+),(.+),(.+)\)")

    def process(self, value):

        match = self.stressed_value_pos_level_pattern.search(str(value))
        if match is not None:
            logging.info("Calculating position level stressed value")
            participant = match.group(1)
            account = match.group(2)
            scenario = match.group(3)
            position_id = match.group(4)

            positions = self.find_positions(participant, account, position_id)
            return self.calculate_stressed_value(positions, scenario)

        match = self.current_value_pos_level_pattern.search(str(value))
        if match is not None:
            logging.info("Calculating position level current theoretical value")
            participant = match.group(1)
            account = match.group(2)
            position_id = match.group(3)

            positions = self.find_positions(participant, account, position_id)
            return self.calculate_current_value(positions)

        match = self.stressed_value_pattern.search(str(value))
        if match is not None:
            logging.info("Calculating account level stressed value")
            participant = match.group(1)
            account = match.group(2)
            scenario = match.group(3)

            positions = self.find_positions(participant, account)
            return self.calculate_stressed_value(positions, scenario)

        match = self.current_value_pattern.search(str(value))
        if match is not None:
            logging.info("Calculating account level current theoretical value")
            participant = match.group(1)
            account = match.group(2)

            positions = self.find_positions(participant, account)
            return self.calculate_current_value(positions)

        return value

    @staticmethod
    def find_positions(participant, account, position_id=None):
        query = DataQuery("Position")
        query.add_filter("participant", Operator.EQUAL, participant)
        query.add_filter("account", Operator.EQUAL, account)
        query.add_filter("level", Operator.EQUAL, "ACCOUNT")
        if position_id is not None:
            query.add_filter("positionId", Operator.EQUAL, position_id)

        responses, error_message = InterfaceManager().query_data(BLUESHIFT_API, query)
        assert error_message is None, f"Unable to fetch positions for participant [{participant}] and " \
                                      f"Account [{account}]. Error : [{error_message}]"
        return responses

    def calculate_stressed_value(self, positions, scenario_id=None):
        stressed_value = 0.0
        for position in positions:
            stressed_value = stressed_value + self.calculate_value(position, scenario_id)

        logging.info(f"Stressed value Results: [{stressed_value}]")
        return round(stressed_value, system_config.get("no_of_decimal_places"))

    def calculate_current_value(self, positions):
        current_value = 0.0
        for position in positions:
            current_value = current_value + self.calculate_value(position)

        logging.debug(f"Current Value Results : [{current_value}]")
        return round(current_value, system_config.get("no_of_decimal_places"))

    @staticmethod
    def tenor_comparator(tenor):
        last_char = tenor[-1]
        multiplier = 0
        if last_char == 'D':
            multiplier = 1
        elif last_char == 'M':
            multiplier = 30
        elif last_char == 'Y':
            multiplier = 365
        return int(tenor[0:-1]) * multiplier

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

        spot_rates = {k[0]: v for k, v in sorted(spot_rates.items(), key=lambda item: self.tenor_comparator(item[0][0]))}
        logging.info(spot_rates)

        if bond_obj.instrument_type == "ZERO_COUPON_BOND":
            clean_price = get_zero_coupon_clean_price(datetime.today().strftime('%Y-%m-%d'), bond_obj, spot_rates)
        else:
            clean_price = get_clean_price(datetime.today().strftime('%Y-%m-%d'), bond_obj, spot_rates)
        print(f"Clean Price : {clean_price}")
        return clean_price * net_position

    def adjust_spot_rates(self, spot_rates, scenario_id):
        logging.info(f"adjust_spot_rates:before:{str(spot_rates)}")
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

            if risk_factor_type != "Interest Rate":
                logging.info(f"Ignoring unsupported risk factor type [{risk_factor_type}]")
                continue

            for (tenor, symbol), rate in spot_rates.items():
                if symbol != shift_symbol:
                    continue

                logging.debug(f"Applicable shift found for symbol [{symbol}]. Shift type [{shift_type}]")
                value = rate
                if shift_type == "Absolute":
                    value = rate + shift_percentage/100
                elif shift_type == "Relative":
                    value = rate + (rate * shift_percentage / 100)
                else:
                    assert False, f"Unknown shift type [{shift_type}]"

                spot_rates[(tenor, symbol)] = value
        logging.info(f"adjust_spot_rates:after:{str(spot_rates)}")
        return spot_rates

    def create_bond_instrument(self, instrument_msg):
        bond = Instrument()
        bond.instrument_type = instrument_msg.get_field_value("Instrument Type")

        bond.issue_date = instrument_msg.get_field_value("Issue Date")
        bond.maturity_date = instrument_msg.get_field_value("Expiry Date")
        bond.business_day_convention = Instrument.BusinessDayConvention[
            self.to_upper(instrument_msg.get_field_value("Business Day Convention"))]
        bond.day_count_convention = Instrument.DayCountConvention[
            self.to_upper(instrument_msg.get_field_value("Day Count Convention"))]
        bond.face_value = instrument_msg.get_field_value("Par Value")

        if bond.instrument_type != "Zero Coupon Bond":
            bond.first_coupon_date = instrument_msg.get_field_value("First Coupon Date")
            bond.next_to_last_date = instrument_msg.get_field_value("Next To Last Date")
            bond.coupon_frequency = Instrument.CouponFrequency[
                self.to_upper(instrument_msg.get_field_value("Coupon Frequency"))]
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
