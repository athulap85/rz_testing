class InstanceRegistry:
    instance = None
    message_register = {}
    table_register = {}

    def __new__(cls):
        if cls.instance is None:
            cls.instance = super(InstanceRegistry, cls).__new__(cls)
        return cls.instance

    def register_instance(self, instance_id, message):
        # assert instance_id not in self.message_register, f'Instance ID [{instance_id}] is already registered'
        self.message_register[instance_id] = message

    def get_instance(self, instance_key):
        assert instance_key in self.message_register, f'Unknown instance key [{instance_key}].' \
                                                     f' Instance key is not registered before'
        return self.message_register.get(instance_key)

    def register_table_entry(self, table_key, table_entry_key):
        table = self.table_register.get(table_key)
        if table is None:
            self.table_register[table_key] = [table_entry_key]
        else:
            self.table_register[table_key].append(table_entry_key)

    def get_table(self, table_key):
        assert table_key in self.table_register, f'Unknown table key [{table_key}].' \
                                                      f' Table key is not registered before'
        return self.table_register.get(table_key)

    def clear_register(self):
        self.message_register.clear()
        self.table_register.clear()
