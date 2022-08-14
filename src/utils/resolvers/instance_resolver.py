from src.utils.instance_registry import InstanceRegistry
from src.utils.resolvers.resolver import Resolver
import re
import logging


class InstanceResolver(Resolver):

    def __init__(self, next_resolver):
        self.next_resolver = next_resolver
        self.instance_pattern = re.compile(r"\[(.+)\.(.+)\]")
        self.table_pattern = re.compile(r"\[(.+)\\]")

    def process(self, value):
        match = self.instance_pattern.search(str(value))
        if match is not None:
            instance_key = match.group(1)
            field_name = match.group(2)

            instance = InstanceRegistry().get_instance(instance_key)
            field_value = instance.get_field_value(field_name)
            if field_value is not None:
                value = self.instance_pattern.sub(str(field_value), str(value))
                # value = field_value
            else:
                assert False, f"In {value}, field [{field_name}] is unknown"
        elif match := self.table_pattern.search(value):
            logging.debug("Table found.")
            table_key = match.group(1)

        return value
