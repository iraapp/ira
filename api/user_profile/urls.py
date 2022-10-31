
from django.urls import path
from user_profile import views

urlpatterns = [
    path('student', views.StudentProfile.as_view(), name='student_profile'),
]