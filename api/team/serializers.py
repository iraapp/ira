from rest_framework import serializers

class MemberSerializer(serializers.Serializer):
    name = serializers.CharField(max_length=30)
    designation = serializers.CharField(max_length=30)
    profile = serializers.ImageField(max_length=30)
    linkedIn_url = serializers.URLField(max_length=200)
    github_url = serializers.URLField(max_length=200)
