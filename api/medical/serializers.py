from rest_framework import serializers


class DoctorSerializer(serializers.Serializer):
    name = serializers.CharField(max_length=30)
    phone = serializers.CharField(max_length=30)
    specialization = serializers.CharField(max_length=30)
    mail = serializers.EmailField(max_length=100)
    start_time = serializers.TimeField(format='%I:%M %p', input_formats='%I:%M %p')
    end_time = serializers.TimeField(format='%I:%M %p', input_formats='%I:%M %p')
    details = serializers.CharField(max_length=50)


class StaffSerializer(serializers.Serializer):
    name = serializers.CharField(max_length=50)
    phone = serializers.CharField(max_length=50)
    designation = serializers.CharField(max_length=50)
