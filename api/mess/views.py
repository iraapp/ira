from mess.serializers import MessSerializer, WeekDaySerializer
from mess.models import Mess
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

class MessMenu(APIView):
  permission_classes = [IsAuthenticated]

  def get(self, request):
    data = Mess.objects.all()

    serialized_json = MessSerializer(data, many=True)

    return Response(data=serialized_json.data)
