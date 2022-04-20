from src.refdata.refdata_manager import RefDataManager
from src.blueshift.refdata_adaptor import RefDataAdaptor
from src.transaction_data.interfaceManager import InterfaceManager
from src.blueshift.transaction_data_adaptor import TransactionDataAdaptor
from src.utils.instance_registry import InstanceRegistry


def before_all(context):
    RefDataManager().init(RefDataAdaptor())
    InterfaceManager().register_interface("BLUESHIFT_API", TransactionDataAdaptor())


def before_scenario(context, scenario):
    pass


def after_scenario(context, feature):
    InstanceRegistry().clear_register()


def before_step(context, step):
    pass


def before_feature(context, feature):
    RefDataManager().on_feature_start()


def after_feature(context, feature):
    RefDataManager().on_feature_complete()
