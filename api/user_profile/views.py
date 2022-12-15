import json
from django.http import FileResponse
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from user_profile.serializers import StudentSerializer
from authentication.models import User
from authentication.backends import UserAuthenticationBackend
from rest_framework.decorators import authentication_classes

from user_profile.models import Student
# Create your views here.

class StudentProfile(APIView):
  permission_classes = [IsAuthenticated]

  def get(self, request):
    return Response(status=200, data = StudentSerializer(request.user.profile).data)

  def post(self, request):
    user = request.user
    phone_number = request.POST.get('mobile')
    emergency_no = request.POST.get('emergency')
    branch = request.POST.get('discipline')
    programme = request.POST.get('programme')

    request.FILES.get('profile')

    profile = Student.objects.create(
      name = user.first_name + ' ' + user.last_name,
      entry_no = user.email.split('@')[0].upper(),
      programme = programme,
      branch = branch,
      phone_number = phone_number,
      emergency_no = emergency_no,
      profile_image = request.FILES.get('profile')
    )

    user.profile = profile
    user.save()

    return Response(status = 200, data = { 'msg': 'success' })

class StudentProfileImage(APIView):
  permission_classes = [IsAuthenticated]

  def get(self, request):

    return FileResponse(request.user.profile.profile_image.file)

class ContactView(APIView):
  permission_classes = [IsAuthenticated]

  def get(self, request):
    return Response(status = 200, data = request.user.profile.phone_number)
