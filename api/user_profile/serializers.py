from rest_framework import serializers

class StudentSerializer(serializers.Serializer):
  name = serializers.CharField(max_length=30)
  entry_no = serializers.CharField(max_length=30)
  programme = serializers.CharField(max_length=30)
  branch = serializers.CharField(max_length=30)
  phone_number = serializers.CharField(max_length=20)
  address = serializers.CharField(max_length=100)
  date_of_birth = serializers.DateField()
  valid_upto = serializers.DateField()
  emergency_no = serializers.CharField()
  blood_group = serializers.CharField()
  profile_image = serializers.ImageField()
