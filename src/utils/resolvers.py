import logging
import re
from src.utils.instance_registry import InstanceRegistry
from random import randint
from datetime import datetime
from dateutil.relativedelta import relativedelta

class ResolverChain:
    instance = None
    resolver = None

    def __new__(cls):
        if cls.instance is None:
            cls.instance = super(ResolverChain, cls).__new__(cls)
            cls.build_chain(cls)
        return cls.instance

    def build_chain(self):
        self.resolver = InstanceResolver(DateTimeResolver(StringResolver(None)))

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
        self.clean_price_pattern = re.compile(r"get_clean_price\((.+)\)")

    def process(self, value):
        match = self.date_pattern.search(str(value))

        if match is not None:
            instance_key = match.group(1)
            instrument_msg = InstanceRegistry().get_instance(instance_key)
            assert instrument_msg.definition == "Instrument", "Argument of the get_clean_price" \
                                                              " should be an Instrument instance"

        return value
