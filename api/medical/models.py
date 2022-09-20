from django.db import models
from institute_app import settings

# Create your models here.
APPOINTMENT_STATUS = {
    'REJECTED': 0,
    'IN_PROGRESS': 1,
    'APPROVED': 2
}


class Doctor(models.Model):
    name = models.CharField(max_length=50)
    phone = models.CharField(max_length=50)
    specialization = models.CharField(max_length=50)
    created_at = models.DateTimeField(auto_now_add=True)
    joined_at = models.DateField()
    start_time = models.TimeField(null=True)
    end_time = models.TimeField(null=True)
    date = models.DateField()
    mail = models.EmailField(max_length=100)
    details = models.CharField(max_length=50, null=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name


class Staff(models.Model):
    name = models.CharField(max_length=50)
    phone = models.CharField(max_length=50)
    designation = models.CharField(max_length=50)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name


class Appointment(models.Model):

    IN_PROGRESS = "IN PROGRESS"
    REJECTED = "REJECTED"
    ACCEPTED = "ACCEPTED"

    APPOINTMENT_STATUS = (
        (IN_PROGRESS, 'In progress'),
        (REJECTED, 'Rejected'),
        (ACCEPTED, 'Accepted')

    )

    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE)
    patient = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    date = models.DateField(null=True)
    time = models.TimeField(null=True)
    start_time = models.TimeField(null = True)
    end_time = models.TimeField(null = True)
    status = models.CharField(choices=APPOINTMENT_STATUS, default="IN PROGRESS", max_length=30)
    reason = models.CharField(max_length=50, default="", null=True)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)


class MedicalHistory(models.Model):
    patient = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE)
    date = models.DateField(null=True)
    time = models.TimeField(null=True)
    date = models.DateField(null=True)
    inhouse = models.BooleanField(default=False)
    diagnosis = models.CharField(max_length=50, null=True)
    treatment = models.CharField(max_length=50, null=True)
    details = models.CharField(max_length=500, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
