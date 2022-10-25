import json
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from authentication.models import User
from authentication.backends import UserAuthenticationBackend
from rest_framework.decorators import authentication_classes

from user_profile.models import Student
# Create your views here.

@authentication_classes([
  UserAuthenticationBackend
])
class StudentProfile(APIView):
  permission_classes = [IsAuthenticated]

  def get(self, request):
    profile = Student.objects.filter(user=request.user).first()

    return Response(status=200, data={
      'name': profile.name,
      'entry_no': profile.entry_no,
      'programme': profile.programme,
      'branch': profile.branch,
      'phone_number': profile.phone_number,
      'address': profile.address,
      'date_of_birth': profile.date_of_birth,
      'valid_upto': profile.valid_upto,
      'emergency_no': profile.emergency_no,
      'blood_group': profile.blood_group
    })

  def post(self, request):
    user = request.user
    body = json.loads(request.body.decode('utf-8'))
    phone_number = body.get('mobile')
    emergency_no = body.get('emergency')
    branch = body.get('discipline')
    programme = body.get('programme')

    Student.objects.create(
      user = user,
      name = user.first_name + ' ' + user.last_name,
      entry_no = user.email.split('@')[0].upper(),
      programme = programme,
      branch = branch,
      phone_number = phone_number,
      emergency_no = emergency_no
    )

    return Response(status = 200, data = { 'msg': 'success' })
