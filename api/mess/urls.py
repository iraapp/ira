
from django.urls import path
from mess import views

urlpatterns = [
  path('all_items', views.MessMenu.as_view(), name="mess items"),
]
