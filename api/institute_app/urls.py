"""institute_app URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from . import views


urlpatterns = [
    path('', views.welcome, name='welcome'),
    path('admin/', admin.site.urls),
    path("auth/", include("authentication.urls")),
    path('gate_pass/', include('gate_pass.urls')),
    path('user_profile/', include('user_profile.urls')),
    path('mess/', include('mess.urls')),
    path('hostel/', include('hostel.urls')),
    path('team/', include('team.urls')),
    path('medical/', include('medical.urls')),
    path('timetable/', include('timetable.urls')),
    path('feed/', include('feed.urls'))
]


if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL,
                          document_root=settings.MEDIA_ROOT)
