from timetable.serializers import *
from timetable.models import *
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from authentication.permissions import IsMessManager


class StudentTimetableView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        user = request.user
        timetable = Timetable.objects.filter(user=user).first()
        if timetable:
            data = TimetableSerializer(timetable).data
            return Response(data=data)
        else:
            return Response(status=404, data={
                "msg": "Timetable not found."
            })


class StudentSlotView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        user = request.user
        timetable = Slot.objects.filter(user=user).first()
        if timetable:
            data = SlotSerializer(timetable.slot_set.all(), many=True).data
            return Response(data=data)
        else:
            return Response(status=404, data={
                "msg": "Slot not found."
            })


class StudentDayView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        user = request.user
        timetable = Day.objects.filter(user=user).first()
        if timetable:
            data = DaySerializer(timetable.day_set.all(), many=True).data
            return Response(data=data)
        else:
            return Response(status=404, data={
                "msg": "Day not found."
            })


class StudentCourseView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        user = request.user
        timetable = Course.objects.filter(user=user).first()
        if timetable:
            data = CourseSerializer(timetable.course_set.all(), many=True).data
            return Response(data=data)
        else:
            return Response(status=404, data={
                "msg": "Course not found."
            })
