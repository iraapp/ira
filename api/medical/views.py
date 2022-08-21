from authentication.permissions import IsMedicalManager
from medical.serializers import *
from medical.models import *
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response


# views for medical manager
class AddDoctorView(APIView):
    permission_classes = (IsMedicalManager,)

    def post(self, request):
        name = request.POST.get("name", None)
        phone = request.POST.get("phone", None)
        specialization = request.POST.get("specialization", None)
        joined_at = request.POST.get("joined_at", None)
        start_time = request.POST.get("start_time", None)
        end_time = request.POST.get("end_time", None)
        mail = request.POST.get("mail", None)
        age = request.POST.get("age", None)
        details = request.POST.get("details", None)
        instance = Doctor.objects.create(
            name=name,
            phone=phone,
            specialization=specialization,
            joined_at=joined_at,
            start_time=start_time,
            end_time=end_time,
            age=age,
            details=details,
            mail=mail
        )
        instance.save()
        serinstance = DoctorSerializer(instance)
        return Response(serinstance.data)

    def get(self, request):
        doctors = Doctor.objects.all()
        serializer = DoctorSerializer(doctors, many=True)
        return Response(serializer.data)


class AddStaffView(APIView):
    permission_classes = (IsMedicalManager,)

    def post(self, request):
        name = request.POST.get("name", None)
        phone = request.POST.get("phone", None)
        specialization = request.POST.get("specialization", None)
        instance = Staff.objects.create(
            name=name,
            phone=phone,
            specialization=specialization
        )
        instance.save()
        serinstance = StaffSerializer(instance)
        return Response(serinstance.data)

    def get(self, request):
        staffs = Staff.objects.all()
        serializer = StaffSerializer(staffs, many=True)
        return Response(serializer.data)


class DoctorInstanceView(APIView):
    permission_classes = (IsMedicalManager,)

    def get(self, request, *args, **kwargs):
        pk = kwargs.get("pk")
        data = Doctor.objects.filter(id=pk).first()
        serialized_json = DoctorSerializer(data)
        return Response(data=serialized_json.data)

    def update(self, request, *args, **kwargs):
        pk = kwargs.get("pk")
        data = Doctor.objects.filter(id=pk).first()
        name = request.POST.get("name", None)
        phone = request.POST.get("phone", None)
        specialization = request.POST.get("specialization", None)
        joined_at = request.POST.get("joined_at", None)
        start_time = request.POST.get("start_time", None)
        end_time = request.POST.get("end_time", None)
        mail = request.POST.get("mail", None)
        age = request.POST.get("age", None)
        details = request.POST.get("details", None)
        data.name = name
        data.phone = phone
        data.specialization = specialization
        data.joined_at = joined_at
        data.start_time = start_time
        data.end_time = end_time
        data.age = age
        data.details = details
        data.mail = mail
        data.save()
        serinstance = DoctorSerializer(data)
        return Response(serinstance.data)

    def delete(self, request, *args, **kwargs):
        pk = kwargs.get("pk")
        data = Doctor.objects.filter(id=pk).first()
        data.delete()
        return Response(status=204)


class StaffInstanceView(APIView):
    permission_classes = (IsMedicalManager,)

    def get(self, request, *args, **kwargs):
        pk = kwargs.get("pk")
        data = Staff.objects.filter(id=pk).first()
        serialized_json = StaffSerializer(data)
        return Response(data=serialized_json.data)

    def update(self, request, *args, **kwargs):
        pk = kwargs.get("pk")
        data = Staff.objects.filter(id=pk).first()
        name = request.POST.get("name", None)
        phone = request.POST.get("phone", None)
        specialization = request.POST.get("specialization", None)
        data.name = name
        data.phone = phone
        data.specialization = specialization
        data.save()
        serinstance = StaffSerializer(data)
        return Response(serinstance.data)

    def delete(self, request, *args, **kwargs):
        pk = kwargs.get("pk")
        data = Staff.objects.filter(id=pk).first()
        data.delete()
        return Response(status=204)


# views for student access
class StudentDoctorView(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request):
        doctors = Doctor.objects.all()
        serializer = DoctorSerializer(doctors, many=True)
        return Response(serializer.data)


class StudentStaffView(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request):
        staffs = Staff.objects.all()
        serializer = StaffSerializer(staffs, many=True)
        return Response(serializer.data)


class StudentDoctorInstanceView(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request, *args, **kwargs):
        pk = kwargs.get("pk")
        data = Doctor.objects.filter(id=pk).first()
        serialized_json = DoctorSerializer(data)
        return Response(data=serialized_json.data)


class StudentStaffInstanceView(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request, *args, **kwargs):
        pk = kwargs.get("pk")
        data = Staff.objects.filter(id=pk).first()
        serialized_json = StaffSerializer(data)
        return Response(data=serialized_json.data)
