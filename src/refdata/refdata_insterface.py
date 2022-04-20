import logging
from src.refdata.refdata_config import entity_key_filed_map

from abc import ABC, abstractmethod


class IRefDataInterface(ABC):

    def init(self):
        logging.info("IRefDataInterface::inti")

    def get_key_field(self, entity):
        key_field =  entity_key_filed_map.get(entity)
        assert key_field is not None, 'No matching entity("' + entity + '") ' \
            'found in entity_key_filed_map in utils/refdata_config.py file'
        return key_field

    @abstractmethod
    def fetch_instance(self, query):
        pass

    @abstractmethod
    def update_instance(self, original_instance_msg, changes_msg):
        pass

    @abstractmethod
    def copy_instance(self, original_instance_msg, changes_msg):
        pass

    @abstractmethod
    def create_instance(self, message):
        pass

    @abstractmethod
    def delete_instance(self, entity, instance_key):
        pass