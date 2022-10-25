from django.contrib import admin
from mess.models import MenuItem, MessComplaint, MenuSlot, Mess, MessFeedback, MessMenu, MessMom, MessTender, WeekDay

# Register your models here.

admin.site.register(WeekDay)
admin.site.register(MenuSlot)
admin.site.register(MenuItem)
admin.site.register(Mess)
admin.site.register(MessFeedback)
admin.site.register(MessMom)
admin.site.register(MessTender)
admin.site.register(MessMenu)
admin.site.register(MessComplaint)
