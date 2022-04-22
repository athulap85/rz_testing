import logging


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
        interface = self.interfaces.get(interface_id)
        assert interface is not None, f"submit_request:Interface {interface_id} is not registered in InterfaceManager"
        return interface.submit_request(request_message)

    def query_data(self, interface_id, query):
        interface = self.interfaces.get(interface_id)
        assert interface is not None, f"query_data:Interface {interface_id} is not registered in InterfaceManager"
        return interface.query_data(query)
