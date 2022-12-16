from django.core.cache import cache
from mess.models import MenuItem, MenuSlot, Mess, MessComplaint, MessFeedback, MessMenu, MessMom, MessTender, WeekDay
from mess.serializers import MessComplaintSerializer, MessFeedbackSerializer, MessMenuSerializer, MessMomSer, MessSerializer, MessTenderSer
from constants import CACHE_CONSTANTS, CACHE_EXPIRY
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response


class MessMenuAPI(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, _):
        cached_mess_menu = cache.get(CACHE_CONSTANTS['MESS_MENU'])

        if cached_mess_menu:
            return Response(data = cached_mess_menu)

        weekdays = WeekDay.objects.all()

        data = {}

        for day in weekdays:
            data[day.name] = {}
            for slot in MenuSlot.objects.all():
                data[day.name][slot.name] = MessMenuSerializer(
                    MessMenu.objects.filter(slot=slot, weekdays=day).first()).data

        cache.set(CACHE_CONSTANTS['MESS_MENU'], data, CACHE_EXPIRY)

        return Response(data=data)


class FeedbackView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, _):
        cached_feedback = cache.get(CACHE_CONSTANTS['MESS_FEEDBACK'])

        if cached_feedback:
            return cached_feedback

        data = MessFeedback.objects.all()
        serialized_json = MessFeedbackSerializer(data, many=True)

        cache.set(CACHE_CONSTANTS['MESS_FEEDBACK'], serialized_json.data, CACHE_EXPIRY)

        return Response(data=serialized_json.data)

    def post(self, request):
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

        cache.delete(CACHE_CONSTANTS['MESS_FEEDBACK'])

        return Response(status=200, data={

            "msg": "Feedback submitted successfully."
        })


class MessListAPI(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, _):
        messList = Mess.objects.all()

        return Response(status = 200, data = MessSerializer(messList, many = True).data)


class ComplaintView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, _):
        cached_complaints = cache.get(CACHE_CONSTANTS['MESS_COMPLAINT'])

        if cached_complaints:
            return Response(data = cached_complaints)

        data = MessComplaint.objects.all()
        serialized_json = MessComplaintSerializer(data, many=True)

        cache.set(CACHE_CONSTANTS['MESS_COMPLAINT'], serialized_json.data, CACHE_EXPIRY)

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

        cache.delete(CACHE_CONSTANTS['MESS_COMPLAINT'])

        return Response(status=200, data={
            "msg": "Complaint submitted successfully."
        })


class MessMomView(APIView):
    permission_classes = [IsAuthenticated, ]
    model = MessMom

    def get(self, _):
        data = self.model.objects.all()
        serialized_json = MessMomSer(data, many=True)
        return Response(data=serialized_json.data)

    def post(self, request):
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
            return Response(status=500, data={
                "msg": "internal server error"
            })


class MessNameView(APIView):
    permission_classes = [IsAuthenticated, ]

    def get(self, request, *args, **kwargs):
        cached_mess_list = cache.get(CACHE_CONSTANTS['MESS_LIST'])

        if cached_mess_list:
            return Response(data = cached_mess_list)

        data = Mess.objects.all()
        serialized_json = MessSerializer(data, many=True)

        cache.set(CACHE_CONSTANTS['MESS_LIST'], serialized_json.data, CACHE_EXPIRY)

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

        cache.delete(CACHE_CONSTANTS['MESS_MENU'])

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

        cache.delete(CACHE_CONSTANTS['MESS_MENU'])

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

        cache.delete(CACHE_CONSTANTS['MESS_MENU'])

        return Response(status=200, data={
            'msg': 'Menu item added successfully'
        })
