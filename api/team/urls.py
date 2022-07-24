from django.urls import path
from .views import TeamView

urlpatterns = [
    path("all", TeamView.as_view(), name = 'login'),
]