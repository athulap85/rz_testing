from src.transaction_data.ITransactionDataInterface import ITransactionDataInterface
from src.interfaces.webservices import HTTPClient
from src.interfaces.websockets import WebSocketClient
import logging
import json
import re
from src.transaction_data.transaction_data_config import message_to_endpoint_mapping
from src.utils.messaging import Message
from src.blueshift.reference_data_loader import DataLoader
from configs.global_config import system_config


class TransactionDataAdaptor(ITransactionDataInterface):

    def __init__(self):
        logging.info("inti")
        self.http_client = HTTPClient(system_config.get("base_url"))
        self.ws_client = WebSocketClient(system_config.get("wss_url"))
        self.ws_client.init(system_config.get("user_name"), system_config.get("password"),
                            system_config.get("client_id"))


        self.float_pattern = re.compile(r"^([+-]?[0-9]+\.[0-9]+)$")

    def submit_request(self, request_message):
        logging.debug(f"submit_request")
        endpoint = message_to_endpoint_mapping.get(request_message.definition)
        assert endpoint is not None, f"No mappings found for message [{request_message.definition}] " \
                                     f"in 'src/transaction_data/transaction_data.config.py'"
        request = self.create_request_msg(request_message)

        status_code, response = self.http_client.post_request(endpoint, request)
        if status_code == 200:
            if response == "":
                response = "{}"
            elif request_message.definition == "Realtime Risk Factor Update":
                response = f'{{"id": "{response}" }}'

            response_json = json.loads(response)
            return self.create_response_msg(request_message.definition, response_json), None
        else:
            return None, response

    def query_data(self, query):
        logging.info(f"Query Message: {str(query)}")
        entity = query.entity
        endpoint = message_to_endpoint_mapping.get(entity)
        assert endpoint is not None, f"Unable to find endpoint mapping for [{entity}] " \
                                     f"in the src/blueshift/transaction_data_config.py"
        if entity == "Position":
            return self.process_ws_position_query(endpoint, query)
        elif entity == "Position History":
            return self.process_ws_position_history_query(endpoint, query)
        elif entity == "Realtime Risk Factor Value":
            return self.process_ws_risk_factor_values_query(endpoint, query)
        elif entity == "Realtime Risk Factor Update":
            return self.process_ws_risk_factor_update_query(endpoint, query)
        elif entity == "Hedge Efficiency":
            return self.process_hedge_efficiency(endpoint, query)
        elif entity == "Realtime Interest Curve Value":
            return self.process_interest_curve(endpoint, query)
        elif entity == "Stress Test Result":
            return self.process_stress_test_results(endpoint, query)
        elif entity == "Stress Test Detailed Result":
            return self.process_stress_test_detailed_results(endpoint, query)
        elif entity == "Position Update Error":
            return self.process_position_update_errors(endpoint, query)
        elif entity == "Realtime Risk Factor Update Error":
            return self.process_realtime_risk_factor_update_errors(endpoint, query)
        else:
            assert False, f"Unhandled query type: {query.entity} in src/transaction_data/transaction_data_adaptor.py"

    def process_ws_position_query(self, endpoint, query):
        logging.debug(f"process_ws_position_query")

        filters = query.get_filters()
        level = account = None
        for filterItem in filters:
            if filterItem.field == "level":
                level = filterItem.value
            elif filterItem.field == "account":
                account = filterItem.value

        assert level is not None, "Field [level] must to be present as a filter criteria for Position query"
        assert account is not None, "Field [account] must to be present as a filter criteria for Position query"

        subscription = {"userId": "zb-admin",
                        "correlationId": "57d53f80-2511-4327-8ace-8ff25b4d65e0",
                        "wsAction": "SUBSCRIPTION",
                        "service": "positionapi",
                        "componentSubscription": {
                            "componentId": 8,
                            "filterData":
                                {"searchCriteria": []},
                            "beFilterParamsMap": {
                                "ACCOUNT": [
                                    account
                                ]
                            }
                        },
                        "page": 0,
                        "elementsInPage": 100}

        response = self.ws_client.query_data(subscription)
        response_json = json.loads(response)
        content = response_json["data"]["content"]
        for msg in content:
            msg["level"] = level

        msg_array = self.create_response_array(query, content)
        return msg_array, None

    def process_ws_position_history_query(self, endpoint, query):
        logging.debug(f"process_ws_position_history_query")

        pos_id = None
        filters = query.get_filters()
        for filter_item in filters:
            if filter_item.field == "positionId":
                pos_id = filter_item.value

        assert pos_id is not None, "Field [positionId] must to be present as a filter criteria for position " \
                                   "history query"

        subscription = {
           "userId": "zb-admin",
           "correlationId": "00365d0f-ef55-4450-999f-375c0e81b1fc",
           "wsAction": "UN_SUBSCRIPTION_THEN_SUBSCRIPTION",
           "service": "positionapi",
           "page": 0,
           "elementsInPage": 100,
           "componentSubscription": {
              "componentId": 9,
              "filterData": {
                 "searchCriteria": [
                    {
                       "columnName": "positionId",
                       "filterType": "String",
                       "stringValues": [
                          pos_id
                       ]
                    }
                 ]
              }
           },
           "componentUnSubscription": {
              "componentId": 9
           }
        }

        response = self.ws_client.query_data(subscription)
        response_json = json.loads(response)
        content = response_json["data"]["content"]

        msg_array = self.create_response_array(query, content)
        return msg_array, None

    def process_ws_risk_factor_values_query(self, endpoint, query):
        logging.debug(f"process_ws_risk_factor_values_query")

        symbol = None
        filters = query.get_filters()
        for filter_item in filters:
            if filter_item.field == "symbol":
                symbol = filter_item.value

        assert symbol is not None, "Field [symbol] must to be present as a filter criteria for Risk Factor Values query"

        subscription = {
                "userId": "zb-admin",
                "correlationId": "da0ef77c-2ab1-44ff-958e-41386ad146e4",
                "wsAction": "SUBSCRIPTION",
                "service": "marketdataapi",
                "componentSubscription": {
                    "componentId": 4,
                    "filterData": {
                        "searchCriteria": [
                            {
                                "columnName": "symbol",
                                "filterType": "String",
                                "stringValues": [
                                    symbol
                                ]
                            }
                        ]
                    }
                },
                "page": 0,
                "elementsInPage": 100
            }

        response = self.ws_client.query_data(subscription)
        response_json = json.loads(response)
        content = response_json["data"]["content"]

        msg_array = self.create_response_array(query, content)
        return msg_array, None

    def process_ws_risk_factor_update_query(self, endpoint, query):
        logging.debug(f"process_ws_risk_factor_update_query")

        subscription = {
                "userId": "zb-admin",
                "correlationId": "f5b487b7-02c6-497d-838b-f88b3d42eaf7",
                "wsAction": "SUBSCRIPTION",
                "service": "marketdataapi",
                "componentSubscription": {
                    "componentId": 1,
                    "filterData": {
                        "searchCriteria": []
                    }
                },
                "page": 0,
                "elementsInPage": 100
            }

        response = self.ws_client.query_data(subscription)
        response_json = json.loads(response)
        content = response_json["data"]["content"]

        msg_array = self.create_response_array(query, content)
        return msg_array, None

    def process_risk_factor_values_query(self, endpoint, query):
        logging.debug(f"process_risk_factor_values_query")
        symbol = None
        filters = query.get_filters()
        for filter_item in filters:
            if filter_item.field == "symbol":
                symbol = filter_item.value

        url = f"{endpoint}"
        status_code, response = self.http_client.get_request(f"{url}/{symbol}")
        if status_code == 200:
            response_json = json.loads(response)
            msg_array = self.create_response_array(query, response_json)

            return msg_array, None
        else:
            return None, response

    def process_position_query(self, endpoint, query):
        logging.debug(f"process_position_query")
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

        url = url + "&userName=zb-admin"
        status_code, response = self.http_client.post_request(url, None)
        if status_code == 200:
            response_json = json.loads(response)

            for msg in response_json["content"]:
                msg["level"] = level

            msg_array = self.create_response_array(query, response_json["content"])

            return msg_array, None
        else:
            return None, response

    def process_hedge_efficiency(self, endpoint, query):
        logging.debug(f"process_hedge_efficiency")
        account = symbol = None
        filters = query.get_filters()
        for filter_item in filters:
            if filter_item.field == "symbol":
                symbol = filter_item.value
            elif filter_item.field == "account":
                account = filter_item.value

        assert account is not None, "Field [account] must to be present as a filter criteria for Hedge Efficiency query"

        url = f"{endpoint}?accountId={account}"
        status_code, response = self.http_client.get_request(url)
        if status_code == 200:
            response_json = json.loads(response)
            updated_response = self.reformat_hedge_efficiency_response(account, response_json)
            msg_array = self.create_response_array(query, updated_response)

            return msg_array, None
        else:
            return None, response

    def reformat_hedge_efficiency_response(self, account, response):
        logging.debug(f"reformat_hedge_efficiency_response")
        output = []
        for time, value in response.items():
            for symbol, hedge_value in value.items():
                output.append({"time": time, "account": account, "symbol": symbol, "hedgeEfficiency": hedge_value})
        return output

    def create_request_msg(self, message):
        logging.debug(f"create_request_msg: Message : {message.definition}")
        if message.definition == "Stress Test":
            received_value = message.get_field_value("account")
            assert received_value is not None, "Field [account] must to be present for Stress Test request"
            values = received_value.split(",")
            return values
        else:
            return message.fieldValues

    def create_response_msg(self, message_name, response):
        logging.debug(f"create_response_msg")
        msg = Message(message_name)
        msg.set_fields_values(response)
        return msg

    def create_response_array(self, query, response_array):
        logging.debug(f"create_response_array")
        message_name = query.entity
        output_array = []
        for item in response_array:
            for key, value in item.items():
                match = self.float_pattern.search(str(value))
                if match is not None:
                    float_number = float(match.group(1))
                    item[key] = round(float_number, system_config.get("no_of_decimal_places"))

            mismatch_found = False
            filters = query.get_filters()
            for filter_item in filters:
                received_value = str(item.get(filter_item.field))
                assert received_value is not None, f"Field [{filter_item.field}] is not available in the response message"
                if received_value != str(filter_item.value):
                    mismatch_found = True
                    logging.info(f"Ignoring the message. Mismatched field [{filter_item.field}] :"
                                 f" Expected[{filter_item.value}] Received[{received_value}]")
                    break

            if mismatch_found:
                continue

            msg = Message(message_name)

            msg.set_fields_values(item)
            output_array.append(msg)

        return output_array

    def process_interest_curve(self, endpoint, query):
        logging.debug(f"process_interest_curve")
        curve_identifier = None
        filters = query.get_filters()
        for filter_item in filters:
            if filter_item.field == "curveIdentifier":
                curve_identifier = filter_item.value

        assert curve_identifier is not None, "Field [curveIdentifier] must to be present as a filter criteria for" \
                                             " Realtime Interest Curve Value query"

        endpoint = f"{endpoint}?curveId={curve_identifier}"
        status_code, response = self.http_client.get_request(endpoint)
        if status_code == 200:
            response_json = json.loads(response)
            updated_response = []
            for item in response_json.values():
                updated_response.extend(item)

            msg_array = self.create_response_array(query, updated_response)
            return msg_array, None
        else:
            return None, response

    def process_stress_test_results(self, endpoint, query):
        logging.debug(f"process_stress_test_results")
        run_id = None
        filters = query.get_filters()
        for filter_item in filters:
            if filter_item.field == "runId":
                run_id = filter_item.value

        assert run_id is not None, "Field [runId] must to be present as a filter criteria for stress test results query"

        url = f"{endpoint}?runId={run_id}"
        status_code, response = self.http_client.get_request(url)
        if status_code == 200:
            response_json = json.loads(response)
            for results in response_json:
                results["runId"] = run_id

            msg_array = self.create_response_array(query, response_json)
            return msg_array, None
        else:
            return None, response

    def process_stress_test_detailed_results(self, endpoint, query):
        logging.debug(f"process_stress_test_detailed_results")
        run_id = acc_id = scenario_id = None
        filters = query.get_filters()
        for filter_item in filters:
            if filter_item.field == "runId":
                run_id = filter_item.value
            elif filter_item.field == "accountId":
                acc_id = filter_item.value
            elif filter_item.field == "scenarioId":
                scenario_id = filter_item.value

        assert None not in (run_id, acc_id, scenario_id), "Field [runId,accountId,scenarioId] must to be present" \
                                                          " as a filter criteria for stress test results query"

        url = f"{endpoint}?runId={run_id}&accountId={acc_id}&scenarioId={scenario_id}&page=0&userName=zb-admin"
        body = {"searchCriteria": []}
        status_code, response = self.http_client.post_request(url, body)
        if status_code == 200:
            response_json = json.loads(response)
            msg_array = self.create_response_array(query, response_json["content"])
            return msg_array, None
        else:
            return None, response

    def process_risk_factor_update_query(self, endpoint, query):
        logging.debug(f"process_risk_factor_update_query")
        url = f"{endpoint}"
        status_code, response = self.http_client.get_request(url)
        if status_code == 200:
            response_json = json.loads(response)

            msg_array = self.create_response_array(query, response_json["content"])
            return msg_array, None
        else:
            return None, response

    def process_position_history_query(self, endpoint, query):
        logging.debug(f"process_position_history_query")
        pos_id = None
        filters = query.get_filters()
        for filter_item in filters:
            if filter_item.field == "positionId":
                pos_id = filter_item.value

        assert pos_id is not None, "Field [positionId] must to be present as a filter criteria for position " \
                                   "history query"

        url = f"{endpoint}?id={pos_id}&userName=zb-admin"
        status_code, response = self.http_client.post_request(url, None)
        if status_code == 200:
            response_json = json.loads(response)

            msg_array = self.create_response_array(query, response_json["content"])
            return msg_array, None
        else:
            return None, response

    def process_position_update_errors(self, endpoint, query):
        logging.debug(f"process_position_update_errors")
        external_id = None
        filters = query.get_filters()
        for filter_item in filters:
            if filter_item.field == "externalId":
                external_id = filter_item.value

        assert external_id is not None, "Field [externalId] must to be present as a filter criteria for " \
                                        "position update errors query"

        url = f"{endpoint}/{external_id}/errors"
        status_code, response = self.http_client.get_request(url)
        if status_code == 200:
            response_json = json.loads(response)

            msg_array = self.create_response_array(query, response_json)
            return msg_array, None
        else:
            return None, response

    def process_realtime_risk_factor_update_errors(self, endpoint, query):
        logging.debug(f"process_realtime_risk_factor_update_errors")
        external_id = None
        filters = query.get_filters()
        for filter_item in filters:
            if filter_item.field == "externalId":
                external_id = filter_item.value

        assert external_id is not None, "Field [externalId] must to be present as a filter criteria for " \
                                        "realtime risk factor update errors query"

        url = f"{endpoint}/{external_id}/errors"
        status_code, response = self.http_client.get_request(url)
        if status_code == 200:
            response_json = json.loads(response)

            msg_array = self.create_response_array(query, response_json)
            return msg_array, None
        else:
            return None, response
