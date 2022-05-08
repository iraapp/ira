
from django.urls import path
from gate_pass import views

urlpatterns = [
  path('', views.Testing.as_view(), name="testing"),
  path('studentStatus', views.StudentGatepassStatus.as_view(), name="testing"),
  path('guard_gatepass_handler', views.Guard_Ping_1.as_view(), name="gurad_gatepass_handler"),
  path('generate_qr', views.GenerateQR.as_view(), name="Generate QR"),
  path('delete_qr', views.DeleteQR.as_view(), name="Delete QR")
]
