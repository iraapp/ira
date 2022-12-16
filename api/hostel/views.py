from django.core.cache import cache
from authentication.permissions import IsHostelSecretary
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


class HostelComplaintView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, _):
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
    permission_classes = [IsAuthenticated, IsHostelSecretary]

    def put(self, request, *args, **kwargs):
        pk = kwargs.get("pk")
        complaint = HostelComplaint.objects.filter(id=pk).first()
        complaint.status = True
        complaint.save()

        # Invalidate hostel complaints cache.
        cache.delete(CACHE_CONSTANTS['HOSTEL_COMPLAINTS'])
        
        return Response(status=200, data={

            "msg": "feedback action Updated."
        })


class HostelFeedbackView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, _):
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
