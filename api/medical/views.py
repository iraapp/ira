from authentication.permissions import IsMedicalManager
from medical.serializers import *
from medical.models import *
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from authentication.models import User

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

    def put(self, request, *args, **kwargs):
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

    def put(self, request, *args, **kwargs):
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


class AppointmentView(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        doctor = request.POST.get("doctor", None)
        doctorinstance = Doctor.objects.filter(id=doctor).first()
        user = request.user
        instance = Appointment.objects.create(
            doctor=doctorinstance,
            patient=user
        )
        instance.save()
        return Response(AppointmentSerializer(instance).data)

    def get(self, request):
        user = request.user
        appointments = Appointment.objects.filter(patient=user)
        serializer = AppointmentSerializer(appointments, many=True)
        return Response(serializer.data)


class DoctorAppointmentView(APIView):
    permission_classes = (IsMedicalManager,)

    def get(self, request):
        doctor = request.user
        appointments = Appointment.objects.filter(doctor=doctor)
        serializer = AppointmentSerializer(appointments, many=True)
        return Response(serializer.data)

    def post(self, request):
        id = request.POST.get("id", None)
        status = request.POST.get("status", None)
        appointment = Appointment.objects.filter(id=id).first()
        if status == APPOINTMENT_STATUS["APPROVED"]:
            date = request.POST.get("date", None)
            time = request.POST.get("time", None)
            appointment.date = date
            appointment.time = time
            appointment.status = APPOINTMENT_STATUS["APPROVED"]
        else:
            reason = request.POST.get("reason", None)
            appointment.reason = reason
            appointment.status = APPOINTMENT_STATUS["REJECTED"]
        appointment.save()
        serinstance = AppointmentSerializer(appointment)
        return Response(serinstance.data)


class MedicalHistoryView(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request):
        user = request.user
        history = MedicalHistory.objects.filter(patient=user)
        serializer = MedicalHistorySerializer(history, many=True)
        return Response(serializer.data)

    def post(self, request):
        patient = request.POST.get("patient", None)
        patientinstance = User.objects.filter(id=patient).first()
        doctor = request.POST.get("doctor", None)
        doctorinstance = User.objects.filter(id=doctor).first()
        details = request.POST.get("details", None)
        date = request.POST.get("date", None)
        instance = MedicalHistory.objects.create(
            patient=patientinstance,
            date=date,
            doctor=doctorinstance,
            details=details
        )
        instance.save()
        serinstance = MedicalHistorySerializer(instance)
        return Response(serinstance.data)
