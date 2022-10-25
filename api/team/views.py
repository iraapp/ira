from team.serializers import MemberSerializer
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from .models import Member

class TeamView(APIView):
  permission_classes = [IsAuthenticated]

  def get(self, request, *args, **kwargs):
    members = Member.objects.all()

    return Response(status = 200, data = MemberSerializer(members, many = True).data)
