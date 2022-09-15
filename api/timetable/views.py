from timetable.serializers import *
from timetable.models import *
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from authentication.permissions import IsMessManager


class StudentTimetableView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):

        timetable = Timetable.objects.all()
        if timetable:
            data = TimetableSerializer(timetable).data
            return Response(data=data)
        else:
            return Response(status=404, data={
                "msg": "Timetable not found."
            })


class StudentTimetableInstanceView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        timetable_id = kwargs.get("pk")
        timetable = Timetable.objects.filter(id=timetable_id).first()
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
        SlotInstance = Slot.objects.all()
        if SlotInstance:
            data = SlotSerializer(SlotInstance, many=True).data
            return Response(data=data)
        else:
            return Response(status=404, data={
                "msg": "Slot not found."
            })


class StudentSlotInstanceView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        user = request.user
        slot_id = kwargs.get("pk")
        SlotInstance = Slot.objects.filter(id=slot_id).first()
        if SlotInstance:
            data = SlotSerializer(SlotInstance).data
            return Response(data=data)
        else:
            return Response(status=404, data={
                "msg": "Slot not found."
            })


class StudentDayView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        user = request.user
        DayInstance = Day.objects.filter.all()
        if DayInstance:
            data = DaySerializer(DayInstance, many=True).data
            return Response(data=data)
        else:
            return Response(status=404, data={
                "msg": "Day not found."
            })


class StudentDayInstanceView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        user = request.user
        day_id = kwargs.get("pk")
        DayInstance = Day.objects.filter(id=day_id).first()
        if DayInstance:
            data = DaySerializer(DayInstance).data
            return Response(data=data)
        else:
            return Response(status=404, data={
                "msg": "Day not found."
            })


class StudentCourseView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        CourseInstance = Course.objects.all()
        if CourseInstance:
            data = CourseSerializer(CourseInstance, many=True).data
            return Response(data=data)
        else:
            return Response(status=404, data={
                "msg": "Course not found."
            })


class StudentCourseInstanceView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        course_id = kwargs.get("pk")
        CourseInstance = Course.objects.filter(id=course_id).first()
        if CourseInstance:
            data = CourseSerializer(CourseInstance).data
            return Response(data=data)
        else:
            return Response(status=404, data={
                "msg": "Course not found."
            })

# cr timetables views


class TimeTableView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        timetable = Timetable.objects.all()
        if timetable:
            data = TimetableSerializer(timetable).data
            return Response(data=data)
        else:
            return Response(status=404, data={
                "msg": "Timetable not found."
            })

    def post(self, request, *args, **kwargs):
        user = request.user

        timetable = request.POST.get("timetable")
        Timetable.objects.create(
            user=user,

        )
        timetable.save()
        return Response(status=200, data={
            "msg": "Timetable created successfully."
        })


class SlotView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        SlotInstance = Slot.objects.all()
        if SlotInstance:
            data = SlotSerializer(SlotInstance, many=True).data
            return Response(data=data)
        else:
            return Response(status=404, data={
                "msg": "Slot not found."
            })

    def post(self, request, *args, **kwargs):
        user = request.user
        serial = request.POST.get("serial")
        start = request.POST.get("start")
        end = request.POST.get("end")
        timetable = request.POST.get("timetable")
        TimetableInstance = Timetable.objects.filter(id=timetable).first()
        Slot.objects.create(
            user=user,
            serial=serial,
            start=start,
            end=end,
            timetable=TimetableInstance
        )
        return Response(status=200, data={
            "msg": "Slot created successfully."
        })

    def put(self, request, *args, **kwargs):
        user = request.user
        slot_id = request.POST.get("pk")

        SlotInstance = Slot.objects.filter(id=slot_id).first()
        if SlotInstance:
            serial = request.POST.get("serial")
            start = request.POST.get("start")
            end = request.POST.get("end")
            SlotInstance.serial = serial
            SlotInstance.start = start
            SlotInstance.end = end
            SlotInstance.save()
            return Response(status=200, data={
                "msg": "Slot updated successfully."
            })
        else:
            return Response(status=404, data={
                "msg": "Slot not found."
            })

    def delete(self, request, *args, **kwargs):
        slot_id = request.POST.get("pk")
        SlotInstance = Slot.objects.filter(id=slot_id).first()
        if SlotInstance:
            SlotInstance.delete()
            return Response(status=200, data={
                "msg": "Slot deleted successfully."
            })
        else:
            return Response(status=404, data={
                "msg": "Slot not found."
            })


class DayView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        DayInstance = Day.objects.all()
        if DayInstance:
            data = DaySerializer(DayInstance, many=True).data
            return Response(data=data)
        else:
            return Response(status=404, data={
                "msg": "Day not found."
            })

    def post(self, request, *args, **kwargs):
        user = request.user
        day = request.POST.get("day")
        timetable = request.POST.get("timetable")
        TimetableInstance = Timetable.objects.filter(id=timetable).first()

        Day.objects.create(
            user=user,
            day=day
        )
        TimetableInstance.day.add(Day)
        return Response(status=200, data={
            "msg": "Day created successfully."
        })

    def delete(self, request, *args, **kwargs):
        day = request.POST.get("day")
        dayInstance = Day.objects.filter(day=day).first()
        timetable = request.POST.get("timetable")
        TimetableInstance = Timetable.objects.filter(id=timetable).first()
        TimetableInstance.day.remove(dayInstance)
        return Response(status=200, data={
            "msg": "Day deleted successfully."
        })


class CourseView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        CourseInstance = Course.objects.all()
        if CourseInstance:
            data = CourseSerializer(CourseInstance, many=True).data
            return Response(data=data)
        else:
            return Response(status=404, data={
                "msg": "Course not found."
            })

    def post(self, request, *args, **kwargs):
        user = request.user
        name = request.POST.get("name")
        code = request.POST.get("code")
        credit = request.POST.get("credit")
        faculty = request.POST.get("faculty")
        slot = request.POST.get("slot")
        SlotInstance = Slot.objects.filter(id=slot).first()
        serial = request.POST.get("serial")

        Course.objects.create(
            user=user,
            name=name,
            code=code,
            credit=credit,
            faculty=faculty,
            slot=SlotInstance,
            serial=serial

        )
        return Response(status=200, data={
            "msg": "Course created successfully."
        })

    def put(self, request, *args, **kwargs):
        user = request.user
        course_id = request.POST.get("pk")
        CourseInstance = Course.objects.filter(id=course_id).first()
        if CourseInstance:
            name = request.POST.get("name")
            code = request.POST.get("code")
            credit = request.POST.get("credit")
            faculty = request.POST.get("faculty")
            slot = request.POST.get("slot")
            SlotInstance = Slot.objects.filter(id=slot).first()
            serial = request.POST.get("serial")
            
            user = user
            CourseInstance.name = name
            CourseInstance.code = code
            CourseInstance.credit = credit
            CourseInstance.faculty = faculty
            CourseInstance.slot = SlotInstance
            CourseInstance.serial = serial
            CourseInstance.save()
            return Response(status=200, data={
                "msg": "Course updated successfully."
            })
        else:
            return Response(status=404, data={
                "msg": "Course not found."
            })
