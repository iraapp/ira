from rest_framework import serializers

class MaintenanceStaffContactsSer(serializers.Serializer):
    name = serializers.CharField(max_length=100)
    id = serializers.IntegerField()
    contact = serializers.CharField(max_length=10)
    designation = serializers.CharField(max_length=100)
    created_at = serializers.DateTimeField()
    

