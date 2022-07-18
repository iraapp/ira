import json
from mess.serializers import *
from mess.models import *
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response


class MessMenu(APIView):
    #permission_classes = [IsAuthenticated]

    def get(self, request):
        data = Mess.objects.all()

        serialized_json = MessSerializer(data, many=True)

        return Response(data=serialized_json.data)


"""
FeedbackView:
    Payload required:
        1. mess_no - mess number
        2. feeback - feedback body

"""


class FeedbackView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        data = Feedback.objects.all()
        serialized_json = FeedbackSerializer(data, many=True)
        return Response(data=serialized_json.data)

    def post(self, request, *args, **kwargs):
        user = request.user
        feedback = request.POST.get("feedback")
        mess_no = request.POST.get("mess_no")
        instance = Feedback.objects.create(
            user=user,
            body=feedback,
            mess_no=mess_no

        )
        return Response(status=200, data={

            "msg": "Feedback submitted successfully."
        })


class FeedbackInstanceView(APIView):
    def get(self, request, *args, **kwargs):
        feedback_id = kwargs.get("pk")
        data = Feedback.objects.filter(id=feedback_id).first()
        serialized_json = FeedbackSerializer(data)
        return Response(data=serialized_json.data)


# Minutes of meeting for meeting note: s3 implimentation is necessary for production
"""
MessMomView:

    Payload required:
        1. date - date of meeting
        2. file - file of meeting
        3. title - title of meeting
        4. description - description of meeting

"""


class MessMomView(APIView):
    permission_classes = [IsAuthenticated]
    model = MessMom

    def get(self, request, *args, **kwargs):
        data = self.model.objects.all()
        serialized_json = MessMomSer(data, many=True)
        return Response(data=serialized_json.data)

    def post(self, request, *args, **kwargs):
        try:
            file = request.FILES.get("file")
            title = request.POST.get("title", None)
            date = request.POST.get("date", None)
            description = request.POST.get("description", None)
            instance = self.model.objects.create(
                file=file,
                title=title,
                date=date,
                description=description

            )
            return Response(status=200, data={

                "msg": "mom submitted successfully."
            })
        except Exception as e:
            print(e)
            return Response(status=500, data={
                "msg": "internal server error"
            })


class MessMomInstanceView(APIView):
    model = MessMom

    def get(self, request, *args, **kwargs):
        mom_id = kwargs.get("pk")
        data = self.model.objects.filter(id=mom_id).first()
        serialized_json = MessMomSer(data)
        return Response(data=serialized_json.data)


# Tender view note: s3 implimentation is necessary for production
"""
mess tender view:
    Payload required:
        1. date - date of tender
        2. file - file of tender
        3. title - title of tender
        4. description - description of tender
        5. contractor - name of tender contractor
"""


class MessTenderView(APIView):
    permission_classes = [IsAuthenticated]
    model = MessTender

    def get(self, request, *args, **kwargs):
        data = self.model.objects.all()
        serialized_json = MessTenderSer(data, many=True)
        return Response(data=serialized_json.data)

    def post(self, request, *args, **kwargs):
        try:
            file = request.FILES.get("file")
            title = request.POST.get("title", None)
            date = request.POST.get("date", None)
            contractor = request.POST.get("contractor", None)
            description = request.POST.get("description", None)
            instance = self.model.objects.create(
                contractor=contractor,
                date=date,
                file=file,
                title=title,
                description=description

            )
            return Response(status=200, data={

                "msg": "tender submitted successfully."
            })
        except Exception as e:
            print(e)
            return Response(status=500, data={
                "msg": "internal server error"
            })


class MessTenderInstanceView(APIView):
    model = MessTender

    def get(self, request, *args, **kwargs):
        tender_id = kwargs.get("pk")
        data = self.model.objects.filter(id=tender_id).first()
        serialized_json = MessTenderSer(data)
        return Response(data=serialized_json.data)
