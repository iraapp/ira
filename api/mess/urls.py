
from django.urls import path

from mess import views

"""
url used here
    1. /feedback
                    - GET - get all feedbacks
                    - POST - create a feedback
    2. /feedback/<id>
                    - GET - get a feedback using primary key
    3. /mom
                    - GET - get all mom
                    - POST - create a mom
    4. /mom/<id>
                    - GET - get a mom using primary key
    5. /tender
                    - GET - get all tender
                    - POST - create a tender
    6. /tender/<id>
                    - GET - get a tender using primary key
    7. /all_items
                    - GET - get all mess items
     8. feedback/action/<int:pk>/ - for admin to update feedback status

     9. tender/archive/<int:pk>/ - for admin to archive tender

     10. /complaint
                    - GET - get all complaints
                    - POST - create a complaint
    11. /complaint/<id>
                    - GET - get a complaint using primary key
     12. /complaint/action/<id>
                    - PUT - update complaint status
"""

urlpatterns = [
    path('all_items', views.MessMenuAPI.as_view(), name="mess items"),
    path('feedback', views.FeedbackView.as_view(), name="Add get feedbacks"),
    path('feedback/<int:pk>', views.FeedbackInstanceView.as_view(),
         name="Feedback instance"),
    path('complaint', views.ComplaintView.as_view(), name="Add get complaint"),
    path('complaint/<int:pk>', views.ComplaintInstanceView.as_view(),
         name="complaint instance"),
    path('mom', views.MessMomView.as_view(), name="Add get mom"),
    path('mom/<int:pk>', views.MessMomInstanceView.as_view(),
         name="Mom instance"),
    path('tender', views.MessTenderView.as_view(), name="Add get tender"),
    path('tender/<int:pk>', views.MessTenderInstanceView.as_view(),
         name="tender instance"),
    path('feedback/action/<int:pk>/',
         views.FeedbackActionView.as_view(), name="feedback action"),
    path('complaint/action/<int:pk>/',
         views.ComplaintActionView.as_view(), name="feedback action"),
    path('tender/archive/<int:pk>/', views.MessTenderArchivedView.as_view(),
         name="tender action"),
]
