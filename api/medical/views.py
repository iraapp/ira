import datetime
import json
from authentication.permissions import IsMedicalManager, IsMessManager
from medical.serializers import *
from medical.models import *
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
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


class ManagerDoctorView(APIView):
    permission_classes = (IsMedicalManager,)

    def get(self, request):
        doctors = Doctor.objects.all()
        serializer = DoctorSerializer(doctors, many=True)
        return Response(serializer.data)

    def post(self, request):
        body = json.loads(request.body.decode('utf8'))
        name = body.get('name')
        phone = body.get('phone')
        specialization = body.get('specialization')
        joined_at = datetime.date.today()
        start_time = body.get('start_time')
        end_time = body.get('end_time')
        date = body.get('date')
        mail = body.get('email')
        details = body.get('details')

        doctor = Doctor.objects.create(
            name=name,
            phone=phone,
            specialization=specialization,
            joined_at=joined_at,
            start_time=datetime.time.fromisoformat(start_time),
            end_time=datetime.time.fromisoformat(end_time),
            date=datetime.date.fromisoformat(date),
            mail=mail,
            details=details,
        )

        doctor.save()

        return Response(status=200, data={
            'msg': 'Doctor created successfully'
        })

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
            name=name,
            designation=profession,
            phone=contact
        )

        staff.save()
        return Response(status=200, data={'msg': 'Staff added successfully'})


class ManagerStaffDelete(APIView):
    permission_classes = [IsMedicalManager]

    def post(self, request):
        body = json.loads(request.body.decode('utf8'))

        id = body.get('id')

        staff = Staff.objects.filter(id=id).first()

        staff.delete()

        return Response(status=200, data={'msg': 'Staff record deleted successfully'})


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


class AppointmentManagerView(APIView):
    permission_classes = [IsMedicalManager]

    def get(self, request):
        appointments = Appointment.objects.filter(status="IN PROGRESS").all()
        serializer = AppointmentSerializer(appointments, many=True)
        return Response(serializer.data)


class AppointmentsPending(APIView):
    permission_classes = [IsMedicalManager]

    def get(self, request):
        now = datetime.datetime.now()

        appointments = Appointment.objects.filter(
            status="ACCEPTED", date__gt=now.date()).all()

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
        patientinstance = User.objects.filter(email=patient).first()
        doctor = request.POST.get("doctor", None)
        doctorinstance = Doctor.objects.filter(id=doctor).first()
        details = request.POST.get("details", None)
        diagnosis = request.POST.get("diagnosis", None)
        treatment = request.POST.get("treatment", None)
        date = request.POST.get("date", None)
        inhouse = request.POST.get("inhouse", None)

        instance = MedicalHistory.objects.create(
            patient=patientinstance,
            doctor=doctorinstance,
            details=details,
            diagnosis=diagnosis,
            treatment=treatment,
            date=date,
            inhouse=inhouse
        )
        instance.save()
        serinstance = MedicalHistorySerializer(instance)
        return Response(serinstance.data)


class SearchPatient(APIView):
    permission_classes = (IsMedicalManager,)

    def get(self, request, *args, **kwargs):
        query = request.GET.get("email")
        patients = User.objects.filter(email__contains=query).all()
        if patients:
            return Response(UserSerializer(patients, many=True).data)
        return Response(data={"msg": "No patient found"}, status=404)


class SearchDoctors(APIView):
    permission_classes = (IsMedicalManager,)

    def get(self, request, *args, **kwargs):
        query = request.GET.get("name")
        doctors = Doctor.objects.filter(name__contains=query).all()
        if doctors:
            serializer = DoctorSerializer(doctors, many=True)
            return Response(serializer.data)
        return Response(data={"msg": "No doctors found"}, status=404)


class AppointmentManagerConfirm(APIView):
    permission_classes = [IsMedicalManager]

    def post(self, request):

        body = json.loads(request.body.decode('utf-8'))

        id = body.get('id')
        date = body.get('date')
        start_time = body.get('start_time')
        end_time = body.get('end_time')

        appointment = Appointment.objects.filter(id=id).first()

        appointment.date = date
        appointment.start_time = start_time
        appointment.end_time = end_time

        appointment.status = "ACCEPTED"

        appointment.save()

        return Response(status=200, data={
            'msg': 'Appointment Confirmed'
        })


class AppointmentManagerReject(APIView):

    permission_classes = [IsMedicalManager]

    def post(self, request):

        body = json.loads(request.body.decode('utf-8'))

        id = body.get('id')
        reason = body.get('reason')

        appointment = Appointment.objects.filter(id=id).first()

        appointment.reason = reason

        appointment.status = "REJECTED"

        appointment.save()

        return Response(status=200, data={
            'msg': 'Appointment Rejected successfully'
        })
