
from django.urls import path

from hostel import views

"""
1 . maintenance/contact
    - Get - get all maintenance staff contacts instance
"""

urlpatterns = [
    path('hostel-complaint-list', views.HostelAndComplaintListView.as_view(), name="Hostel list"),
    path('maintenance/contact', views.MaintenanceStaffContactsView.as_view(), name="Maintenance staff contact items"),
    path('feedback', views.HostelFeedbackView.as_view(), name="Add get feedbacks"),
    path('complaint', views.HostelComplaintView.as_view(), name='Hostel Complaint'),
    path('complaint/action/<int:pk>/',
         views.HostelComplaintActionView.as_view(), name="complaint action"),
]
