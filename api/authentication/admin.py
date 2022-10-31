from django.contrib import admin

from authentication.models import StaffToken, User, UserToken
from authentication.models import Staff

# Register your models here.
admin.site.register(User)
admin.site.register(UserToken)
admin.site.register(Staff)
admin.site.register(StaffToken)
