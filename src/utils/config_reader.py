import configparser

confi

def read_config():

    config = configparser.ConfigParser()
    config.read('configs/app_config.ini')
    return config