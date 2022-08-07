import logging
BLUESHIFT_API = "BLUESHIFT_API"


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
