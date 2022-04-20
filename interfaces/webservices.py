import requests
from requests.exceptions import HTTPError
from interfaces.interface import *
from interfaces.mapping.inbound_mapping import *
import logging
ENDPOINT = "http://127.0.0.1:8081"
from json.decoder import JSONDecodeError


class HTTPClient(IInterface):

    def __init__(self, base_url):
        self.base_url = base_url

    def get_request(self, sub_url):
        try:
            request_url = self.base_url + sub_url
            self.print_request("GET", request_url, "")
            response = requests.get(request_url)
            self.print_response("GET", str(response.status_code), response.text)
            return response.status_code, response.text

        except Exception as err:
            assert False, f"Error {err}"

    def post_request(self, sub_url, request_body):
        try:
            request_url = self.base_url + sub_url
            self.print_request("POST", request_url, request_body)
            response = requests.post(request_url, json=request_body)
            self.print_response("POST", str(response.status_code), response.text)
            return response.status_code, response.text

        except Exception as err:
            assert False, f"Error {err}"

    def put_request(self, sub_url, request_body):
        try:
            request_url = self.base_url + sub_url
            self.print_request("PUT", request_url, request_body)

            response = requests.put(request_url, json=request_body)
            self.print_response("PUT", str(response.status_code), response.text)
            return response.status_code, response.text

        except Exception as err:
            assert False, f"Error {err}"

    def delete_request(self, sub_url):
        try:
            request_url = self.base_url + sub_url
            self.print_request("DELETE", request_url, "")

            response = requests.delete(request_url)
            self.print_response("DELETE", str(response.status_code), response.text)
            return response.status_code, response.text

        except Exception as err:
            assert False, f"Error {err}"

    def print_request(self, request_type, url, request_body):
        request_json = json.dumps(request_body, indent=4)
        logging.info(f"============= {request_type} - REQUEST =============")
        logging.info(f"URL          : {url}")
        logging.info(f"Request Body : \n{request_json}\n")
        logging.info(f"============================================")

    def print_response(self, request_type, status_code, response_body):

        try:
            response_temp = json.loads(response_body)
            response_json = json.dumps(response_temp, indent=4)
        except JSONDecodeError as e:
            response_json = response_body

        logging.info(f"============= {request_type} - RESPONSE =============")
        logging.info(f"Status Code   : {status_code}")
        logging.info(f"Response Body : \n{response_json}\n")
        logging.info(f"============================================")

    def request(self, message):
        json_message = json.dumps(message.fieldValues, indent=4)
        logging.debug(json_message)
        try:
            response = requests.post(ENDPOINT + "/trades/", json=json.loads(json_message))
            logging.debug(response)
            return True
        except requests.exceptions.RequestException as e:
            logging.error('%s', e)
            return False

    def query(self, message):
        try:
            response = requests.get(ENDPOINT + "/trades/" + message.get_field_value("Trade ID"))
            logging.debug("response: " + response.text)
            response_msg = InboundMapping.get_message(response)
            return True, response_msg
        except requests.exceptions.RequestException as e:
            logging.error('%s', e)
            return False, None


