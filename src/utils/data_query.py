from enum import Enum


class Operator(Enum):
    EQUAL = "eq"
    GREATER_THAN = "gt"
    LESS_THAN = "lt"


class Filter:

    def __init__(self, field, operator, value):
        self.field = field
        self.operator = operator
        self.value = value

    def __str__(self):
        return f"{self.field} {self.operator} {self.value}"


class DataQuery:

    def __init__(self, entity):
        self.entity = entity
        self.filters = []
        self.expected_msg_count = 0

    def add_filter(self, field, operator, value):
        if not isinstance(operator, Operator):
            raise TypeError('operator must be an instance of Operator Enum')
        self.filters.append(Filter(field, operator, value))

    def get_filters(self):
        return self.filters

    def set_expected_msg_count(self, count):
        self.expected_msg_count = count

    def get_expected_msg_count(self):
        return self.expected_msg_count

    def __str__(self):
        value = "\nDataQuery{\n"
        value += f"\tEntity : {self.entity}\n"
        value += "\tFilters : {\n"
        for item in self.filters:
            value += "\t\t" + str(item) + "\n"
        value += "\t}\n"
        value += "}\n"
        return value

