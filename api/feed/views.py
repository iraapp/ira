from authentication.permissions import IsAcademicBoardPG, IsAcademicBoardUG, IsAcademicOfficePG, IsAcademicOfficeUG, IsCulturalBoard, IsGymkhana, IsHostelBoard, IsHostelSecretary, IsIraTeam, IsSportsBoard, IsSwoOffice, IsTechnicalBoard
from feed.models import Document, Post
from feed.serializers import PostSerializer
from institute_app import settings
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from user_profile.models import Student

from .firebase import send_notification


class CreatePostView(APIView):
    permission_classes = [
        IsAuthenticated,
        IsSwoOffice|IsAcademicOfficeUG|IsAcademicOfficePG|
        IsGymkhana|IsCulturalBoard|IsTechnicalBoard|
        IsSportsBoard|IsHostelBoard|IsAcademicBoardUG|
        IsAcademicBoardPG|IsIraTeam|IsHostelSecretary]

    def post(self, request):
        body = request.POST.get("body")
        user = request.user
        notification = request.POST.get("notification")

        instance = Post.objects.create(
            user = user,
            student_profile = Student.objects.filter(user = user).first(),
            body = body,
        )

        if request.FILES:
            for filename in request.FILES:
                file_instance = Document.objects.create(file = request.FILES[filename])
                file_instance.save()
                instance.attachments.add(file_instance)

        instance.save()

        send_notification(user.first_name + " " + user.last_name + " posted a new message", notification, settings.FEED_NOTIFICATION_CHANNEL)

        return Response(data={
            "msg": "Post created successfully."
        })

class GetFeedView(APIView):
    permission_classes = [IsAuthenticated, ]

    def get(self, request, *args, **kwargs):
        data = Post.objects.all().order_by('-created_at')
        serialized_json = PostSerializer(data, many=True)
        return Response(data=serialized_json.data)

class DeleteFeedView(APIView):
    permission_classes = [IsAuthenticated, ]

    def post(self, request, *args):
        id = request.POST.get('id', None);

        post = Post.objects.filter(id = id).first()

        if post.user == request.user:
            post.delete()

            return Response(status=200, data = {
                'msg': 'Post deleted successfully'
            })

        return Response(status = 401)


class UpdateFeedView(APIView):
    permission_classes = [IsAuthenticated, ]

    def post(self, request):
        post_id = request.POST.get("post_id")
        body = request.POST.get("body")

        post = Post.objects.filter(id = post_id).first()

        if post.user == request.user:
            post.body = body
            post.save()

            return Response(status = 200, data = "Post updated")

        return Response(status=401, data="Unauthorized")
