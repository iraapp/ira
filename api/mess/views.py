import json
from mess.serializers import MessSerializer, WeekDaySerializer, FeedbackSerializer
from mess.models import Mess, Feedback
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response


class MessMenu(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        data = Mess.objects.all()

        serialized_json = MessSerializer(data, many=True)

        return Response(data=serialized_json.data)


class FeedbackView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        data = Feedback.objects.all()

        serialized_json = FeedbackSerializer(data, many=True)

        return Response(data=serialized_json.data)

    def post(self, request, *args, **kwargs):
        request.body = json.loads(request.body.decode('utf8'))
        user = request.user
        feedback = request.body.get("feedback", None)
        mess_no = request.body.get("mess_no", None)
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
        request.body = json.loads(request.body.decode('utf8'))
        feedback_id = request.body.get("feedback_id", None)
        data = Feedback.objects.first(id=feedback_id)

        serialized_json = FeedbackSerializer(data)

        return Response(data=serialized_json.data)
