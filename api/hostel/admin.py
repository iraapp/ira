from django.contrib import admin
from hostel.models import ComplaintType, HostelFeedback, Hostel, MaintenanceStaffContacts

# Register your models here.
admin.site.register(MaintenanceStaffContacts)
admin.site.register(Hostel)
admin.site.register(ComplaintType)
admin.site.register(HostelFeedback)
