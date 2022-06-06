import logging
import time

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
        retry_count = 20
        for x in range(retry_count):
            logging.info(f"Querying for data[attempt {x + 1}/{retry_count}]")
            msg_array, error = interface.query_data(query)

            if msg_array is None or len(msg_array) != query.get_expected_msg_count():
                time.sleep(1)
            else:
                break

        return msg_array, error



