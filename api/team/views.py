from django.core.cache import cache
from constants import CACHE_CONSTANTS, CACHE_EXPIRY
from team.serializers import MemberSerializer
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from .models import Member

class TeamView(APIView):
  permission_classes = [IsAuthenticated]

  def get(self, _):
    cached_team = cache.get(CACHE_CONSTANTS['TEAM'])

    if cached_team:
      return Response(data = cached_team)

    members = Member.objects.all()
    responseData = MemberSerializer(members, many = True).data

    cache.set(CACHE_CONSTANTS['TEAM'], responseData, CACHE_EXPIRY)

    return Response(status = 200, data = responseData)
