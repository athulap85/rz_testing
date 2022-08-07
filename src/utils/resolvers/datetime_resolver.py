from datetime import datetime
from dateutil.relativedelta import relativedelta
from src.utils.resolvers.resolver import Resolver
import re


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
