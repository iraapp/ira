from django.core.cache import cache
from constants import CACHE_CONSTANTS, CACHE_EXPIRY
from hostel.serializers import ComplaintTypeSerializer, HostelComplaintSerializer, HostelFeedbackSerializer, HostelSerializer, MaintenanceStaffContactsSer
from hostel.models import ComplaintType, Hostel, HostelComplaint, HostelFeedback, MaintenanceStaffContacts
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

class MaintenanceStaffContactsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, _):
        cached_contacts = cache.get(CACHE_CONSTANTS['MAINTENANCE_STAFF_CACHE'])

        if cached_contacts:
            return Response(data = cached_contacts)

        data = MaintenanceStaffContacts.objects.all()
        serialized_json = MaintenanceStaffContactsSer(data, many=True)

        # Cache feed data in the memory as it is frequently requested
        # This results in significant reduction in server response time.
        cache.set(CACHE_CONSTANTS['MAINTENANCE_STAFF_CACHE'], serialized_json.data, CACHE_EXPIRY)

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

        # Invalidate maintenance staff cache.
        cache.delete(CACHE_CONSTANTS['MAINTENANCE_STAFF_CACHE'])

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

class HostelComplaintView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        cached_complaints = cache.get(CACHE_CONSTANTS['HOSTEL_COMPLAINTS'])

        if cached_complaints:
            return Response(data = cached_complaints)

        data = HostelComplaint.objects.all()
        serialized_json = HostelComplaintSerializer(data, many=True)

        cache.set(CACHE_CONSTANTS['HOSTEL_COMPLAINTS'], serialized_json.data, CACHE_EXPIRY)

        return Response(data=serialized_json.data)

    def post(self, request):
        user = request.user
        body = request.POST.get('feedback')
        hostel = request.POST.get('hostel')
        complaint_type = request.POST.get('complaint_type')
        file = request.FILES.get("file")

        hostel = Hostel.objects.filter(name=hostel).first()
        complaint_type = ComplaintType.objects.filter(name = complaint_type).first()

        HostelComplaint.objects.create(
            user = user,
            body = body,
            hostel = hostel,
            complaint_type = complaint_type,
            file=file
        )

        cache.delete(CACHE_CONSTANTS['HOSTEL_COMPLAINTS'])

        return Response(data={'msg': 'success'}, status=200)

class HostelComplaintActionView(APIView):
    permission_classes = [IsAuthenticated, ]

    def put(self, request, *args, **kwargs):
        pk = kwargs.get("pk")
        complaint = HostelComplaint.objects.filter(id=pk).first()
        complaint.status = True
        complaint.save()
        return Response(status=200, data={

            "msg": "feedback action Updated."
        })


class HostelFeedbackView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        cached_feedback = cache.get(CACHE_CONSTANTS['HOSTEL_FEEDBACKS'])

        if cached_feedback:
            return Response(data = cached_feedback)

        data = HostelFeedback.objects.all()
        serialized_json = HostelFeedbackSerializer(data, many=True)

        cache.set(CACHE_CONSTANTS['HOSTEL_FEEDBACKS'], serialized_json.data, CACHE_EXPIRY)

        return Response(data=serialized_json.data)

    def post(self, request):
        user = request.user
        body = request.POST.get('feedback')
        hostel = request.POST.get('hostel')

        hostel = Hostel.objects.filter(name=hostel).first()

        HostelFeedback.objects.create(
            user = user,
            body = body,
            hostel = hostel
        )

        # Invalidate hostel feedback cache.
        cache.delete(CACHE_CONSTANTS['HOSTEL_FEEDBACKS'])

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
    permission_classes = [IsAuthenticated]

    def get(self, _):
        cached_data = cache.get(CACHE_CONSTANTS['HOSTEL_COMPLAINT_CACHE'])

        if cached_data:
            return Response(data = cached_data)

        data = Hostel.objects.all()
        complaint_types = ComplaintType.objects.all()

        response_data = {
            'hostel': HostelSerializer(data, many=True).data,
            'complaints': ComplaintTypeSerializer(complaint_types, many=True).data
        }

        cache.set(CACHE_CONSTANTS['HOSTEL_COMPLAINT_CACHE'], response_data, CACHE_EXPIRY)

        return Response(data = response_data)
