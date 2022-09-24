from pathlib import Path
from django.contrib.auth.backends import BaseBackend
from .models import StaffToken, UserToken
from rest_framework import authentication
from rest_framework import exceptions


class UserAuthenticationBackend(authentication.TokenAuthentication):

    keyword = 'idToken'
    model = UserToken

    def authenticate_credentials(self, token):
        try:
            decoded_token = UserToken.objects.get(key=token)
        except UserToken.DoesNotExist:
            raise exceptions.AuthenticationFailed('Invalid token.')

        try:
            user = decoded_token.user

        except Exception:
            raise exceptions.AuthenticationFailed('No such user exists')

        # allow users to make API calls only after profile is completed
        return (user, decoded_token)


class StaffAuthenticationBackend(BaseBackend):
    def authenticate(self, request):

        authorization_header = request.META.get("HTTP_AUTHORIZATION")

        if not authorization_header:
            return None

        decoded_token = None

        try:
            if authorization_header.split(' ')[0] != 'Token':
                return None

            token = authorization_header.split(' ')[1]
            decoded_token = StaffToken.objects.get(key=token)
        except Exception as e:
            print(e)
            raise exceptions.AuthenticationFailed('Invalid staff token')
        try:
            staff_user = decoded_token.user

        except Exception:
            raise exceptions.AuthenticationFailed('No such user exists')

        # allow users to make API calls only after profile is completed
        return (staff_user, None)
