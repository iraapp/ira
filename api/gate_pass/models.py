from re import T
from tokenize import blank_re
from django.db import models

from institute_app import settings
# Create your models here.
class GatePass(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    purpose = models.TextField(editable = True, null = False, blank = True)
    out_time_stamp = models.DateTimeField(blank = True, editable = True, null = True)
    in_time_stamp = models.DateTimeField(blank = True, editable = True, null = True)
    created_at = models.DateTimeField(auto_now = True)
    completed_status = models.BooleanField(default = False)
    status = models.BooleanField(default = False)






