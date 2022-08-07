from random import randint
from src.utils.resolvers.resolver import Resolver
import re


class StringResolver(Resolver):

    def process(self, value):
        match = re.search(r"random\((.+),(\d+)\)", str(value))

        if match is not None:
            prefix = match.group(1)
            length = int(match.group(2))

            random_num = str(randint(0, 10 ** length))
            temp_number = random_num.zfill(length)
            value = prefix + str(temp_number)

        return value
