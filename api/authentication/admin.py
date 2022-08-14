from django.contrib import admin

from authentication.models import StaffToken, User
from authentication.models import Staff

# Register your models here.
admin.site.register(User)
admin.site.register(Staff)
admin.site.register(StaffToken)
