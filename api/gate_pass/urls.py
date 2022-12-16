
from django.urls import path
from gate_pass import views

urlpatterns = [
  path('studentStatus', views.StudentGatePass.as_view(), name="testing"),
  path('generate_qr', views.GenerateQR.as_view(), name="Generate QR"),
  path('scan_qr', views.ScanQR.as_view(), name="Scan QR"),
  path('delete_qr', views.DeleteQR.as_view(), name="Delete QR"),
  path('currently_out', views.CurrentlyOut.as_view(), name="Currently out"),
  path('all', views.AllStudents.as_view(), name = 'All students'),
  path('extract', views.ExtractData.as_view(), name = 'Extract Data'),
]
