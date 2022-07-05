
from django.urls import path

from mess import views

urlpatterns = [
    path('all_items', views.MessMenu.as_view(), name="mess items"),
    path('feedback', views.FeedbackView.as_view(), name="Add get feedbacks"),
    path('feedback/<int:pk>', views.FeedbackInstanceView.as_view(),
         name="Feedback instance"),


]
