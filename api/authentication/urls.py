
from django.urls import path
from authentication import views

urlpatterns = [
    path("login", views.CoursePageViewStudent.as_view(), name = 'login'),
    path("register_guard", views.RegisterGuardView.as_view(), name="register guard")
]