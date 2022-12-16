
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

     9. appointment/ - for student to book appointment
          -post payload required:
               1. doctor - doctor id

          -get: returns all the appointment of student

     10. doctor/appointment/ - for doctor to view or update his appointments
          -get: returns all the appointment of doctor
          -post: payload required:
               1. id - appointment id
               2. accepted - true or false
                  if accepted payload:
                    1. date - date of appointment
                    2. time - time of appointment
                  if rejected payload:
                    1. reason - reason for rejection

     11. medicalhistory/ - to add medical history
          -post: payload required:
               1. doctor - doctor id
               2. details - details of medical history
               3. date - date of medical history
               4. time - time of medical history
               5. prescription - prescription of medical history
               6. patient - patient email
               7. inhouse - true or false
          -get: returns all the medical history of student

"""

urlpatterns = [
    path('student/doctor/', views.StudentDoctorView.as_view(), name="student_doctor"),
    path('student/staff/', views.StudentStaffView.as_view(), name="student_staff"),
    path('appointment/', views.AppointmentView.as_view(), name="appointment"),
    path('medicalhistory/', views.MedicalHistoryView.as_view(), name="medical_history"),
    path("search/doctor", views.SearchDoctors.as_view(), name="search_doctor"),
    path("search/patient", views.SearchPatient.as_view(), name="search_patient"),
    path('manager/medicalhistory/', views.MedicalHistoryManagerView.as_view(), name="medical_manager_history"),
    path('manager/staff', views.ManagerStaffView.as_view()),
    path('manager/staff/delete', views.ManagerStaffDelete.as_view()),
    path('manager/doctor/', views.ManagerDoctorView.as_view(), name="student_doctor"),
    path('manager/doctor/update', views.UpdateDoctorView.as_view()),
    path('manager/appointments', views.AppointmentManagerView.as_view()),
    path('manager/appointments/pending', views.AppointmentsPending.as_view(),),
    path('manager/appointment/confirm', views.AppointmentManagerConfirm.as_view()),
    path('manager/appointment/reject', views.AppointmentManagerReject.as_view()),
]
