from authentication.models import STAFF_ROLE_IDS
from rest_framework.permissions import BasePermission

class IsGuard(BasePermission):
    """
    Allows access only to only guards.
    """

    def has_permission(self, request):
        return bool(request.user and
        request.user.role == STAFF_ROLE_IDS['guard'])

class IsMessManager(BasePermission):
    """
    Allows access only to only mess managers.
    """

    def has_permission(self, request):
      return bool(request.user and
      request.user.role == STAFF_ROLE_IDS['mess_manager'])


class IsMedicalManager(BasePermission):
    """
    Allows access only to only medical managers.
    """

    def has_permission(self, request):
      return bool(request.user and
      request.user.role == STAFF_ROLE_IDS['medical_manager'])
