from django.db import models
from institute_app import settings

# Create your models here.


class Doctor(models.Model):
    name = models.CharField(max_length=50)
    phone = models.CharField(max_length=50)
    specialization = models.CharField(max_length=50)
    created_at = models.DateTimeField(auto_now_add=True)
    joined_at = models.DateField()
    age = models.IntegerField()
    start_time = models.TimeField(null=True)
    end_time = models.TimeField(null=True)
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
    STATUS = (
        (1, 'in process'),
        (2, 'accepted'),
        (3, 'rejected'),
    )

    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE)
    patient = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    date = models.DateField(null=True)
    time = models.TimeField(null=True)
    status = models.PositiveSmallIntegerField(choices=STATUS, default=1)
    reason = models.CharField(max_length=500, null=True)
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
    prescription = models.CharField(max_length=500, null=True)
    details = models.CharField(max_length=500, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
