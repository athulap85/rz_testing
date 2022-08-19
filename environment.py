from src.refdata.refdata_manager import RefDataManager
from src.blueshift.refdata_adaptor import RefDataAdaptor
from src.transaction_data.interfaceManager import InterfaceManager
from src.blueshift.transaction_data_adaptor import TransactionDataAdaptor
from src.utils.instance_registry import InstanceRegistry

import logging
import time
step_start_time = 0.0
scenario_start_time = 0.0
exec_time_file = open("logs/execution_time.txt", "w")


def before_all(context):
    # create logger
    logger = logging.getLogger('loader')
    logger.setLevel(logging.DEBUG)
    ch = logging.FileHandler(filename='logs/loader.log', mode='w')
    ch.setLevel(logging.DEBUG)
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    ch.setFormatter(formatter)
    logger.addHandler(ch)

    logger.info('before_all')

    RefDataManager().init(RefDataAdaptor())
    InterfaceManager().register_interface("BLUESHIFT_API", TransactionDataAdaptor())
    exec_time_file.write("before_all\n")


def after_all(context):
    exec_time_file.write("after all\n")
    exec_time_file.close()


def before_scenario(context, scenario):
    global scenario_start_time
    scenario_start_time = time.time()
    # RefDataManager().on_scenario_start()


def after_scenario(context, scenario):
    InstanceRegistry().clear_register()
    RefDataManager().on_scenario_complete()
    exec_time_file.write(f"Exec Time : [{round(time.time() - scenario_start_time, 2)} s],\t Scenario : {scenario}\n")


def before_step(context, step):
    logging.info(f'EXECUTING STEP: {step}')
    global step_start_time
    step_start_time = time.time()


def after_step(context, step):
    exec_time_file.write(f"Exec Time : [{ round(time.time() - step_start_time, 2)} s],\t Step : {step}\n")


def before_feature(context, feature):
    RefDataManager().on_feature_start()


def after_feature(context, feature):
    RefDataManager().on_feature_complete()
