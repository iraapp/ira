from email.policy import default
from authentication.serializers import UserSerializer
from rest_framework import serializers

class MaintenanceStaffContactsSer(serializers.Serializer):
    name = serializers.CharField(max_length=100)
    contact = serializers.CharField(max_length=10)
    designation = serializers.CharField(max_length=100)
    start_time = serializers.TimeField()
    end_time = serializers.TimeField()
    location = serializers.CharField(max_length=30, default='')

class HostelSerializer(serializers.Serializer):
    name = serializers.CharField()

class ComplaintTypeSerializer(serializers.Serializer):
    name = serializers.CharField(max_length=20)

class HostelComplaintSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    created_at = serializers.DateTimeField(format='%d %b %Y', input_formats='%d %b %y')
    user = UserSerializer()
    body = serializers.CharField()
    hostel = HostelSerializer()
    status = serializers.BooleanField()
    complaint_type = ComplaintTypeSerializer()

class HostelFeedbackSerializer(serializers.Serializer):
    created_at = serializers.DateTimeField(format='%d %b %Y', input_formats='%d %b %y')
    user = UserSerializer()
    body = serializers.CharField()
    hostel = HostelSerializer()
