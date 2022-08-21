
from django.urls import path

from medical import views

"""
url used here
Note : All api url should start with medical/

    1. doctor/ -for  medical manager to add get and update doctor
               -post payload required:
                    1. name - name of doctor
                    2. specialization - specialization of doctor
                    3. mail - mail of doctor
                    4. age - age of doctor
                    5. start_time - timings of doctor
                    6. joined_at - the date doctor joined 
                    7. details - details of doctor
                    8. phone - phone of doctor
                    9 .end_time - end time of doctor
               -get

     2. doctor/<pk> -for  medical manager to get doctor by id
          - get
          - update payload includes same as above
          - delete

     3. staff/ -for  medical manager to add get and update medical staff
               -post payload required:
                    1. name - name of staff
                    2. specialization - specialization of staff
                    3. Phone - phone of staff
     
     4. staff/<pk> -for  medical manager to get staff by id
          - get
          - update payload includes same as above
          - delete
     
     5.  student/doctor/ - for student to get doctor list
          -get

     6.  student/doctor/<pk> - for student to get doctor by id
          -get
     
     7.  student/staff/ - for student to get staff list
          -get
     
     8. student/staff/<pk> - for student to get staff by id
          -get


"""

urlpatterns = [
    path('doctor/', views.AddDoctorView.as_view(), name="dooctor"),
    path('doctor/<int:pk>/', views.DoctorInstanceView.as_view(),
         name="doctor_instance"),
    path('staff/', views.AddStaffView.as_view(), name="staff"),
    path('staff/<int:pk>/', views.StaffInstanceView.as_view(), name="staff_instance"),
    path('student/doctor/', views.StudentDoctorView.as_view(), name="student_doctor"),
    path('student/doctor/<int:pk>/', views.StudentDoctorInstanceView.as_view(),
         name="student_doctor_instance"),
    path('student/staff/', views.StudentStaffView.as_view(), name="student_staff"),
    path('student/staff/<int:pk>/', views.StudentStaffInstanceView.as_view(),
         name="student_staff_instance"),

]
