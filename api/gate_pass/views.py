import csv
import zoneinfo
from django.utils import timezone
from django.http import HttpResponse
from gate_pass.serializers import GatePassSerializer
from authentication.permissions import IsGuard, IsSecurityOfficer
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from gate_pass.models import GatePass
import json

class GenerateQR(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        request.body = json.loads(request.body.decode('utf8'))
        purpose = request.body.get("purpose", None)
        contact = request.body.get('contact', None)

        if purpose is None or contact is None:
            return Response(
                data = {
                    "msg": "data is missing."
                },
                status = 400
            )

        gate_pass_obj = GatePass.objects.filter(
            user = request.user,
            status = False
        ).order_by("created_at")

        if gate_pass_obj:
            return Response(
            data = {
                "msg": "GatePass object already exists. Please contact administrator."
            },
            status = 400
        )

        # Creating mew object of gate pass
        gate_pass_obj = GatePass.objects.create(
            user = request.user,
            purpose = purpose,
            contact = contact
        )


        student_id = request.user.email.split('@')[0]


        hash = "{}_{}".format(student_id, gate_pass_obj.created_at)

        return Response(
            status=200,
            data={
                "msg": "GatePass object created successfully.",
                "hash": hash,
                "purpose": purpose,
                "status": False
            }
        )


class StudentGatePass(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        gate_pass = GatePass.objects.filter(user = request.user, completed_status = False).first()

        if gate_pass is None:
            return Response(
                status = 404,
                data = {
                    "msg": "No GatePass found."
                }
            )

        student_id = request.user.email.split('@')[0]

        # return the user information.
        return Response(
            status = 200,
            data = {
                "msg": "GatePass object already exists.",
                "status": gate_pass.status,
                "purpose": gate_pass.purpose,
                "out_time_stamp": gate_pass.out_time_stamp,
                "hash": "{}_{}".format(student_id, gate_pass.created_at)
            }
        )


# QR Code is generated in the frontend only.
# When the user goes to the main gate, and his qr is scanned, a ping is sent to backend, and image of user is sent back.
# Now, when the guard approves the request, a modelinstance is created in the backend, for outing, with out time. with out == True
# Now, when the user comes back to the campus, and opens app, the qr should be there, and when it is scanned again, the out == False.

class DeleteQR(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        gate_pass = GatePass.objects.filter(
            user = request.user, status=False, completed_status=False).first()

        if gate_pass:
            gate_pass.delete()
            return Response(status=200, data='success')

        return Response(status=400, data='invalid gate pass')


class ScanQR(APIView):
    permission_classes = [IsAuthenticated, IsGuard]

    def post(self, request):
        hash = json.loads(request.body.decode('utf-8')).get('hash')
        user_email = hash.split('_')[0] + '@iitjammu.ac.in'

        gate_pass = GatePass.objects.filter(
            user__email=user_email, completed_status=False).first()

        if gate_pass:
            if gate_pass.status == False:
                gate_pass.status = True
                gate_pass.out_time_stamp = timezone.now()
                gate_pass.save()

                return Response(status=200, data='successfully scanned for going out')

            elif gate_pass.status == True:
                gate_pass.completed_status = True
                gate_pass.in_time_stamp = timezone.now()
                gate_pass.save()

                return Response(status=200, data='successfully scanned for coming back')

        return Response(status=400, data='invalid gate pass')

class CurrentlyOut(APIView):

    permission_classes = [IsAuthenticated, IsGuard]

    def get(self, _):
        data = GatePass.objects.filter(
            status = True, completed_status = False)
        return Response(status = 200, data = GatePassSerializer(data, many = True).data)

class AllStudents(APIView):

    permission_classes = [IsAuthenticated, IsGuard]

    def get(self, request):
        date = request.GET.get('date', None)

        if date is None:
            return Response(status = 400, data = { 'msg': 'No valid date input' })

        data = GatePass.objects.filter(out_time_stamp__date = date)
        return Response(
            status = 200, data = GatePassSerializer(
            data, many = True).data)

class ExtractData(APIView):
    permission_classes = [IsAuthenticated, IsSecurityOfficer]

    def get(self, request):
        start_date = request.GET.get('start_date', None)
        end_date = request.GET.get('end_date', None)

        if start_date is None or end_date is None:
            return Response(status = 400, data = { 'msg': 'GET parameters are wrong' })

        data = GatePass.objects.filter(out_time_stamp__date__range = [start_date, end_date], status = True)

        response = HttpResponse(
            content_type='text/csv',
            headers={'Content-Disposition': 'attachment; filename="gatepass_data.csv"'},
        )

        writer = csv.writer(response)

        writer.writerow(['Name', 'Entry No.', 'Contact', 'Out Date', 'Out Time', 'In Date', 'In Time', 'Purpose'])

        kolkata_tz = zoneinfo.ZoneInfo('Asia/Kolkata')

        for gate_pass in data:
            out_date = gate_pass.out_time_stamp.astimezone(kolkata_tz).strftime('%x')

            out_time = gate_pass.out_time_stamp.astimezone(kolkata_tz).strftime('%X')

            if gate_pass.in_time_stamp:
                in_date = gate_pass.in_time_stamp.astimezone(kolkata_tz).strftime('%x')
                in_time = gate_pass.in_time_stamp.astimezone(kolkata_tz).strftime('%X')
            else:
                in_date = ''
                in_time = ''

            writer.writerow([gate_pass.user.first_name + ' ' + gate_pass.user.last_name,
            gate_pass.user.email.split('@')[0].upper(),
            gate_pass.contact,
            out_date, out_time,
            in_date, in_time,
            gate_pass.purpose])

        return response
