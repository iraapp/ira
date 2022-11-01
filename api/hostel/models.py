from this import d
from django.db import models

from institute_app import settings

# Create your models here.


class MaintenanceStaffContacts(models.Model):
    name  = models.CharField(max_length=100)
    contact = models.CharField(max_length=20)
    designation = models.CharField(max_length=100)
    start_time = models.TimeField()
    end_time = models.TimeField()
    location = models.CharField(max_length=30)
    created_at = models.TimeField(auto_now=True)

class Hostel(models.Model):
    name = models.CharField(max_length=15, default='')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name

class ComplaintType(models.Model):
    name = models.CharField(max_length=20, default='')

    def __str__(self):
        return self.name

class HostelComplaint(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    body = models.TextField(editable = True, null = False, blank = True)
    hostel = models.ForeignKey(Hostel, on_delete=models.CASCADE, null = True)
    file = models.FileField(upload_to='complaints/', null=True, blank=True)
    created_at = models.DateTimeField(auto_now = True)
    status = models.BooleanField(default = False)
    complaint_type = models.ForeignKey(ComplaintType, on_delete=models.CASCADE, null = True)

class HostelFeedback(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    body = models.TextField(editable = True, null = False, blank = True)
    hostel = models.ForeignKey(Hostel, on_delete=models.CASCADE, null = True)
    created_at = models.DateTimeField(auto_now = True)
