
from django.urls import path
from authentication import views

urlpatterns = [
    path("login", views.ObtainIdTokenView.as_view(), name = 'login'),
    path('staff-token', views.ObtainStaffTokenView.as_view(), name='api_token_auth')
]
