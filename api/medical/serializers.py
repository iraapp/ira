from rest_framework import serializers


class DoctorSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    name = serializers.CharField(max_length=30)
    phone = serializers.CharField(max_length=30)
    specialization = serializers.CharField(max_length=30)
    mail = serializers.EmailField(max_length=100)
    joined_at = serializers.DateField()
    start_time = serializers.TimeField()
    age = serializers.IntegerField()
    details = serializers.CharField(max_length=1000)
    end_time = serializers.TimeField()


class StaffSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    name = serializers.CharField(max_length=30)
    phone = serializers.CharField(max_length=30)
    specialization = serializers.CharField(max_length=30)
    joined_at = serializers.DateTimeField()
    start_time = serializers.TimeField()
    end_time = serializers.TimeField()
