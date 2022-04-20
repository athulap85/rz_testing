import logging
import re
from src.utils.instance_registry import InstanceRegistry


class ResolverChain:
    instance = None
    resolver = None

    def __new__(cls):
        if cls.instance is None:
            cls.instance = super(ResolverChain, cls).__new__(cls)
            cls.build_chain(cls)
        return cls.instance

    def build_chain(self):
        self.resolver = InstanceResolver(DateTimeResolver(None))

    def resolve(self, value):
        return self.resolver.resolve(value)


class Resolver:

    def __init__(self, next_resolver):
        self.next_resolver = next_resolver

    def resolve(self, value):
        value_out = self.process(value)
        if str(value_out) != str(value):
            logging.info(f"{self.__class__.__name__} In=>Out : {value}=>{value_out}")
        if self.next_resolver is not None:
            return self.next_resolver.resolve(value_out)
        else:
            return value_out

    def process(self, value):
        return value


class InstanceResolver(Resolver):

    def process(self, value):
        match = re.search("\\[(.+)\\]", value)
        if match is not None:
            matched_value = match.group(1)
            value_list = matched_value.split(".")
            if len(value_list) == 2:
                instance = InstanceRegistry().get_instance(value_list[0])
                field_value = instance.get_field_value(value_list[1])
                if field_value is not None:
                    value = field_value
                else:
                    assert False, f"In {value}, field [{value_list[1]}] is unknown"

        return value


class DateTimeResolver(Resolver):

    def process(self, value):
        return value
