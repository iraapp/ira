from django.db import models

# Create your models here.


class MaintenanceStaffContacts(models.Model):
    name  = models.CharField(max_length=100)
    contact = models.CharField(max_length=10)
    designation = models.CharField(max_length=100)
    created_at = models.TimeField(auto_now=True)


