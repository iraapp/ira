from email.policy import default
from rest_framework import serializers

class MaintenanceStaffContactsSer(serializers.Serializer):
    name = serializers.CharField(max_length=100)
    contact = serializers.CharField(max_length=10)
    designation = serializers.CharField(max_length=100)
    start_time = serializers.TimeField()
    end_time = serializers.TimeField()
    location = serializers.CharField(max_length=30, default='')
