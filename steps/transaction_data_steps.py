import logging

from behave import *
from src.transaction_data.interfaceManager import InterfaceManager
from src.utils.messaging import pack_row_to_message, pack_row_to_query, Message, pack_row_to_new_message
from src.utils.comparators import compare, compare_message_arrays
import json

response_messages = {}
BLUESHIFT_API = "BLUESHIFT_API"


@Given(u'"{template_name}" messages are submitted with following values')
def step_impl(context, template_name):
    process_request(context, template_name, False)


@When(u'"{template_name}" messages are submitted with following values')
def step_impl(context, template_name):
    process_request(context, template_name, True)


def process_request(context, entity, expect_response):
    try:
        template_name = entity.replace(" ", "_")
        f = open(f'configs/templates/{template_name}.json', 'r')
        json_message = json.load(f)
        f.close()
    except OSError:
        assert False, f"No matching template found for [{template_name}] in 'configs/templates/'"

    message_definition = json_message["messageName"]
    default_fields = json_message["fields"]
    message = Message(message_definition)
    message.set_fields_values(default_fields)

    for row in context.table:
        msg = pack_row_to_message(message, context.table.headings, row)
        instance_id = row["Instance ID"]
        logging.info(f"Transaction Msg : {msg.to_string()}")
        response_msg, error_message = InterfaceManager().submit_request(BLUESHIFT_API, msg)
        assert error_message is None, f"Submit request failed. Error [{error_message}]"
        if expect_response:
            response_messages[instance_id] = response_msg


@Then(u'response of the request "{instance_id}" should be')
def step_impl(context, instance_id):
    response_msg = response_messages.get(instance_id)
    logging.info(response_messages)
    assert response_msg is not None, f"No response available for request [{instance_id}]"
    expected_msg = pack_row_to_new_message(response_msg.definition, context.table.headings, context.table[0])
    logging.info(f"expecting msg {expected_msg.to_string()}")
    response_msg = response_messages.get(instance_id)
    compare(expected_msg, response_msg)


@Given(u'"{message_name}" messages are filtered by "{filters}" should be')
def step_impl(context, message_name, filters):
    query_msg(context, message_name, filters)


@Then(u'"{message_name}" messages are filtered by "{filters}" should be')
def step_impl(context, message_name, filters):
    query_msg(context, message_name, filters)


def query_msg(context, message_name, filters):
    results_map = extract_queries_and_expected_messages(message_name, context.table, filters)
    for query, expecting_msg_array in results_map.items():
        query.set_expected_msg_count(len(expecting_msg_array))
        responses, error_message = InterfaceManager().query_data(BLUESHIFT_API, query)
        assert error_message is None, f"Error occurred when querying the data. error: [{error_message}]"
        compare_message_arrays(expecting_msg_array, responses)


def extract_queries_and_expected_messages(message_name, table, filters):
    filter_list = filters.split(",")
    query_objects = {}
    expected_msgs_by_query_obj = {}
    for row in table:
        key_str = ""
        for field in filter_list:
            value = row.get(field)
            assert value is not None, f"Filter field [{field}] not available in table"
            key_str += value + ":"
        logging.debug(f"Key str : {key_str}")

        expected_msg = pack_row_to_new_message(message_name, table.headings, row)

        if key_str not in query_objects:
            query = pack_row_to_query(message_name, table.headings, row, filters)
            query_objects[key_str] = query
            expected_msgs_by_query_obj[query] = [expected_msg]
        else:
            expected_msgs_by_query_obj[query_objects[key_str]].append(expected_msg)

    logging.info(f"Output map {str(expected_msgs_by_query_obj)}")
    return expected_msgs_by_query_obj
