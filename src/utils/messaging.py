import json
import logging
from enum import Enum
from src.utils.resolvers import ResolverChain
from src.utils.instance_registry import InstanceRegistry


class Message:
    def __init__(self, definition):
        self.fieldValues = {}
        self.definition = definition

    def get_field_value(self, field_name):
        return self.fieldValues.get(field_name)

    def set_field_value(self, field_name, field_value):
        self.fieldValues[field_name] = field_value

    def get_fields_list(self):
        return self.fieldValues.keys()

    def set_fields_values(self, field_values):
        self.fieldValues = field_values

    def copy(self, message):
        for key, value in message.fieldValues.items():
            assert self.fieldValues.get(key) is not None, "Message Copy failed. Field '" + key +\
                "' not available in the destination message '" + + message.definition + "'"
            self.fieldValues[key] = value

    def get_fields_json(self):
        return json.dump(self.fieldValues)

    def __str__(self):
        return self.to_string()

    def to_string(self):
        msg_str = "{\n"
        msg_str += "\tDefinition : " + self.definition + "\n"
        msg_str += "\t{\n"
        for key, value in self.fieldValues.items():
            msg_str += "\t\t" + key + " = " + str(value) + "\n"
        msg_str += "\t}\n"
        msg_str += "}"
        return msg_str


def compare(expected_msg, received_msg, should_assert=True):
    string_assert(expected_msg.definition, received_msg.definition)

    for field_name in expected_msg.get_fields_list():
        assert received_msg.get_field_value(field_name) is not None, "Field '" + field_name +\
                                                                     "' is not available in actual message"
        if string_assert(expected_msg.get_field_value(field_name), received_msg.get_field_value(field_name),
                         should_assert) is False:
            return False

    return True


def pack_row_to_message(message, header, row):
    instance_id = None
    for field in header:
        if field == "Instance ID":
            instance_id = row[field]
            continue
        value = ResolverChain().resolve(row[field])
        message.set_field_value(field, value)
    assert instance_id is not None, 'Table should contain the "Instance ID" column'
    InstanceRegistry().register_instance(instance_id, message)
    return message;


def pack_row_to_new_message(message_name, header, row):
    msg = Message(message_name)
    return pack_row_to_message(msg, header, row)


def pack_row_to_query(message_definition, header, row, filters):
    filter_list = filters.split(",")
    query = DataQuery(message_definition)
    for field in header:
        if field in filter_list:
            query.add_filter(field, Operator.EQUAL, row[field])
    logging.debug(f"pack_row_to_query: Output : {str(query)}")
    return query;


def string_assert(expected, received, should_assert=True):
    logging.debug(f"string_assert Expected:Received [{expected}]:[{received}]")
    if should_assert:
        assert str(expected) == str(received), f"Expected:Received [{expected}]:[{received}]"
    else:
        if str(expected) == str(received):
            return True
        else:
            logging.info(f"Expected:Received [{expected}]:[{received}]")
            return False



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

    def add_filter(self, field, operator, value):
        if not isinstance(operator, Operator):
            raise TypeError('operator must be an instance of Operator Enum')
        self.filters.append(Filter(field, operator, value))

    def get_filters(self):
        return self.filters

    def __str__(self):
        value = "\nDataQuery{\n"
        value += f"\tEntity : {self.entity}\n"
        value += "\tFilters : {\n"
        for item in self.filters:
            value += "\t\t" + str(item) + "\n"
        value += "\t}\n"
        value += "}\n"
        return value

