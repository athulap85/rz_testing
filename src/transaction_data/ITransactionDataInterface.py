from abc import ABC, abstractmethod


class ITransactionDataInterface(ABC):

    @abstractmethod
    def submit_request(self, request_message):
        pass

    @abstractmethod
    def query_data(self, query):
        pass
