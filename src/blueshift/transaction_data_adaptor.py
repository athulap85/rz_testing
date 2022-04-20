from src.transaction_data.ITransactionDataInterface import ITransactionDataInterface
from interfaces.webservices import HTTPClient
import logging
import json
from src.transaction_data.transaction_data_config import message_to_endpoint_mapping
from src.utils.messaging import Message
from src.blueshift.reference_data_loader import DataLoader

BASE_URL = "https://dev.blueshiftrp.xyz/v1/"


class TransactionDataAdaptor(ITransactionDataInterface):

    def __init__(self):
        logging.info("inti")
        self.http_client = HTTPClient(BASE_URL)

    def submit_request(self, request_message):
        endpoint = message_to_endpoint_mapping.get(request_message.definition)
        assert endpoint is not None, f"No mappings found for message [{request_message.definition}] " \
                                     f"in 'src/transaction_data/transaction_data.config.py'"
        request = self.create_request_msg(request_message)

        status_code, response = self.http_client.post_request(endpoint, request)
        if status_code == 200:
            if response == "":
                response = "{}"
            response_json = json.loads(response)
            return self.create_response_msg(request_message.definition, response_json), None
        else:
            return None, response

    def query_data(self, query):
        logging.info(f"Query Message: {str(query)}")
        entity = query.entity
        if entity == "Position":
            return self.process_position_query(query)

    def process_position_query(self, query):
        endpoint = message_to_endpoint_mapping.get(query.entity)
        filters = query.get_filters()
        level = participant = account = None
        for filter in filters:
            if filter.field == "participant":
                participant = filter.value
            elif filter.field == "account":
                account = filter.value
            elif filter.field == "level":
                level = filter.value

        assert level is not None, "Field [level] must to be present as a filter criteria for Position query"

        if level == "SYSTEM":
            url = f"{endpoint}?level=SYSTEM"

        elif level == "PARTICIPANT":
            participant_instance_id = DataLoader().get_instance_id("Participants", participant)
            assert participant_instance_id is not None, \
                f"Unable to find the Instance Id. Entity : [Participants], Key : [{participant}]"
            url = f"{endpoint}?level=ACCOUNT&id={str(participant_instance_id)}"

        elif level == "ACCOUNT":
            assert participant is not None and account is not None, "Fields [participant] and [account] need to be" \
                " present as a filter criteria for Account level Position query"

            account_instance_id = DataLoader().get_acc_instance_id(participant, account)
            assert account_instance_id is not None, \
                f"Unable to find the Instance Id. Entity : [Accounts], Key : [{account}]"

            url = f"{endpoint}?level=ACCOUNT&id={str(account_instance_id)}"

        else:
            assert False, "Value of the 'level' field should be one of the following. [SYSTEM | PARTICIPANT | ACCOUNT]"

        status_code, response = self.http_client.get_request(url)
        if status_code == 200:
            response_json = json.loads(response)
            msg_array = self.create_response_array(query.entity, response_json["content"])
            for msg in msg_array:
                msg.set_field_value("level", level)
            return msg_array, None
        else:
            return None, response

    def create_request_msg(self, message):
        return message.fieldValues

    def create_response_msg(self, message_name, response):
        msg = Message(message_name)
        msg.set_fields_values(response)
        return msg

    def create_response_array(self, message_name, response_array):
        output_array = []
        for item in response_array:
            msg = Message(message_name)
            msg.set_fields_values(item)
            output_array.append(msg)

        return output_array

