import requests


def lambda_handler(event, context):
    return {
        "event": "{}".format(event),
        "context": "hello world refunc"
    }
