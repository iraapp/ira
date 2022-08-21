from django.db import models

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
