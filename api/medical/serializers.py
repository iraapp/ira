from rest_framework import serializers

from authentication.serializers import UserSerializer


class DoctorSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    name = serializers.CharField(max_length=30)
    phone = serializers.CharField(max_length=30)
    specialization = serializers.CharField(max_length=30)
    mail = serializers.EmailField(max_length=100)
    start_time = serializers.TimeField(
        format='%I:%M %p', input_formats='%I:%M %p')
    end_time = serializers.TimeField(
        format='%I:%M %p', input_formats='%I:%M %p')
    details = serializers.CharField(max_length=50)


class StaffSerializer(serializers.Serializer):
    name = serializers.CharField(max_length=50)
    phone = serializers.CharField(max_length=50)
    designation = serializers.CharField(max_length=50)


class AppointmentSerializer(serializers.Serializer):
    id = serializers.IntegerField(read_only=True)
    doctor = DoctorSerializer()
    patient = UserSerializer()
    date = serializers.DateField()
    time = serializers.TimeField(format='%I:%M %p', input_formats='%I:%M %p')
    status = serializers.CharField()
    reason = serializers.CharField(max_length=500)


class MedicalHistorySerializer(serializers.Serializer):
    patient = UserSerializer()
    doctor = DoctorSerializer()
    date = serializers.DateField(format='%d %b %Y', input_formats=['%d %b %Y'])
    time = serializers.TimeField(format='%I:%M %p', input_formats='%I:%M %p')
    inhouse = serializers.BooleanField()
    diagnosis = serializers.CharField()
    treatment = serializers.CharField()
    details = serializers.CharField()
