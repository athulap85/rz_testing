from abc import ABC, abstractmethod


class IInterface(ABC):

    @abstractmethod
    def request(self, message):
        pass

    @abstractmethod
    def query(self, message):
        pass
