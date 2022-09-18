from rest_framework import serializers


class PostSerializer(serializers.Serializer):
    id = serializers.IntegerField(read_only=True)
    user = serializers.CharField(max_length=30)
    body = serializers.CharField(max_length=30)
    image = serializers.ImageField()
    file = serializers.FileField()
    created_at = serializers.DateTimeField()
    updated_at = serializers.DateTimeField()

    def __str__(self):
        return self.body
