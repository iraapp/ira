
from django.urls import path
from authentication import views

urlpatterns = [
    path("login", views.ObtainIdTokenView.as_view(), name = 'login'),
    path("register_staff", views.RegisterStaffView.as_view(), name="register staff"),
    path('staff-token', views.ObtainTokenView.as_view(), name='api_token_auth')
]
