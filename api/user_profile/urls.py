
from django.urls import path
from user_profile import views

urlpatterns = [
    path('student', views.StudentProfile.as_view(), name='student_profile'),
    path('image', views.StudentProfileImage.as_view()),
    path('user_image', views.UserImage.as_view()),
]