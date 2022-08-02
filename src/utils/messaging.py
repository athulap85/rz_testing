import json
import logging
from src.utils.resolvers import ResolverChain
from src.utils.data_query import DataQuery, Operator


class Message:
    def __init__(self, definition):
        self.fieldValues = {}
        self.definition = definition
        self.instanceId = -1

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


def pack_row_to_message(message, header, row, callback):
    logging.debug(f"pack_row_to_message")
    instance_id = None
    for field in header:
        if field == "Instance ID":
            instance_id = row[field]
            message.instanceId = instance_id
            continue
        value = ResolverChain().resolve(row[field])
        message.set_field_value(field, value)
    assert instance_id is not None, 'Table should contain the "Instance ID" column'
    callback(instance_id, message)
    return message;


def pack_row_to_new_message(message_name, header, row, callback):
    logging.debug(f"pack_row_to_new_message - message_name[{message_name}]")
    msg = Message(message_name)
    return pack_row_to_message(msg, header, row, callback)


def pack_row_to_query(message_definition, header, row, filters):
    logging.debug(f"pack_row_to_query - message_definition[{message_definition}]")
    filter_list = filters.split(",")
    query = DataQuery(message_definition)
    for field in header:
        if field in filter_list:
            value = ResolverChain().resolve(row[field])
            query.add_filter(field, Operator.EQUAL, value)
    logging.debug(f"pack_row_to_query: Output : {str(query)}")
    return query;

