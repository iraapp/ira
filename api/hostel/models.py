from django.db import models

# Create your models here.


class MaintenanceStaffContacts(models.Model):
    name  = models.CharField(max_length=100)
    contact = models.CharField(max_length=20)
    designation = models.CharField(max_length=100)
    start_time = models.TimeField()
    end_time = models.TimeField()
    location = models.CharField(max_length=30)
    created_at = models.TimeField(auto_now=True)


