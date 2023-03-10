import datetime
import json
from django.core.cache import cache
from authentication.serializers import UserSerializer
from medical.models import Appointment, Doctor, MedicalHistory, Staff
from medical.serializers import AppointmentSerializer, DoctorSerializer, MedicalHistorySerializer, StaffSerializer
from constants import CACHE_CONSTANTS, CACHE_EXPIRY
from authentication.permissions import IsMedicalManager
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from authentication.models import User


class StudentDoctorView(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, _):
        cached_doctors = cache.get(CACHE_CONSTANTS['MEDICAL_STUDENT_DOCTORS'])

        if cached_doctors:
            return Response(data = cached_doctors)

        doctors = Doctor.objects.all()
        serializer = DoctorSerializer(doctors, many=True)

        cache.set(
            CACHE_CONSTANTS['MEDICAL_DOCTORS'],
            serializer.data,
            CACHE_EXPIRY)

        return Response(serializer.data)


class StudentStaffView(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, _):
        cached_staff = cache.get(CACHE_CONSTANTS['MEDICAL_STUDENT_STAFF'])

        if cached_staff:
            return Response(data = cached_staff)

        staffs = Staff.objects.all()
        serializer = StaffSerializer(staffs, many=True)

        cache.set(
            CACHE_CONSTANTS['MEDICAL_STUDENT_STAFF'],
            serializer.data,
            CACHE_EXPIRY
        )

        return Response(serializer.data)


class AppointmentView(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request):
        user = request.user
        appointments = Appointment.objects.filter(patient=user)
        serializer = AppointmentSerializer(appointments, many=True)
        return Response(serializer.data)

    def post(self, request):
        doctor = json.loads(request.body.decode('utf-8')).get('doctor')
        doctorinstance = Doctor.objects.filter(id=doctor).first()
        user = request.user

        appointment = Appointment.objects.filter(
            doctor=doctorinstance, patient=user).first()

        if appointment:
            return Response(status=401, data={
                'msg': 'Appointment already exists'
            })

        instance = Appointment.objects.create(
            doctor=doctorinstance,
            patient=user
        )
        instance.save()
        return Response(AppointmentSerializer(instance).data)

class MedicalHistoryView(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request):
        user = request.user
        history = MedicalHistory.objects.filter(patient=user)
        serializer = MedicalHistorySerializer(history, many=True)
        return Response(serializer.data)

class MedicalHistoryManagerView(APIView):
    permission_classes = [IsMedicalManager]

    def post(self, request):
        patient = request.POST.get("patient", None)
        patientinstance = User.objects.filter(email=patient).first()
        doctor = request.POST.get("doctor", None)
        doctorinstance = Doctor.objects.filter(id=doctor).first()
        details = request.POST.get("details", None)
        date = request.POST.get("date", None)
        inhouse = request.POST.get("inhouse", None)
        diagnosis = request.POST.get("diagnosis", None)
        treatment = request.POST.get("treatment", None)
        time = request.POST.get("time", None)

        instance = MedicalHistory.objects.create(
            patient=patientinstance,
            date=date,
            doctor=doctorinstance,
            details=details,
            inhouse=inhouse,
            diagnosis=diagnosis,
            treatment=treatment,
            time=time
        )
        instance.save()
        serinstance = MedicalHistorySerializer(instance)
        return Response(serinstance.data)


class SearchDoctors(APIView):
    permission_classes = (IsMedicalManager,)

    def get(self, request, *args, **kwargs):
        query = request.GET.get("name")
        doctors = Doctor.objects.filter(name__contains=query)
        if doctors:
            serializer = DoctorSerializer(doctors, many = True)
            return Response(serializer.data)
        return Response(data={"msg": "No doctors found"}, status=404)


class SearchPatient(APIView):
    permission_classes = (IsMedicalManager,)

    def get(self, request, *args, **kwargs):
        query = request.GET.get('email')

        if not query:
            return Response(status = 400)

        patients = User.objects.filter(email__contains=query)

        if patients:
            return Response(data = UserSerializer(patients, many=True).data)
        return Response(data={"msg": "No patient found"}, status=404)


class ManagerStaffView(APIView):
    permission_classes = (IsMedicalManager,)

    def get(self, request):
        staffs = Staff.objects.all()
        serializer = StaffSerializer(staffs, many=True)
        return Response(serializer.data)

    def post(self, request):
        request.body = json.loads(request.body.decode('utf8'))
        name = request.body.get('name')
        profession = request.body.get('profession')
        contact = request.body.get('contact')

        staff = Staff.objects.create(
            name = name,
            designation = profession,
            phone = contact
        )

        staff.save()
        return Response(status = 200, data={ 'msg': 'Staff added successfully' })


class ManagerStaffDelete(APIView):
    permission_classes = [IsMedicalManager]

    def post(self, request):
        body = json.loads(request.body.decode('utf8'))

        id = body.get('id')

        staff = Staff.objects.filter(id = id).first()

        staff.delete()

        return Response(status=200, data={'msg': 'Staff record deleted successfully'})


class ManagerDoctorView(APIView):
    permission_classes = (IsMedicalManager,)

    def get(self, _):
        doctors = Doctor.objects.all()
        serializer = DoctorSerializer(doctors, many=True)
        return Response(serializer.data)


class UpdateDoctorView(APIView):
    permission_classes = [IsMedicalManager]

    def post(self, request):
        body = json.loads(request.body.decode('utf8'))
        id = body.get('id')
        name = body.get('name')
        phone = body.get('phone')
        specialization = body.get('specialization')
        start_time = body.get('start_time')
        end_time = body.get('end_time')
        date = body.get('date')
        mail = body.get('email')
        details = body.get('details')

        doctor = Doctor.objects.filter(id=id).first()

        doctor.name = name
        doctor.phone = phone
        doctor.specialization = specialization
        doctor.start_time = start_time
        doctor.end_time = end_time
        doctor.date = date
        doctor.mail = mail
        doctor.details = details

        doctor.save()

        return Response(status=200, data={
            'msg': 'Doctor updated successfully'
        })


class AppointmentManagerView(APIView):
    permission_classes = [IsMedicalManager]

    def get(self, request):
        appointments = Appointment.objects.filter(status = "IN PROGRESS").all()
        serializer = AppointmentSerializer(appointments, many=True)
        return Response(serializer.data)

class AppointmentsPending(APIView):
    permission_classes = [IsMedicalManager]

    def get(self, request):
        now = datetime.datetime.now()

        appointments = Appointment.objects.filter(status = "ACCEPTED", date__gt=now.date()).all()

        serializer = AppointmentSerializer(appointments, many=True)
        return Response(serializer.data)


class AppointmentManagerConfirm(APIView):
    permission_classes = [IsMedicalManager]

    def post(self, request):

        body = json.loads(request.body.decode('utf-8'))

        id = body.get('id')
        date = body.get('date')
        start_time = body.get('start_time')
        end_time = body.get('end_time')

        appointment = Appointment.objects.filter(id = id).first()

        appointment.date = date;
        appointment.start_time = start_time;
        appointment.end_time = end_time;

        appointment.status = "ACCEPTED";

        appointment.save()

        return Response(status = 200, data = {
            'msg': 'Appointment Confirmed'
        })

class AppointmentManagerReject(APIView):

    permission_classes = [IsMedicalManager]

    def post(self, request):

        body = json.loads(request.body.decode('utf-8'))

        id = body.get('id')
        reason = body.get('reason')

        appointment = Appointment.objects.filter(id = id).first()

        appointment.reason = reason

        appointment.status = "REJECTED";

        appointment.save()

        return Response(status = 200, data = {
            'msg': 'Appointment Rejected successfully'
        })
