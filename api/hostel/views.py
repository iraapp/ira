import json
from hostel.ser import *
from hostel.models import *
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response



class MaintenanceStaffContactsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        data = MaintenanceStaffContacts.objects.all()
        serialized_json = MaintenanceStaffContactsSer(data, many=True)
        return Response(data=serialized_json.data)

    def post(self, request):
        name = request.POST.get("name")
        contact = request.POST.get("contact")
        designation = request.POST.get("designation")
        instance = MaintenanceStaffContacts.objects.create(
            name=name,
            contact=contact,
            designation=designation
        )
        return Response(status=200, data={
            "msg": "Contact added successfully."
        })
class MaintenanceStaffContactsInstanceView(APIView):
    def get(self, request, *args, **kwargs):
        contact_id = kwargs.get("pk")
        data = MaintenanceStaffContacts.objects.filter(id=contact_id).first()
        serialized_json = MaintenanceStaffContactsSer(data)
        return Response(data=serialized_json.data)
    def post(self, request, *args, **kwargs):
        contact_id = kwargs.get("pk")
        name = request.POST.get("name")
        contact = request.POST.get("contact")
        designation = request.POST.get("designation")
        instance = MaintenanceStaffContacts.objects.filter(id=contact_id).update(
            name=name,
            contact=contact,
            designation=designation
        )
        return Response(status=200, data={
            "msg": "Contact updated successfully."
        })
    def delete(self, request, *args, **kwargs):
        contact_id = kwargs.get("pk")
        instance = MaintenanceStaffContacts.objects.filter(id=contact_id).delete()
        return Response(status=200, data={
            "msg": "Contact deleted successfully."
        })