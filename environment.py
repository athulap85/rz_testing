from src.refdata.refdata_manager import RefDataManager
from src.blueshift.refdata_adaptor import RefDataAdaptor
from src.transaction_data.interfaceManager import InterfaceManager
from src.blueshift.transaction_data_adaptor import TransactionDataAdaptor
from src.utils.instance_registry import InstanceRegistry

import time
step_start_time = 0.0
scenario_start_time = 0.0
f = open("logs/execution_time.txt", "w")


def before_all(context):
    RefDataManager().init(RefDataAdaptor())
    InterfaceManager().register_interface("BLUESHIFT_API", TransactionDataAdaptor())
    f.write("before_all\n")


def after_all(context):
    f.write("after all\n")
    f.close()


def before_scenario(context, scenario):
    global scenario_start_time
    scenario_start_time = time.time()


def after_scenario(context, scenario):
    InstanceRegistry().clear_register()
    f.write(f"Exec Time : [{round(time.time() - scenario_start_time, 2)}],\t Scenario : {scenario}\n")


def before_step(context, step):
    global step_start_time
    step_start_time = time.time()


def after_step(context, step):
    f.write(f"Exec Time : [{ round(time.time() - step_start_time, 2)}],\t Step : {step}\n")


def before_feature(context, feature):
    RefDataManager().on_feature_start()


def after_feature(context, feature):
    RefDataManager().on_feature_complete()
