from pathlib import Path
from django.contrib.auth.backends import BaseBackend
from .models import GuardToken, User
from rest_framework import authentication
from rest_framework import exceptions
from google.auth.transport import requests
from google.oauth2 import id_token

import environ
import os

# Intializing django environ
env = environ.Env()

# Set the project base directory
BASE_DIR = Path(__file__).resolve().parent.parent

# Take environment variables from .env file
environ.Env.read_env(os.path.join(BASE_DIR.parent, '.env'))


class GoogleAuthenticationBackend(authentication.BaseAuthentication):
    def authenticate(self, request):

        authorization_header = request.META.get("HTTP_AUTHORIZATION")

        if not authorization_header:
            return None

        decoded_token = None

        try:
            if authorization_header.split(' ')[0] != 'idToken':
                return None

            token = authorization_header.split(' ')[1]
            print(f"Token= {token}")
            decoded_token = id_token.verify_oauth2_token(
                token, requests.Request(), env('GOOGLE_OAUTH_CLIENT_ID'))

        except Exception as e:
            print(e)
            raise exceptions.AuthenticationFailed('Invalid ID Token')
        try:
            email = decoded_token.get("email")
        except Exception:
            raise exceptions.AuthenticationFailed('No such user exists')

        user, _ = User.objects.get_or_create(email=email, role=1)

        # allow users to make API calls only after profile is completed
        return (user, None)


class GuardAuthenticationBackend(BaseBackend):
    def authenticate(self, request):

        authorization_header = request.META.get("HTTP_AUTHORIZATION")

        if not authorization_header:
            return None

        decoded_token = None

        try:
            if authorization_header.split(' ')[0] != 'Token':
                return None

            token = authorization_header.split(' ')[1]
            decoded_token = GuardToken.objects.get(key=token)
        except Exception as e:

            raise exceptions.AuthenticationFailed('Invalid ID Token')
        try:
            guard_user = decoded_token.user

        except Exception:
            raise exceptions.AuthenticationFailed('No such user exists')

        # allow users to make API calls only after profile is completed
        return (guard_user, None)
