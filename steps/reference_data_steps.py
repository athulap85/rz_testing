from behave import *
import logging
from src.utils.messaging import pack_row_to_new_message
from src.utils.comparators import compare
from src.refdata.refdata_manager import RefDataManager
from src.utils.resolvers import ResolverChain
from src.utils.instance_registry import InstanceRegistry


@Given(u'instance of entity "{entity}" is created with following values')
def step_impl(context, entity):
    logging.debug(u'STEP: Given instance of entity "Instrument" is created with following values')
    msg = pack_row_to_new_message(entity, context.table.headings, context.table[0], on_new_message)
    response_msg, error_msg = RefDataManager().create_instance(msg)
    assert error_msg is None, f"Unable to create a instance of entity [{msg.definition}]. Error [{error_msg}]"


@When(u'instance of entity "{entity}" is created with following values')
def step_impl(context, entity):
    logging.debug(u'STEP: When instance of entity "Instrument" is created with following values')
    msg = pack_row_to_new_message(entity, context.table.headings, context.table[0], on_new_message)
    response_msg, error_msg = RefDataManager().create_instance(msg)
    if error_msg is not None:
        context.error_msg = error_msg
    else:
        context.error_msg = ""


@Given(u'instance "{instance_key}" of entity "{entity}" is copied with following values')
def step_impl(context, entity, instance_key):
    instance_key = ResolverChain().resolve(instance_key)
    logging.debug(f'STEP: Given instance "{instance_key}" of entity "{entity}" is copied with following values')
    for row in context.table:
        msg = pack_row_to_new_message(entity, context.table.headings, row, on_new_message)
        response_msg, error_msg = RefDataManager().copy_instance(entity, instance_key, msg)
        assert error_msg is None, f"Unable to copy the instance [{instance_key}] of entity [{entity}]." \
                                  f" Error [{error_msg}]"


@When(u'instance "{instance_key}" of entity "{entity}" is copied with following values')
def step_impl(context, entity, instance_key):
    instance_key = ResolverChain().resolve(instance_key)
    logging.debug(f'When instance "{instance_key}" of entity "{entity}" is copied with following values')
    msg = pack_row_to_new_message(entity, context.table.headings, context.table[0], on_new_message)
    response_msg, error_msg = RefDataManager().copy_instance(entity, instance_key, msg)
    if error_msg is not None:
        context.error_msg = error_msg
    else:
        context.error_msg = ""


@Given(u'instance "{instance_key}" of entity "{entity}" is updated with following values')
def step_impl(context, entity, instance_key):
    instance_key = ResolverChain().resolve(instance_key)
    msg = pack_row_to_new_message(entity, context.table.headings, context.table[0], on_new_message)
    response_msg, error_msg = RefDataManager().update_instance(entity, instance_key, msg)
    assert error_msg is None, f"Unable to update the instance [{instance_key}] of entity [{entity}]." \
                              f" Error [{error_msg}]"


@When(u'instance "{instance_key}" of entity "{entity}" is updated with following values')
def step_impl(context, entity, instance_key):
    instance_key = ResolverChain().resolve(instance_key)
    msg = pack_row_to_new_message(entity, context.table.headings, context.table[0], on_new_message)
    response_msg, error_msg = RefDataManager().update_instance(entity, instance_key, msg)
    if error_msg is not None:
        context.error_msg = error_msg
    else:
        context.error_msg = ""


@Then(u'instance "{instance_key}" of entity "{entity}" should be')
def step_impl(context, instance_key, entity):
    instance_key = ResolverChain().resolve(instance_key)
    response_msg, error_msg = RefDataManager().get_instance(entity, instance_key)
    assert error_msg is None, f"Unable to find the instance [{instance_key}] of entity [{entity}]. Error [{error_msg}]"
    expected_msg = pack_row_to_new_message(entity, context.table.headings, context.table[0], on_new_message)
    compare(expected_msg, response_msg, True, on_new_message)
    # assert False


@Given(u'instance "{instance_key}" of entity "{entity}" is deleted')
def step_impl(context, instance_key, entity):
    instance_key = ResolverChain().resolve(instance_key)
    response_msg, error_msg = RefDataManager().delete_instance(entity, instance_key)
    assert error_msg is None, f"Unable to delete the instance [{instance_key}] of entity [{entity}]. Error [{error_msg}]"


@When(u'instance "{instance_key}" of entity "{entity}" is deleted')
def step_impl(context, instance_key, entity):
    instance_key = ResolverChain().resolve(instance_key)
    response_msg, error_msg = RefDataManager().delete_instance(entity, instance_key)
    if error_msg is not None:
        context.error_msg = error_msg
    else:
        context.error_msg = ""


@Then(u'the request should be rejected with the error "{error_msg}"')
def step_impl(context, error_msg):
    assert error_msg == context.error_msg, f"\nExpected Error\t: {error_msg} \nReceived Error\t: {context.error_msg}\n"


@Given(u'table "{table_key}" is created with following values')
def step_impl(context, table_key):
    logging.debug(f'table "{table_key}" is created with following values')
    for row in context.table:
        table_entry_msg = pack_row_to_new_message("Table Entry", context.table.headings, row, on_new_message)
        InstanceRegistry().register_table_entry(table_key, table_entry_msg)


def on_new_message(instance_id, message):
    logging.debug(f'on_new_message "{instance_id}"')
    InstanceRegistry().register_instance(instance_id, message)
