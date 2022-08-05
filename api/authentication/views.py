import json
from authentication.models import Staff, StaffToken
from authentication.serializers import StaffSerializer
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
class RegisterStaffView(APIView):

    def post(self, request, *args, **kwargs):
        username = request.POST.get('username')
        first_name = request.POST.get('firstname')
        last_name = request.POST.get('lastname')
        raw_password = request.POST.get('password')

        if username and first_name and last_name and raw_password:
            staff = Staff.objects.create(
                username=username, first_name= first_name, last_name=last_name,
                password=make_password(raw_password))
            return Response(status=200, data = StaffSerializer(staff).data)

        else:
            return Response(status = 400)


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
