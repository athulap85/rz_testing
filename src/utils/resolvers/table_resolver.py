from src.utils.instance_registry import InstanceRegistry
from src.utils.resolvers.resolver import Resolver
import re
import logging


class TableResolver(Resolver):

    def __init__(self, next_resolver):
        self.next_resolver = next_resolver
        self.instance_pattern = re.compile(r"\[TABLE:([a-zA-Z0-9_ ]+)\]")

    def process(self, value):
        return self.find_and_replace_matches(self.instance_pattern, value, self.resolve_table_match)

    @staticmethod
    def resolve_table_match(match):
        table_id = match.group(1)
        logging.debug(f"resolve_table_match: table id : {table_id}")

        # instance = InstanceRegistry().get_instance(instance_key)
        # value = instance.get_field_value(field_name)
        # assert value is not None, f"InstanceResolver: In {instance_key}, field [{field_name}] is unknown"

        value = []
        tab_entry_list = InstanceRegistry().get_table(table_id)
        for entry in tab_entry_list:
            value.append(entry)

        return value

