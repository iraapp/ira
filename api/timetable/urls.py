from django.urls import path
from timetable.views import *


urlpatterns = [
    path('student/timetable', StudentTimetableView.as_view(), name="Timetable"),
    path("student/slot", StudentSlotView.as_view(), name="Slot"),
    path("student/day", StudentDayView.as_view(), name="Day"),
    path("student/course", StudentCourseView.as_view(), name="Course"),
    path("student/timetable/<int:pk>",
         StudentTimetableInstanceView.as_view(), name="TimetableInstance"),
    path("student/slot/<int:pk>",
         StudentSlotInstanceView.as_view(), name="SlotInstance"),
    path("student/day/<int:pk>",
         StudentDayInstanceView.as_view(), name="DayInstance"),
    path("student/course/<int:pk>",
         StudentCourseInstanceView.as_view(), name="CourseInstance"),
    path("timetable", TimeTableView.as_view(), name="TimetableSlot"),
    path("slot", SlotView.as_view(), name="Slot"),
    path("day", DayView.as_view(), name="Day"),
    path("course", CourseView.as_view(), name="Course"),

]
