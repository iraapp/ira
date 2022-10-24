from django.contrib import admin
from gate_pass.models import GatePass
# Register your models here.


# admin.site.unregister(GatePass)
class gatePassTable(admin.ModelAdmin):
    list_display = (
        'user', 'purpose', 'out_time_stamp', 'in_time_stamp',
        'created_at', 'completed_status', 'status')


admin.site.register(GatePass, gatePassTable)
