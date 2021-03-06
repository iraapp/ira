from rest_framework import serializers

class MenuItemSerializer(serializers.Serializer):
    name = serializers.CharField(max_length=30)

class MenuSlotSerializer(serializers.Serializer):
    name = serializers.CharField(max_length=15)
    items = MenuItemSerializer(many=True)
    start_time = serializers.TimeField()
    end_time = serializers.TimeField()

class WeekDaySerializer(serializers.Serializer):
    name = serializers.CharField(max_length=15)
    slots = MenuSlotSerializer(many=True)

class MessSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    name = serializers.CharField(max_length=15)
    week_days = WeekDaySerializer(many=True)


class FeedbackSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    user = serializers.StringRelatedField()
    body = serializers.CharField(max_length=500)
    mess_no = serializers.IntegerField()
    created_at = serializers.DateTimeField()
    status = serializers.BooleanField()

class MessMomSer(serializers.Serializer):
    id = serializers.IntegerField()
    date = serializers.DateField()
    file = serializers.FileField()
    title = serializers.CharField(max_length = 100)
    description = serializers.CharField(max_length = 500)
    created_at = serializers.DateTimeField()

class MessTenderSer(serializers.Serializer):
    id = serializers.IntegerField()
    date = serializers.DateField()
    contractor = serializers.CharField(max_length = 100)
    file = serializers.FileField()
    title = serializers.CharField(max_length = 100)
    description = serializers.CharField(max_length = 500)
    created_at = serializers.DateTimeField()