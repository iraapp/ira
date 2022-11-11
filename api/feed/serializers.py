from rest_framework import serializers
from user_profile.serializers import StudentSerializer
from feed.models import Document

from authentication.serializers import UserSerializer

class DocumentSerializer(serializers.Serializer):
    file = serializers.FileField()
    filename = serializers.CharField()
    extension = serializers.CharField()

class PostSerializer(serializers.Serializer):
    id = serializers.IntegerField(read_only=True)
    user = UserSerializer()
    body = serializers.CharField(max_length=30)
    attachments = DocumentSerializer(many = True)
    created_at = serializers.DateTimeField()
    updated_at = serializers.DateTimeField()
    student_profile = StudentSerializer()

    def __str__(self):
        return self.body
