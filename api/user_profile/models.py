from django.db import models

# Create your models here.
class Student(models.Model):
  name = models.CharField(max_length=30, default='')
  entry_no = models.CharField(max_length=30)
  programme = models.CharField(max_length=30)
  branch = models.CharField(max_length=30)
  phone_number = models.CharField(max_length=20)
  address = models.CharField(max_length=100, null = True, blank = True)
  date_of_birth = models.DateField(null = True, blank = True)
  valid_upto = models.DateField(null = True, blank = True)
  emergency_no = models.CharField(max_length=20, default='')
  blood_group = models.CharField(max_length=3, default='', null = True, blank = True)
  profile_image = models.ImageField(upload_to='profile_images/')

  def __str__(self):
    return self.name
