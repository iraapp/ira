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
