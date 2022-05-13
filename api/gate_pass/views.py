from django.shortcuts import render
from django.utils import timezone
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from gate_pass.models import GatePass
import datetime
import json

from rest_framework.permissions import IsAuthenticated

from authentication.models import User

class GenerateQR(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        request.body = json.loads(request.body.decode('utf8'))
        purpose = request.body.get("purpose", None)

        if purpose is None:
            return Response(
                data = {
                    "msg": "purpose field is missing."
                },
                status = 400
            )

        try:
            gate_pass_obj = GatePass.objects.filter(
                user = request.user,
                status = False
            ).order_by("created_at")

            if gate_pass_obj.exists():
                return Response(
                data = {
                    "msg": "GatePass object already exists. Please contact administrator."
                },
                status = 400
            )

            # Creating mew object of gate pass
            gate_pass_obj = GatePass.objects.create(
                user = request.user,
                purpose = purpose
            )


            student_id = request.user.email.split('@')[0]

            if student_id is None or student_id == "":
                return Response(
                    status=500,
                    data={
                        "msg": "Some Inernal Server Error Occured."
                    }
                )

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

        except Exception as e:
            print("Some error occured", e)
            return Response(
                status=500,
                data={
                    "msg": "Some Internal Server Error Occured."
                }
            )


class StudentGatepassStatus(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        Current_user = request.user
        if Current_user is None:
            return Response(
                status = 401,
                data = {
                    "msg": "User not found."
                }
            )

        current_gate_pass = GatePass.objects.filter(user = Current_user, completed_status = False).first()

        if current_gate_pass is None:
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
                "status": current_gate_pass.status,
                "purpose": current_gate_pass.purpose,
                "out_time_stamp": current_gate_pass.out_time_stamp,
                "hash": "{}_{}".format(student_id, current_gate_pass.created_at)
            }
        )



class Guard_Ping_1(APIView):
    permission_classes = [IsAuthenticated]


    def post(self, request, *args, **kwargs):
        Current_user = request.user
        if Current_user == None:
            return Response(
                status = 401,
                data = {
                    "msg": "User not found."
                }
            )

        if not Current_user.is_staff:
            return Response(
                status = 403,
                data = {
                    "msg": "User doesn't have the permission to access this resource."
                }
            )

        jsonData = json.loads(request.body)

        entryNo = jsonData.get("entryNo", None)
        purpose = jsonData.get("purpose", None)

        if entryNo is None or purpose is None:
            return Response(
                status = 404,
                data = {
                    "msg": "Either entryNo or purpose field is missing."
                }
            )

        student_user = User.objects.filter(email = entryNo).first()
        if student_user is None:
            return Response(
                status = 404,
                data = {
                    "msg": "Student not found."
                }
            )

        gate_pass = GatePass.objects.filter(user = student_user, completed_status = False).order_by("-created_at").first()
        if gate_pass is None:
            GatePass.objects.create(
                user = student_user,
                purpose = purpose,
                status = True,
                out_time_stamp = datetime.datetime.now()
            )
            return Response(
                status = 200,
                data = {
                    "msg": "Exit Marked Successfully."
                }
            )

        if gate_pass.status == True:
            gate_pass.status = False
            gate_pass.completed_status = True
            gate_pass.save()
            return Response(
                status = 201,
                data = {
                    "msg": "Entry marked successfully."
                }
            )
        else:
            return Response(
                status = 409,
                data = {
                    "msg": "GatePass entry already exsits and marked as exit. Please make a new one."
                }
            )



class Testing(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        return Response(
            data = {
                "msg": "Hello World"
            },
            status = 200
        )


# QR Code is generated in the frontend only.

# When the user goes to the main gate, and his qr is scanned, a ping is sent to backend, and image of user is sent back.
# Now, when the guard approves the request, a modelinstance is created in the backend, for outing, with out time. with out == True
# Now, when the user comes back to the campus, and opens app, the qr should be there, and when it is scanned again, the out == False.

class DeleteQR(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        hash = json.loads(request.body.decode('utf-8')).get('hash')

        user_email = hash.split('_')[0] + '@iitjammu.ac.in'

        gate_pass = GatePass.objects.filter(
            user__email=user_email, status=False, completed_status=False).first()

        if gate_pass:
            gate_pass.delete()
            return Response(status=200, data='success')

        return Response(status=400, data='invalid gate pass')


class ScanQR(APIView):
    permission_classes = [IsAuthenticated]

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
