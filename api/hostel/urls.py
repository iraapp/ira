
from django.urls import path

from hostel import views

"""
url used here
        1 . maintenance/contact
                        - Get - get all maintenance staff contacts instance
                        - Post - Add a new instance 
                                - payload {name,contact,designation}

        2 . maintenance/contact/<int:pk>
                        - Get - get an instance using pk(primary key)
                        - Post - Update an already existing model using pk(primary key)
                                - payload {name,contact,designation}
                        - Delete - delete an instance using pk(primary key)

"""

urlpatterns = [
    path('maintenance/contact', views.MaintenanceStaffContactsView.as_view(), name="Maintenance staff contact items"),
    path('maintenance/contact/<int:pk>', views.MaintenanceStaffContactsInstanceView.as_view(), name="Maintenance staff contact instance items"),

    
]
