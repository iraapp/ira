import firebase_admin
from firebase_admin import credentials, messaging

# cred = credentials.Certificate("../credentials.json")
# firebase_app = firebase_admin.initialize_app(cred)


def send_notification(title, body, topic):

    # message = messaging.Message(
    #   notification = messaging.Notification(
    #   title = title,
    #   body = body
    #   ),
    #   topic = topic
    # )

    # messaging.send(message)
    pass
