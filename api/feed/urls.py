from django.urls import path
from feed.views import CreatePostView, DeleteFeedView, GetFeedView, UpdateFeedView

urlpatterns = [
    path('create/', CreatePostView.as_view(), name='create'),
    path('update/', UpdateFeedView.as_view(), name='update feed'),
    path('feed/', GetFeedView.as_view(), name='feed'),
    path('delete/', DeleteFeedView.as_view(), name='delete feed')
]