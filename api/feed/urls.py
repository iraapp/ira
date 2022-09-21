from django.urls import path
from feed.views import CreatePostView, GetFeedView

urlpatterns = [
    path('create/', CreatePostView.as_view(), name='create'),
    path('feed/', GetFeedView.as_view(), name='feed'),
]