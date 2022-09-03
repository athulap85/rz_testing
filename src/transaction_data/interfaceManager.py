import logging
import time
from configs.global_config import system_config


class InterfaceManager:
    instance = None
    interfaces = {}

    def __new__(cls):
        if cls.instance is None:
            cls.instance = super(InterfaceManager, cls).__new__(cls)
        return cls.instance

    def register_interface(self, interface_id, interface):
        if self.interfaces.get(interface_id) is None:
            self.interfaces[interface_id] = interface
        else:
            assert False, f"Interface {interface_id} is already registered in InterfaceManager"

    def submit_request(self, interface_id, request_message):
        logging.debug(f"submit_request: interface_id : [{interface_id}]")
        interface = self.interfaces.get(interface_id)
        assert interface is not None, f"submit_request:Interface {interface_id} is not registered in InterfaceManager"
        return interface.submit_request(request_message)

    def query_data(self, interface_id, query):
        logging.debug(f"query_data: interface_id : [{interface_id}]")
        interface = self.interfaces.get(interface_id)
        assert interface is not None, f"query_data:Interface {interface_id} is not registered in InterfaceManager"

        msg_array = error = None
        retry_count = system_config.get("retry_count")
        for x in range(retry_count):
            logging.info(f"Querying for data[attempt {x + 1}/{retry_count}]")
            msg_array, error = interface.query_data(query)

            expected_count = query.get_expected_msg_count()
            if msg_array is None:
                logging.info("query_data:Empty results received.")
                time.sleep(1)
            elif expected_count != 0 and len(msg_array) < expected_count:
                logging.info(f"query_data:Expected message count mismatch. Received:[{len(msg_array)}] "
                             f"Expected:[{query.get_expected_msg_count()}]")
                time.sleep(1)
            else:
                break

        return msg_array, error



