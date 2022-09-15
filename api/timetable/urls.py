from django.urls import path
from timetable.views import *


urlpatterns = [
    path('timetable', StudentTimetableView.as_view(), name="Timetable"),
    path("slot", StudentSlotView.as_view(), name="Slot"),
    path("day", StudentDayView.as_view(), name="Day"),
    path("course", StudentCourseView.as_view(), name="Course"),
]
