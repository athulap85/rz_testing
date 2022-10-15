import logging

from src.interfaces.webservices import HTTPClient
import json
from os.path import exists
from configs.global_config import system_config

REFDATA_ENDPOINT = system_config.get("base_url") + "reference-data-api"
REFDATA_CACHE_LOCATION = 'cache/blueshift/'


class DataLoader:

    instance = None
    entity_definitions = {}
    ref_data_instances = {}
    accounts_structure = {}
    table_entitiy_details = {}

    def __new__(cls):
        if cls.instance is None:
            cls.instance = super(DataLoader, cls).__new__(cls)
            cls.http_client = HTTPClient(REFDATA_ENDPOINT)
            cls.loader_logger = logging.getLogger('loader')
        return cls.instance

    def load_instances(self, entity_definitions):
        self.entity_definitions = entity_definitions
        for entity_def in self.entity_definitions.values():
            endpoint = entity_def.get_property("endpoint")
            self.loader_logger.info(f'DataLoader::load_instances - endpoint : ===== {endpoint} ======')
            self.load(entity_def, endpoint)

    def load(self, entity_definition, entity_endpoint):
        entity_name = entity_definition.name
        if entity_name == "Coupon Schedules" or entity_name == "Sink Schedule":
            self.loader_logger.info(f'DataLoader::load Ignoring the entity')
            return

        cache_file = f"{REFDATA_CACHE_LOCATION}{entity_endpoint}.json"
        if exists(cache_file):
            self.loader_logger.info(f'DataLoader::load - Using cache')
        else:
            self.loader_logger.info(f'DataLoader::load - No cache available')

            page = 0
            instance_list = []
            while True:
                url = f"/{entity_endpoint}-search?page={page}&userName=zb-admin"
                status_code, response = self.http_client.post_request(url, {})
                if status_code != 200:
                    print("Data loading failed for entity : " + entity_definition.name)
                    return
                self.loader_logger.info(f"URL : {url}")
                # self.loader_logger.info(f'DataLoader::load - API Response : \n {response}')
                response_json = json.loads(response)

                if len(response_json["content"]) == 0:
                    break
                else:
                    instance_list.extend(response_json["content"])
                page = page + 1

            json_object = json.dumps(instance_list, indent=4)
            f = open(cache_file, "w")
            f.write(json_object)
            f.close()

        f = open(cache_file, "r")
        json_output = json.loads(f.read())
        f.close()

        instance_id_map = {}
        for instance in json_output:
            instance_id = instance["id"]
            field_def = entity_definition.find_field_def_by_display_name(entity_definition.key_field)
            key_name = field_def.get_property("name")
            key_value = instance[key_name]
            self.loader_logger.info(f'DataLoader::load - instance_id : [{instance_id}],  key : [{key_value}]')
            instance_id_map[key_value] = instance_id
            if entity_name == "Accounts":
                participant_name = instance["participant"]["name"]
                self.set_acc_instance_id(participant_name, key_value, instance_id)

        self.ref_data_instances[entity_name] = instance_id_map

    def get_instance_id(self, entity, key_field_value):
        logging.debug(f"get_instance_id: entity[{entity}], key_field_value[{key_field_value}]")
        return self.ref_data_instances[entity].get(key_field_value)

    def set_instance_id(self, entity, key_field_value, instance_id):
        logging.debug(f"set_instance_id: entity[{entity}], key_field_value[{key_field_value}],"
                      f" instance_id[{instance_id}]")
        self.ref_data_instances[entity][key_field_value] = instance_id

    def remove_instance_id(self, entity, key_field_value):
        logging.debug(f"remove_instance_id: entity[{entity}], key_field_value[{key_field_value}]")
        self.ref_data_instances[entity].pop(key_field_value, None)

    def get_acc_instance_id(self, participant, account):
        logging.debug(f"get_acc_instance_id: participant_name[{participant}], account[{account}]")
        assert self.accounts_structure.get(participant) is not None, f"Unable to find participant[{participant}] in" \
                                                                 f" account structure"
        instance_id = self.accounts_structure[participant].get(account)
        assert instance_id is not None, f"Unable to find the account. Participant:[{participant}], Account:[{account}]"
        return instance_id

    def set_acc_instance_id(self, participant_name, account, instance_id):
        self.loader_logger.debug(f"set_acc_instance_id: participant_name[{participant_name}], "
                                         f"account[{account}], instance_id[{instance_id}]")
        if self.accounts_structure.get(participant_name) is None:
            self.accounts_structure[participant_name] = {account: instance_id}
        else:
            self.accounts_structure[participant_name][account] = instance_id
