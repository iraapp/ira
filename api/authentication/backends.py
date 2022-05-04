from django.contrib.auth.backends import BaseBackend
from .models import Guard, User
from rest_framework import authentication
from rest_framework import exceptions
from google.auth.transport import requests
from google.oauth2 import id_token
from django.contrib.auth.hashers import check_password

class GoogleAuthenticationBackend(authentication.BaseAuthentication):
    def authenticate(self, request):

        authorization_header = request.META.get("HTTP_AUTHORIZATION")

        if not authorization_header:
            return None

        decoded_token = None

        try:
            token = authorization_header.split(' ')[1]
            decoded_token = id_token.verify_oauth2_token(token, requests.Request(), "776874295259-53ophl75eqo7l0bfgad108p7nm75do1i.apps.googleusercontent.com")
        except Exception as e:

            print(e)
            raise exceptions.AuthenticationFailed('Invalid ID Token')
        try:
            email = decoded_token.get("email")
            print(email)
        except Exception:
            raise exceptions.AuthenticationFailed('No such user exists')


        user, _ = User.objects.get_or_create(email=email, role=1)

        # allow users to make API calls only after profile is completed
        return (user, None)


class GuardAuthenticationBackend(BaseBackend):
    def authenticate(self, request):
        username = request.POST.get('username')
        raw_password = request.POST.get('password')

        if username and raw_password:
            guard_user = Guard.objects.get(username=username)
            if check_password(raw_password, guard_user.password):
                return (guard_user, None)
            else:
                raise exceptions.AuthenticationFailed('Authorization credentials are incorrect')
        else:
            raise exceptions.AuthenticationFailed('Authorization credentials not provided')
