class InstanceRegistry:
    instance = None
    message_register = {}

    def __new__(cls):
        if cls.instance is None:
            cls.instance = super(InstanceRegistry, cls).__new__(cls)
        return cls.instance

    def register_instance(self, instance_id, message):
        assert instance_id not in self.message_register, f'Instance ID [{instance_id}] is already registered'
        self.message_register[instance_id] = message

    def get_instance(self, instance_id):
        assert instance_id in self.message_register, f'Unknown instance ID [{instance_id}].' \
                                                     f' Instance ID is not registered before'
        return self.message_register.get(instance_id)

    def clear_register(self):
        self.message_register.clear()