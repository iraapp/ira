from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from feed.models import *
from feed.serializers import *


class CreatePostView(APIView):
    def post(self, request, *args, **kwargs):
        body = request.POST.get("body")
        image = request.FILES.get("image")
        file = request.FILES.get("file")
        user = request.user
        instance = Post.objects.create(
            user=user,
            body=body,
        )
        if image:
            instance.image = image
        if file:
            instance.file = file
        instance.save()

        return Response(data={
            "msg": "Post created successfully."
        })


class GetFeedView(APIView):
    def get(self, request, *args, **kwargs):
        data = Post.objects.all()
        serialized_json = PostSerializer(data, many=True)
        return Response(data=serialized_json.data)
        
