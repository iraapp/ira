from django.db import models

class Member(models.Model):
  name = models.CharField(max_length=30, default='')
  designation = models.CharField(max_length=30, default='')
  profile = models.ImageField(upload_to='team')
  linkedIn_url = models.URLField(max_length = 200)
  github_url = models.URLField(max_length = 200)

  def __str__(self):
    return self.name
