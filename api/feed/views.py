from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from feed.models import Document, Post
from feed.serializers import PostSerializer
from rest_framework.permissions import IsAuthenticated


class CreatePostView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        body = request.POST.get("body")
        user = request.user
        instance = Post.objects.create(
            user=user,
            body=body,
        )

        if request.FILES:
            for filename in request.FILES:
                file_instance = Document.objects.create(file = request.FILES[filename])
                file_instance.save()
                instance.attachments.add(file_instance)

        instance.save()

        return Response(data={
            "msg": "Post created successfully."
        })

class GetFeedView(APIView):
    permission_classes = [IsAuthenticated, ]

    def get(self, request, *args, **kwargs):
        data = Post.objects.all().order_by('-created_at')
        serialized_json = PostSerializer(data, many=True)
        return Response(data=serialized_json.data)
