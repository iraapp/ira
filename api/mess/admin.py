from django.contrib import admin

from mess.models import MenuItem, MenuSlot, Mess, WeekDay

# Register your models here.

admin.site.register(WeekDay)
admin.site.register(MenuSlot)
admin.site.register(MenuItem)
admin.site.register(Mess)
