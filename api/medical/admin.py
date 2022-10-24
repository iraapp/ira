from django.contrib import admin

from medical.models import Doctor, Staff, Appointment, MedicalHistory

# Register your models here.
admin.site.register(Doctor)
admin.site.register(Staff)
admin.site.register(Appointment)
admin.site.register(MedicalHistory)
