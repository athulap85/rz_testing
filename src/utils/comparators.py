import logging


def compare(expected_msg, received_msg, should_assert, callback):
    string_assert("Message Def", expected_msg.definition, received_msg.definition)
    failed = False
    for field_name in expected_msg.get_fields_list():
        assert received_msg.get_field_value(field_name) is not None, "Field '" + field_name +\
                                                                     "' is not available in actual message"
        if string_assert(field_name, expected_msg.get_field_value(field_name), received_msg.get_field_value(field_name),
                         should_assert) is False:
            failed = True

    if failed is True:
        return False

    callback(expected_msg.instanceId, received_msg)
    return True


def compare_message_arrays(expected_array, response_array, callback):
    # assert len(expected_array) == len(response_array), f"Expected and received messages count mismatch." \
    #    f" expected count[{len(expected_array)}] received count[{len(response_array)}]" \
    #    f" \nExpected : {print_msg_array(expected_array)} \nReceived : {print_msg_array(response_array)}\n"

    for expecting_msg in expected_array:
        found = False
        for response_msg in response_array:
            if compare(expecting_msg, response_msg, False, callback):
                found = True
                break

        if found is False:
            assert False, f"Expected message not received.\n" \
                      f"Expected : {str(expecting_msg)} \nReceived messages : {print_msg_array(response_array)}\n"


def print_msg_array(array):
    str1 = "{\n"
    for item in array:
        str1 += str(item)
    str1 += "}\n"
    return str1


def string_assert(field_name, expected, received, should_assert=True):
    logging.debug(f"string_assert checking [{field_name}] Expected:Received [{expected}]:[{received}]")
    if should_assert:
        assert string_equal(str(expected), str(received)), f"Field [{field_name}], Expected:Received [{expected}]:[{received}]"
    else:
        if string_equal(str(expected), str(received)):
            return True
        else:
            logging.info(f"Field [{field_name}], Expected:Received [{expected}]:[{received}]")
            return False


def string_equal(expected_value, received_value):

    if expected_value == received_value:
        return True
    elif expected_value == "NOT_EMPTY" and len(received_value) > 0:
        return True
    else:
        return False
