from src.utils.resolvers.instance_resolver import InstanceResolver
from src.utils.resolvers.datetime_resolver import DateTimeResolver
from src.utils.resolvers.quantlib_resolver import QuantLibFunctionsResolver
from src.utils.resolvers.string_resolver import StringResolver


class ResolverChain:
    instance = None
    resolver = None

    def __new__(cls):
        if cls.instance is None:
            cls.instance = super(ResolverChain, cls).__new__(cls)
            cls.build_chain(cls)
        return cls.instance

    def build_chain(self):
        self.resolver = InstanceResolver(DateTimeResolver(StringResolver(QuantLibFunctionsResolver(None))))

    def resolve(self, value):
        return self.resolver.resolve(value)
