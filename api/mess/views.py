from ast import Is
from mess.serializers import *
from mess.models import *
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from authentication.permissions import IsMessManager


class MessMenu(APIView):
    #permission_classes = [IsAuthenticated]

    def get(self, request):
        data = Mess.objects.all()

        serialized_json = MessSerializer(data, many=True)

        return Response(data=serialized_json.data)


"""
FeedbackView:
    Payload required:
        1. mess_type - mess type
        2. feeback - feedback body

"""


class FeedbackView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        data = MessFeedback.objects.all()
        serialized_json = MessFeedbackSerializer(data, many=True)
        return Response(data=serialized_json.data)

    def post(self, request, *args, **kwargs):
        user = request.user
        feedback = request.POST.get("feedback")
        mess_name = request.POST.get("mess_type")
        mess_meal = request.POST.get("mess_meal")
        mess_type = Mess.objects.filter(name=mess_name).first()
        MessFeedback.objects.create(
            user=user,
            body=feedback,
            mess_type=mess_type,
            mess_meal=mess_meal
        )
        return Response(status=200, data={

            "msg": "Feedback submitted successfully."
        })


class FeedbackInstanceView(APIView):
    permission_classes = [IsAuthenticated, ]

    def get(self, request, *args, **kwargs):
        feedback_id = kwargs.get("pk")
        data = MessFeedback.objects.filter(id=feedback_id).first()
        serialized_json = MessFeedbackSerializer(data)
        return Response(data=serialized_json.data)

# To the status of feedback


class FeedbackActionView(APIView):
    permission_classes = [IsAuthenticated, ]

    def put(self, request, *args, **kwargs):
        pk = kwargs.get("pk")
        feedback = MessFeedback.objects.filter(id=pk).first()
        feedback.status = True
        feedback.save()
        return Response(status=200, data={

            "msg": "feedback action Updated."
        })


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
    permission_classes = [IsAuthenticated, ]
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

    permission_classes = [IsAuthenticated, ]

    def get(self, request, *args, **kwargs):
        mom_id = kwargs.get("pk")
        data = MessMom.objects.filter(id=mom_id).first()
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
    permission_classes = [IsAuthenticated, ]
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


# To update tender State
class MessTenderArchivedView(APIView):
    permission_classes = [IsAuthenticated, ]

    def put(self, request, *args, **kwargs):
        pk = kwargs.get("pk")
        data = MessTender.objects.filter(id=pk).first()
        data.archived = True
        data.save()
        return Response(status=200, data={
            "msg": "tender archived successfully."
        })


class MessTenderInstanceView(APIView):
    model = MessTender

    def get(self, request, *args, **kwargs):
        tender_id = kwargs.get("pk")
        data = self.model.objects.filter(id=tender_id).first()
        serialized_json = MessTenderSer(data)
        return Response(data=serialized_json.data)
