from mess.serializers import *
from mess.models import *
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from authentication.permissions import IsMessManager


class MessMenuAPI(APIView):
    permission_classes = []

    def get(self, request):
        weekdays = WeekDay.objects.all()

        data = {}

        for day in weekdays:
            data[day.name] = {}
            for slot in MenuSlot.objects.all():
                data[day.name][slot.name] = MessMenuSerializer(
                    MessMenu.objects.filter(slot=slot, weekdays=day).first()).data

        return Response(data=data)


"""
FeedbackView:
    Payload required:
        1. mess_type - mess type
        2. feedback - feedback body

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


class ComplaintView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        data = MessComplaint.objects.all()
        serialized_json = MessComplaintSerializer(data, many=True)
        return Response(data=serialized_json.data)

    def post(self, request, *args, **kwargs):
        user = request.user
        complaint = request.POST.get("complaint")
        mess_name = request.POST.get("mess_type")
        mess_meal = request.POST.get("mess_meal")
        file = request.FILES.get("file")
        mess_type = Mess.objects.filter(name=mess_name).first()
        MessComplaint.objects.create(
            user=user,
            body=complaint,
            mess_type=mess_type,
            mess_meal=mess_meal,
            file=file
        )
        return Response(status=200, data={
            "msg": "Complaint submitted successfully."
        })


class ComplaintInstanceView(APIView):
    permission_classes = [IsAuthenticated, ]

    def get(self, request, *args, **kwargs):
        feedback_id = kwargs.get("pk")
        data = MessComplaint.objects.filter(id=feedback_id).first()
        serialized_json = MessComplaintSerializer(data)
        return Response(data=serialized_json.data)


class ComplaintActionView(APIView):
    permission_classes = [IsAuthenticated, ]

    def put(self, request, *args, **kwargs):
        pk = kwargs.get("pk")
        complaint = MessComplaint.objects.filter(id=pk).first()
        complaint.status = True
        complaint.save()
        return Response(status=200, data={

            "msg": "Complaint action Updated."
        })


# Minutes of meeting for meeting note: s3 implementation is necessary for production
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


class MessNameView(APIView):
    permission_classes = [IsAuthenticated, ]

    def get(self, request, *args, **kwargs):
        data = Mess.objects.all()
        serialized_json = MessSerializer(data, many=True)
        return Response(data=serialized_json.data)

# To update tender State
class MessTenderArchivedView(APIView):
    permission_classes = [IsAuthenticated, ]

    def put(self, request, *args, **kwargs):
        pk = kwargs.get("pk")
        data = MessTender.objects.filter(id=pk).first()
        data.archieved = True
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


class MenuTimingView(APIView):

    permission_classes = [IsAuthenticated]

    def post(self, request):
        start_time = request.POST.get('start_time')
        end_time = request.POST.get('end_time')
        slot_id = request.POST.get('slot_id')

        slot = MenuSlot.objects.filter(id=slot_id).first()

        slot.start_time = start_time
        slot.end_time = end_time
        slot.save()

        return Response(status=200, data={
            'msg': 'Successfully updated menu timings'
        })


class MenuItemUpdateView(APIView):

    permission_classes = [IsAuthenticated]

    def post(self, request):
        menu_id = request.POST.get('menu_id')
        menu_item_id = request.POST.get('menu_item_id')
        action = request.POST.get('action')

        menu = MessMenu.objects.filter(id=menu_id).first()
        menu_item = MenuItem.objects.filter(id=menu_item_id).first()

        if action == 'remove':
            menu.items.remove(menu_item)
        elif action == 'add':
            menu.items.add(menu_item)
        else:
            return Response(status=400, data={
                'msg': 'action field is malformed'
            })

        return Response(status=200, data={
            'msg': 'Successfully updated mess menu item'
        })


class MessMenuItemAdd(APIView):

    permission_classes = [IsAuthenticated]

    def post(self, request):
        menu_item_name = request.POST.get('menu_item_name')
        menu_id = request.POST.get('menu_id')

        menu_item = MenuItem(name=menu_item_name)
        menu_item.save()

        menu = MessMenu.objects.filter(id=menu_id).first()
        menu.items.add(menu_item)

        return Response(status=200, data={
            'msg': 'Menu item added successfully'
        })
