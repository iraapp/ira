import json
from authentication.models import Guard, GuardToken
from authentication.serializers import GuardSerializer
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import authentication_classes

from django.contrib.auth.hashers import make_password, check_password

class CoursePageViewStudent(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        return Response(status = 200, data = "Authenticated")

    def post(self, request, *args, **kwargs):
        return Response(status = 200, data="Authenticated")

@authentication_classes([])
class RegisterGuardView(APIView):

    def post(self, request, *args, **kwargs):
        username = request.POST.get('username')
        first_name = request.POST.get('firstname')
        last_name = request.POST.get('lastname')
        raw_password = request.POST.get('password')

        if username and first_name and last_name and raw_password:
            guard = Guard.objects.create(
                username=username, first_name= first_name, last_name=last_name,
                password=make_password(raw_password))
            return Response(status=200, data = GuardSerializer(guard).data)

        else:
            return Response(status = 400)

        return None

@authentication_classes([])
class ObtainTokenView(APIView):

    def post(self, request, *args, **kwargs):
        credentials = json.loads(request.body.decode('utf-8'))
        username = credentials.get('username')
        raw_password = credentials.get('password')

        if not username or not raw_password:
            return Response(status=400, data='Username and password fields are empty')

        guard_user = Guard.objects.get(username=username)

        if check_password(raw_password, guard_user.password):
            token, _ = GuardToken.objects.get_or_create(user=guard_user)
            return Response({'token': token.key})

        return Response(status=401, data='Authentication credentials are incorrect')
