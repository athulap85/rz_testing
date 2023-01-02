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

    @staticmethod
    def find_and_replace_matches(pattern, value, resolver_func):
        while True:
            match = pattern.search(str(value))
            if match is not None:
                result = resolver_func(match)
            else:
                break
            value = pattern.sub(str(result), value, 1)

        return value
