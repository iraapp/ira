import os
from django.db import models
from institute_app import settings

class Document(models.Model):
  file = models.FileField('Document', upload_to='mydocs/')

  @property
  def filename(self):
     name = self.file.name.split("/")[1].replace('_',' ').replace('-',' ')
     return name

  def extension(self):
    name, extension = os.path.splitext(self.file.name)
    return extension

  def __str__(self):
    return self.filename

class Post(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL,
                             on_delete=models.CASCADE)
    body = models.TextField()
    attachments = models.ManyToManyField(Document)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)