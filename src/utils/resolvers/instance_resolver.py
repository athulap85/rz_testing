from src.utils.instance_registry import InstanceRegistry
from src.utils.resolvers.resolver import Resolver
import re
import logging


class InstanceResolver(Resolver):

    def __init__(self, next_resolver):
        self.next_resolver = next_resolver
        self.instance_pattern = re.compile(r"\[([a-zA-Z0-9_ ]+)\.([a-zA-Z0-9_ ]+)\]")

    def process(self, value):
        return self.find_and_replace_matches(self.instance_pattern, value, self.resolve_instance_match)

    @staticmethod
    def resolve_instance_match(match):
        instance_key = match.group(1)
        field_name = match.group(2)
        logging.debug(f"resolve_instance_match: instance_key : {instance_key}, field_name: {field_name}")

        instance = InstanceRegistry().get_instance(instance_key)
        value = instance.get_field_value(field_name)
        assert value is not None, f"InstanceResolver: In {instance_key}, field [{field_name}] is unknown"
        return value

