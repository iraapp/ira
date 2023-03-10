from django.core.cache import cache
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
from constants import CACHE_CONSTANTS, CACHE_EXPIRY, FEEDS_PER_PAGE
from authentication.permissions import IsAcademicBoardPG, IsAcademicBoardUG, IsAcademicOfficePG, IsAcademicOfficeUG, IsCulturalBoard, IsGymkhana, IsHostelBoard, IsHostelSecretary, IsIraTeam, IsSportsBoard, IsSwoOffice, IsTechnicalBoard
from feed.models import Document, Post
from feed.serializers import PostSerializer, PostSerializer113
from institute_app import settings
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

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
            body = body,
        )

        if request.FILES:
            for filename in request.FILES:
                file_instance = Document.objects.create(file = request.FILES[filename])
                file_instance.save()
                instance.attachments.add(file_instance)

        instance.save()

        # Invalidate cache for feed data.
        cache.delete(CACHE_CONSTANTS['FEED_CACHE'])

        send_notification(
            user.first_name + " " + user.last_name + " posted a new message",
            notification,
            settings.FEED_NOTIFICATION_CHANNEL)

        return Response(data={
            "msg": "Post created successfully."
        })


class GetFeedView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):

        if request.version == '1.3.0':
            page_number = request.GET.get('page', 1)

            data = Post.objects.all().order_by('-created_at')

            paginator = Paginator(data, FEEDS_PER_PAGE)

            try:
                page_obj = paginator.page(page_number)
            except PageNotAnInteger:
                page_obj = paginator.page(1)
            except EmptyPage:
                return Response(status = 404, data = { 'msg': 'No more data available' })

            serialized_json = PostSerializer(page_obj, many=True)

            return Response(data=serialized_json.data)


        cached_feeds = cache.get(CACHE_CONSTANTS['FEED_CACHE'])
        if cached_feeds:
            return Response(data = cached_feeds)

        data = Post.objects.all().order_by('-created_at')

        for row in data:
            row.student_profile = row.user.profile

        serialized_json = PostSerializer113(data, many=True)

        # Cache feed data in the memory as it is frequently requested
        # This results in significant reduction in server response time.
        # cache.set(CACHE_CONSTANTS['FEED_CACHE'], serialized_json.data, CACHE_EXPIRY)
        return Response(data=serialized_json.data)


class DeleteFeedView(APIView):
    permission_classes = [
        IsAuthenticated,
        IsSwoOffice|IsAcademicOfficeUG|IsAcademicOfficePG|
        IsGymkhana|IsCulturalBoard|IsTechnicalBoard|
        IsSportsBoard|IsHostelBoard|IsAcademicBoardUG|
        IsAcademicBoardPG|IsIraTeam|IsHostelSecretary]

    def post(self, request, *args):
        id = request.POST.get('id', None);

        post = Post.objects.filter(id = id).first()

        if post.user == request.user:
            post.delete()

            # Invalidate cache for feed data.
            cache.delete(CACHE_CONSTANTS['FEED_CACHE'])

            return Response(status=200, data = {
                'msg': 'Post deleted successfully'
            })

        return Response(status = 401)


class UpdateFeedView(APIView):
    permission_classes = [
        IsAuthenticated,
        IsSwoOffice|IsAcademicOfficeUG|IsAcademicOfficePG|
        IsGymkhana|IsCulturalBoard|IsTechnicalBoard|
        IsSportsBoard|IsHostelBoard|IsAcademicBoardUG|
        IsAcademicBoardPG|IsIraTeam|IsHostelSecretary
    ]

    def post(self, request):
        post_id = request.POST.get("post_id")
        body = request.POST.get("body")

        post = Post.objects.filter(id = post_id).first()

        if post.user == request.user:
            post.body = body
            post.save()

            # Invalidate cache for feed data.
            cache.delete(CACHE_CONSTANTS['FEED_CACHE'])

            return Response(status = 200, data = "Post updated")

        return Response(status=401, data="Unauthorized")
