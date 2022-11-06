from rest_framework import serializers

class StaffSerializer(serializers.Serializer):
    first_name = serializers.CharField(max_length=30)
    last_name = serializers.CharField(max_length=30)
    username = serializers.CharField(max_length=30)
    role = serializers.IntegerField()

class UserSerializer(serializers.Serializer):
    first_name = serializers.CharField(max_length=30)
    last_name = serializers.CharField(max_length=50)
    email = serializers.EmailField()
    role = serializers.IntegerField()

