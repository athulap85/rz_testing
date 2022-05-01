from dataclasses import field

from src.refdata.refdata_insterface import IRefDataInterface
from interfaces.webservices import HTTPClient
from src.utils.messaging import Message
from src.blueshift.reference_data_loader import DataLoader
import logging
import json
from src.utils.messaging import DataQuery, Operator
from os.path import exists

REFDATA_ENDPOINT = "https://dev.blueshiftrp.xyz/v1/reference-data-api"
REFDATA_CACHE_LOCATION = 'cache/blueshift/'


class EntityDefinition:
    def __init__(self, name, key_field, properties):
        self.name = name
        self.properties = properties
        self.field_definitions_by_name = {}
        self.field_definitions_by_display_name = {}
        self.key_field = key_field

    def get_property(self, name):
        value = self.properties.get(name)
        assert value is not None, f"Cannot find a entity property [{name}] in the entity definition [{self.name}]"
        return value

    def add_field_definition(self, field_def):
        self.field_definitions_by_name[field_def.name] = field_def
        self.field_definitions_by_display_name[field_def.get_property("displayName")] = field_def

    def find_field_def_by_name(self, field_name):
        field_def = self.field_definitions_by_name.get(field_name)
        assert field_def is not None, f"Cannot find a field with name [{field_name}] in the entity [{self.name}]"
        return field_def

    def find_field_def_by_display_name(self, display_name):
        field_def = self.field_definitions_by_display_name.get(display_name)
        assert field_def is not None, f"Cannot find a field with display name [{display_name}] in the " \
                                      f"entity [{self.name}]"
        return field_def


class FieldDefinition:

    def __init__(self, name, properties):
        self.name = name
        self.properties = properties

    def get_property(self, name):
        value = self.properties.get(name)
        assert value is not None, f"Cannot find a field property [{name}] in the field definition [{self.name}]"
        return value


class RefDataAdaptor(IRefDataInterface):

    def __init__(self):
        logging.info("inti")
        self.http_client = HTTPClient(REFDATA_ENDPOINT)
        self.entity_definitions = {}
        self.entity_name_to_display_name_map = {}

    def init(self):
        entity_cache_file = REFDATA_CACHE_LOCATION + "entities.json"
        if exists(entity_cache_file):
            f = open(entity_cache_file, "r")
            response = json.loads(f.read())
            f.close()
        else:
            status_code, response_text = self.http_client.get_request("/entities")
            if status_code == 200:
                response = json.loads(response_text)
            else:
                assert False, "Unable to load entities"
            json_object = json.dumps(response, indent=4)
            f = open(entity_cache_file, "w")
            f.write(json_object)
            f.close()

        for entity in response["entities"]:
            display_name = entity["displayName"]
            name = entity["classname"]
            key_field = self.get_key_field(display_name)
            self.entity_name_to_display_name_map[name] = display_name
            new_entity = EntityDefinition(display_name, key_field, entity)
            self.entity_definitions[display_name] = new_entity

            field_list = entity["properties"]
            for field in field_list:
                field_name = field["name"]
                field_def = FieldDefinition(field_name, field)
                new_entity.add_field_definition(field_def)
        loader = DataLoader()
        loader.load_instances(self.entity_definitions)

    def fetch_instance(self, entity_name, instance_key):
        logging.debug(f"fetch_instance: entity_name[{entity_name}], instance_key[{instance_key}]")
        entity_def = self.entity_definitions.get(entity_name)
        assert entity_def is not None, f"Cannot find the specified entity [{entity_name}] in the Blue Shift"
        sub_endpoint = entity_def.get_property("endpoint")
        assert sub_endpoint is not None, f"Cannot find the property 'endpoint' in Blue Shift entity [{entity_name}]"
        key_field = self.get_key_field(entity_name)

        field_def = entity_def.find_field_def_by_display_name(key_field)
        assert field_def is not None, f"Cannot find the specified field [{key_field}] in entity [{entity_name}]"
        filter_values = {"data": [instance_key], "type": field_def.get_property("type")}
        query_obj = {field_def.name: filter_values}

        status_code, response = self.http_client.post_request("/" + sub_endpoint + "-search?userName=ranush", query_obj)
        if status_code == 200:
            response_json = json.loads(response)
            assert len(response_json["content"]) > 0, f"Unable to find the instance [{instance_key}] of entity [{entity_name}]"

            response_msg = None
            for instance in response_json["content"]:
                if instance[field_def.name] == instance_key:
                    response_msg = instance
            logging.info(f"fetch_instance: selected instance: \n {response_msg}")
            assert response_msg is not None, f"Unable to find the instance [{instance_key}] of entity [{entity_name}]"
            return self.create_response_msg(entity_def, response_msg), None
        else:
            return None, response

    def update_instance(self, original_instance_msg, changes_msg):
        logging.debug(f"update_instance")
        entity_def = self.entity_definitions.get(original_instance_msg.definition)
        sub_endpoint = entity_def.get_property("endpoint")
        instance_id = original_instance_msg.get_field_value("Id")
        request = self.copy_and_create_request_msg(entity_def, original_instance_msg, changes_msg)

        status_code, response = self.http_client.put_request("/" + sub_endpoint + "/" + str(instance_id), request)
        if status_code == 204:
            return None, None
        else:
            return None, response

    def copy_instance(self, original_instance_msg, changes_msg):
        logging.debug(f"copy_instance")
        entity_def = self.entity_definitions.get(original_instance_msg.definition)
        request = self.copy_and_create_request_msg(entity_def, original_instance_msg, changes_msg)
        return self.post_create_instance(entity_def, request)

    def create_instance(self, message):
        logging.debug(f"create_instance")
        entity_def = self.entity_definitions.get(message.definition)
        request = self.create_request_msg(entity_def, message)
        return self.post_create_instance(entity_def, request)

    def post_create_instance(self, entity_def, request):
        logging.debug(f"post_create_instance")
        sub_endpoint = entity_def.get_property("endpoint")
        status_code, response = self.http_client.post_request("/" + sub_endpoint, request)
        if status_code == 200:
            response_json = json.loads(response)
            response_msg = self.create_response_msg(entity_def, response_json)
            self.update_loader(entity_def.name, response_msg)
            return response_msg, None
        else:
            return None, response

    def delete_instance(self, entity, instance_key):
        logging.debug(f"delete_instance: entity[{entity}], instance_key[{instance_key}]")
        entity_def = self.entity_definitions.get(entity)
        sub_endpoint = entity_def.get_property("endpoint")
        instance_id = self.get_instance_id(entity, instance_key)

        status_code, response = self.http_client.delete_request("/" + sub_endpoint + "/" + str(instance_id))
        if status_code == 204:
            DataLoader().remove_instance_id(entity, instance_key)
            return None, None
        else:
            return None, response

    def create_response_msg(self, entity_definition, response):
        logging.debug(f"create_response_msg: entity[{entity_definition.name}]")
        msg = Message(entity_definition.name)
        for key, value in response.items():
            field_def = entity_definition.find_field_def_by_name(key)

            data_type = field_def.get_property("type")
            if value is not None:
                if data_type in self.entity_name_to_display_name_map:
                    if type(value) == list:
                        value = '|'.join([x["name"] for x in value])
                    else:
                        value = value["name"]
                elif data_type == "Enum":
                    value = value.replace("_", " ").title()

            display_name = field_def.get_property("displayName")
            msg.set_field_value(display_name, value)
        return msg

    def create_request_msg(self, entity_definition, message):
        logging.debug(f"create_request_msg entity [{entity_definition.name}]")
        request = {}
        for key, value in message.fieldValues.items():
            if key == "Id":
                continue

            field_def = entity_definition.find_field_def_by_display_name(key)
            data_type = field_def.get_property("type")

            if value is not None:
                if data_type in self.entity_name_to_display_name_map:
                    value = self.enrich_linked_instance_details(self.entity_name_to_display_name_map[data_type], value)
                elif data_type == "Enum":
                    value = value.replace(" ", "_").upper()

            name = field_def.get_property("name")
            request[name] = value

        return request

    def copy_and_create_request_msg(self, entity_definition, original_instance_msg, changes_msg):
        logging.debug(f"copy_and_create_request_msg entity [{entity_definition.name}]")
        logging.info(f"change msg : {str(changes_msg)}")
        request = {}
        for key, value in original_instance_msg.fieldValues.items():
            if key == "Id":
                continue

            field_def = entity_definition.find_field_def_by_display_name(key)

            changed_value = changes_msg.get_field_value(key)
            if changed_value is not None:
                value = changed_value

            data_type = field_def.get_property("type")
            if value is not None:
                if data_type in self.entity_name_to_display_name_map:
                    value = self.enrich_linked_instance_details(self.entity_name_to_display_name_map[data_type], value)
                elif data_type == "Enum":
                    value = value.replace(" ", "_").upper()

            name = field_def.get_property("name")

            if entity_definition.name == "Instruments" and (name == "instrumentId" or name == "fixedIncomeId"):
                value = None

            request[name] = value

        return request

    def enrich_linked_instance_details(self, related_entity_name, received_value):
        logging.debug(f"enrich_linked_instance_details entity [{related_entity_name}] value [{received_value}]")
        if "|" in received_value:
            values = received_value.split("|")
            item_list = []
            for value in values:
                instance_id = self.get_instance_id(related_entity_name, value)
                item_list.append({"id": instance_id, "name": value})
            return item_list
        else:
            instance_id = self.get_instance_id(related_entity_name, received_value)
            return {"id": instance_id, "name": received_value}

    def get_instance_id(self, entity_name, instance_key):
        logging.debug(f"get_instance_id entity [{entity_name}] instance key [{instance_key}]")
        instance_id = DataLoader().get_instance_id(entity_name, instance_key)
        if instance_id is None:
            response_msg, error_msg = self.fetch_instance(entity_name, instance_key)
            instance_id = response_msg.get_field_value("Id")
            assert instance_id is not None, f"Cannot find instance id [{instance_key}] in entity [{entity_name}]"
            DataLoader().set_instance_id(entity_name, instance_key, instance_id)

        return instance_id

    def update_loader(self, entity,  response):
        logging.debug(f"update_loader entity [{entity}] response:[{str(response)}]")
        instance_id = response.get_field_value("Id")
        instance_name = response.get_field_value(self.get_key_field(entity))
        if entity == "Accounts":
            participant = response.get_field_value("Participant")
            DataLoader().set_acc_instance_id(participant, instance_name, instance_id)
        else:
            DataLoader().set_instance_id(entity, instance_name, instance_id)





