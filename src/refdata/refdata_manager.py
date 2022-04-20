import logging
from src.utils.messaging import DataQuery, Operator


class RefDataManager:
    instance = None
    interface = None
    reversal_msgs = {}

    def __new__(cls):
        if cls.instance is None:
            cls.instance = super(RefDataManager, cls).__new__(cls)
            cls.interface = None
        return cls.instance

    def init(self, interface):
        logging.info("Initialize refdata manager")
        self.interface = interface
        self.interface.init()

    def create_instance(self, msg):
        logging.debug("Create instance")
        response_msg, error_msg = self.interface.create_instance(msg)
        return response_msg, error_msg

    def get_instance(self, entity, instance_key):
        logging.debug("Get instance")

        response_msg, error_msg = self.interface.fetch_instance(entity, instance_key)
        if error_msg is None:
            logging.info(f"Fetched Instance Message : \n {response_msg.to_string()}")
        return response_msg, error_msg

    def update_instance(self, entity, instance_key, msg):
        logging.debug("Update instance")
        fetched_instance, error_msg = self.get_instance(entity, instance_key)
        self.validate_change_request(fetched_instance, msg)
        response_msg, error_msg = self.interface.update_instance(fetched_instance, msg)
        return response_msg, error_msg

    def copy_instance(self, entity, instance_key, msg):
        logging.debug("Copy instance")
        fetched_instance, error_msg = self.get_instance(entity, instance_key)
        self.validate_change_request(fetched_instance, msg)
        response_msg, error_msg = self.interface.copy_instance(fetched_instance, msg)
        return response_msg, error_msg

    def delete_instance(self, entity, instance_key):
        logging.debug("Delete instance")
        response_msg, error_msg = self.interface.delete_instance(entity, instance_key)
        return response_msg, error_msg

    def on_feature_start(self):
        logging.debug("On feature start")

    def on_feature_complete(self):
        logging.debug("On feature complete")
        for key, value in self.reversal_msgs.items():
            logging.debug(key + '->' + value)
        self.reversal_msgs.clear()

    def validate_change_request(self, original_msg, changes_msg):
        actual_field_list = original_msg.get_fields_list()
        requesting_field_list = changes_msg.get_fields_list()
        for field_name in requesting_field_list:
            assert field_name in actual_field_list, f"Expected field [{field_name}] is not" \
                                                    f" available in entity [{original_msg.definition}]"





