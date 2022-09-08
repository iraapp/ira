from rest_framework import serializers


class DoctorSerializer(serializers.Serializer):
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
    doctor = serializers.IntegerField()
    patient = serializers.IntegerField()
    date = serializers.DateField()
    time = serializers.TimeField(format='%I:%M %p', input_formats='%I:%M %p')
    status = serializers.CharField()
    reason = serializers.CharField(max_length=500)


class MedicalHistorySerializer(serializers.Serializer):
    id = serializers.IntegerField(read_only=True)
    patient = serializers.IntegerField()
    doctor = serializers.IntegerField()
    date = serializers.DateField()
    time = serializers.TimeField(format='%I:%M %p', input_formats='%I:%M %p')
    inhouse = serializers.BooleanField()
    prescription = serializers.CharField(max_length=500)
    details = serializers.CharField(max_length=500)
