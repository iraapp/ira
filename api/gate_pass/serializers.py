from rest_framework import serializers

from authentication.serializers import UserSerializer

class GatePassSerializer(serializers.Serializer):
  user = UserSerializer()
  purpose = serializers.CharField()
  out_time_stamp = serializers.DateTimeField(format='%-I:%M %p %d %b %y', input_formats='%-I:%M %p %d %b %y')
  in_time_stamp = serializers.DateTimeField(format='%-I:%M %p %d %b %y', input_formats='%-I:%M %p %d %b %y')
  created_at = serializers.DateTimeField()
  completed_status = serializers.BooleanField()
  status = serializers.BooleanField()
  contact = serializers.CharField()

