from institute_app import settings
from django.db import models

class MenuItem(models.Model):
  name = models.CharField(max_length=30, default='')
  created_at = models.DateTimeField(auto_now_add=True)
  updated_at = models.DateTimeField(auto_now=True)

  def __str__(self):
        return self.name

class MenuSlot(models.Model):
  name = models.CharField(max_length=15, default='')
  items = models.ManyToManyField(MenuItem)
  start_time = models.TimeField()
  end_time = models.TimeField()
  created_at = models.DateTimeField(auto_now_add=True)
  updated_at = models.DateTimeField(auto_now=True)

  def __str__(self):
        name = ''
        for item in self.items.all():
          name += item.name + ' | '
        return self.name + ' | ' + name

class WeekDay(models.Model):
  name = models.CharField(max_length=15, default='')
  slots = models.ManyToManyField(MenuSlot)
  created_at = models.DateTimeField(auto_now_add=True)
  updated_at = models.DateTimeField(auto_now=True)

  def __str__(self):
        return self.name

class Mess(models.Model):
  name = models.CharField(max_length=15, default='')
  week_days = models.ManyToManyField(WeekDay)
  created_at = models.DateTimeField(auto_now_add=True)
  updated_at = models.DateTimeField(auto_now=True)


# data base model for feedback
class Feedback(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    body = models.TextField(editable = True, null = False, blank = True)
    mess_no = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now = True)
    status = models.BooleanField(default = False)

# data base model for mess mom
class MessMom(models.Model):
    date = models.DateField( default=None, null=True)
    file = models.FileField(upload_to = 'mom/')
    title = models.CharField(max_length = 100)
    description = models.TextField()
    created_at = models.DateTimeField(auto_now = True)

# data base model for mess tender
class MessTender(models.Model):
    date = models.DateField(default=None, null=True)
    contractor  = models.CharField(max_length = 100)
    file = models.FileField(upload_to = 'tender/')
    title = models.CharField(max_length = 100)
    description = models.TextField(null=True)
    created_at = models.DateTimeField(auto_now = True)