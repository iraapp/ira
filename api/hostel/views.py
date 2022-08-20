from hostel.serializers import ComplaintTypeSerializer, HostelFeedbackSerializer, HostelSerializer, MaintenanceStaffContactsSer
from hostel.models import ComplaintType, Hostel, HostelFeedback, MaintenanceStaffContacts
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
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
        hostel = request.POST.get('hostel')
        complaint_type = request.POST.get('complaint_type')

        hostel = Hostel.objects.filter(name=hostel).first()
        complaint_type = ComplaintType.objects.filter(
            name=complaint_type).first()

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

class HostelAndComplaintListView(APIView):
    permission_classes = []

    def get(self, request):
        data = Hostel.objects.all()
        complaint_types = ComplaintType.objects.all()

        return Response(data = {
            'hostel': HostelSerializer(data, many=True).data,
            'complaints': ComplaintTypeSerializer(complaint_types, many=True).data
            })
