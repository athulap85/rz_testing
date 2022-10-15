import boto3
import websockets
import asyncio
import logging
import json


class WebSocketClient:

    def __init__(self, base_url):
        self.base_url = base_url
        self.token = ""

    def init(self, user_name, password, client_id):
        self.authenticate_and_get_token(user_name, password, client_id)

    def authenticate_and_get_token(self, username: str, password: str, app_client_id: str) -> str:
        client = boto3.client('cognito-idp')

        resp = client.initiate_auth(
            ClientId=app_client_id,
            AuthFlow='USER_PASSWORD_AUTH',
            AuthParameters={
                "USERNAME": username,
                "PASSWORD": password
            }
        )

        logging.info("Log in success")
        logging.info("Access token:", resp['AuthenticationResult']['AccessToken'])
        self.token = resp['AuthenticationResult']['AccessToken']

    async def get_data(self, subscription):
        url = f"{self.base_url}?authorization={self.token}"
        logging.info(f"URL : {url}")
        async with websockets.connect(url) as websocket:
            logging.info("testing....")
            await websocket.send(json.dumps(subscription))
            response = await websocket.recv()
            logging.info(response)
            return response

    def query_data(self, subscription):
        val = asyncio.get_event_loop().run_until_complete(self.get_data(subscription))
        return val

