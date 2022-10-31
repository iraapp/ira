import json
import os
from pathlib import Path
from user_profile.models import Student
from authentication.models import Staff, StaffToken, User, UserToken
from authentication.serializers import StaffSerializer
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import authentication_classes

from django.contrib.auth.hashers import make_password, check_password
from google.auth.transport import requests
from google.oauth2 import id_token
from rest_framework import exceptions

import environ

env = environ.Env()

# Set the project base directory
BASE_DIR = Path(__file__).resolve().parent.parent

# Take environment variables from .env file
environ.Env.read_env(os.path.join(BASE_DIR.parent, '.env'))


class ObtainIdTokenView(APIView):
    permission_classes = []

    def post(self, request, *args, **kwargs):
        credentials = json.loads(request.body.decode('utf-8'))
        idToken = credentials.get('idToken')

        if not idToken:
            return Response(status=400, data='idToken field is empty')

        try:
            decoded_token = id_token.verify_oauth2_token(
                idToken, requests.Request(), env('GOOGLE_OAUTH_CLIENT_ID'))
        except Exception as e:
            print(e)
            raise exceptions.AuthenticationFailed('Invalid ID Token')

        try:
            email = decoded_token.get("email")
            first_name = decoded_token.get("given_name").capitalize()
            last_name = decoded_token.get("family_name").capitalize()

        except Exception:
            raise exceptions.AuthenticationFailed('No such user exists')

        user, _ = User.objects.get_or_create(
            email=email, role=1, first_name=first_name, last_name=last_name)

        token, _ = UserToken.objects.get_or_create(user=user)

        askForDetails = True

        if Student.objects.filter(user=user):
            askForDetails = False

        return Response(status=200, data={'idToken': token.key, 'askForDetails': askForDetails})


class CoursePageViewStudent(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        return Response(status=200, data="Authenticated")

    def post(self, request, *args, **kwargs):
        return Response(status=200, data="Authenticated")


@authentication_classes([])
class RegisterStaffView(APIView):

    def post(self, request, *args, **kwargs):
        username = request.POST.get('username')
        first_name = request.POST.get('firstname')
        last_name = request.POST.get('lastname')
        raw_password = request.POST.get('password')

        if username and first_name and last_name and raw_password:
            staff = Staff.objects.create(
                username=username, first_name=first_name, last_name=last_name,
                password=make_password(raw_password))
            return Response(status=200, data=StaffSerializer(staff).data)

        else:
            return Response(status=400)


@authentication_classes([])
class ObtainTokenView(APIView):

    def post(self, request, *args, **kwargs):
        credentials = json.loads(request.body.decode('utf-8'))
        username = credentials.get('username')
        raw_password = credentials.get('password')

        if not username or not raw_password:
            return Response(status=400, data='Username and password fields are empty')

        staff_user = Staff.objects.get(username=username)

        if check_password(raw_password, staff_user.password):
            token, _ = StaffToken.objects.get_or_create(user=staff_user)
            return Response({'token': token.key, 'staff_user': StaffSerializer(staff_user).data})

        return Response(status=401, data='Authentication credentials are incorrect')
