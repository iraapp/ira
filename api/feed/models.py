from datetime import datetime
import os
from django.db import models
from institute_app import settings
# Create your models here.

class Document(models.Model):
  file = models.FileField('Document', upload_to='mydocs/')

  @property
  def filename(self):
     name = self.file.name.split("/")[1].replace('_',' ').replace('-',' ')
     return name

  def extension(self):
    name, extension = os.path.splitext(self.file.name)
    return extension


class Post(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL,
                             on_delete=models.CASCADE)
    body = models.TextField()
    attachments = models.ManyToManyField(Document)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)