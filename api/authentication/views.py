from authentication.models import Guard
from authentication.serializers import GuardSerializer
from rest_framework.response import Response
from rest_framework.views import APIView

from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import authentication_classes

from django.contrib.auth.hashers import make_password

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
            guard = Guard.objects.create(username=username, first_name= first_name, last_name=last_name, password=make_password(raw_password))
            # guard.password = make_password(raw_password)
            # guard.save()
            return Response(status=200, data = GuardSerializer(guard).data)

        else:
            return Response(status = 400)

        return None
