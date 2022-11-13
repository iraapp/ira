from rest_framework import serializers

from authentication.serializers import UserSerializer

class GatePassSerializer(serializers.Serializer):
  user = UserSerializer()
  purpose = serializers.CharField()
  out_time_stamp = serializers.DateTimeField()
  in_time_stamp = serializers.DateTimeField()
  created_at = serializers.DateTimeField()
  completed_status = serializers.BooleanField()
  status = serializers.BooleanField()
  contact = serializers.CharField()

