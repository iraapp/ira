from hostel.serializers import HostelFeedbackSerializer, MaintenanceStaffContactsSer
from hostel.models import ComplaintType, Hostel, HostelFeedback, MaintenanceStaffContacts
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

class MaintenanceStaffContactsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self):
        data = MaintenanceStaffContacts.objects.all()
        serialized_json = MaintenanceStaffContactsSer(data, many=True)
        return Response(data=serialized_json.data)

    def post(self, request):
        name = request.POST.get("name")
        contact = request.POST.get("contact")
        designation = request.POST.get("designation")
        MaintenanceStaffContacts.objects.create(
            name=name,
            contact=contact,
            designation=designation
        )

        return Response(status=200, data={
            "msg": "Contact added successfully."
        })

class MaintenanceStaffContactsInstanceView(APIView):
    permission_classes = [IsAuthenticated]

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
        MaintenanceStaffContacts.objects.filter(id=contact_id).update(
            name=name,
            contact=contact,
            designation=designation
        )
        return Response(status=200, data={
            "msg": "Contact updated successfully."
        })

    def delete(self, request, *args, **kwargs):
        contact_id = kwargs.get("pk")
        MaintenanceStaffContacts.objects.filter(id=contact_id).delete()
        return Response(status=200, data={
            "msg": "Contact deleted successfully."
        })

class HostelFeedbackView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        data = HostelFeedback.objects.all()
        serialized_json = HostelFeedbackSerializer(data, many=True)

        return Response(data=serialized_json.data)

    def post(self, request):
        user = request.user
        body = request.POST.get('feedback')
        hostel_id = request.POST.get('hostel_id')
        complaint_type_id = request.POST.get('complaint_type_id')

        hostel = Hostel.objects.filter(id=hostel_id).first()
        complaint_type = ComplaintType.objects.filter(
            id=complaint_type_id).first()

        HostelFeedback.objects.create(
            user = user,
            body = body,
            hostel = hostel,
            complaint_type = complaint_type
        )

        return Response(data={'msg': 'success'}, status=200)


class HostelFeedbackInstanceView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, pk):
        data = HostelFeedback.objects.filter(id=pk).first()
        if data:
            serialized_json = HostelFeedbackSerializer(data)
            return Response(data=serialized_json.data)
        return Response(data={'msg': 'not found'}, status=404)
