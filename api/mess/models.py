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
