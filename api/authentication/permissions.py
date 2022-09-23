from authentication.models import USER_ROLES
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

    def has_permission(self, request, _):
      return bool(request.user and
      request.user.role == STAFF_ROLE_IDS['mess_manager'])


class IsMedicalManager(BasePermission):
    """
    Allows access only to only medical managers.
    """

    def has_permission(self, request, _):
      return bool(request.user and
      request.user.role == STAFF_ROLE_IDS['medical_manager'])

class IsSwoOffice(BasePermission):
    """
    Allows access only to only swo office.
    """

    def has_permission(self, request, _):
      return bool(request.user and
      request.user.role == USER_ROLES['swo_office'])

class IsAcademicOfficeUG(BasePermission):
    """
    Allows access only to only academic office ug.
    """

    def has_permission(self, request, _):
      return bool(request.user and
      request.user.role == USER_ROLES['academic_office_ug'])

class IsAcademicOfficePG(BasePermission):
    """
    Allows access only to only academic office pg.
    """

    def has_permission(self, request, _):
      return bool(request.user and
      request.user.role == USER_ROLES['academic_office_pg'])

class IsGymkhana(BasePermission):
    """
    Allows access only to only gymkhana.
    """

    def has_permission(self, request, _):
      return bool(request.user and
      request.user.role == USER_ROLES['gymkhana'])

class IsCulturalBoard(BasePermission):
    """
    Allows access only to only cultural board.
    """

    def has_permission(self, request, _):
      return bool(request.user and
      request.user.role == USER_ROLES['cultural_board'])

class IsTechnicalBoard(BasePermission):
    """
    Allows access only to only technical board.
    """

    def has_permission(self, request, _):
      return bool(request.user and
      request.user.role == USER_ROLES['technical_board'])
    
class IsSportsBoard(BasePermission):
    """
    Allows access only to only sports board.
    """

    def has_permission(self, request, _):
      return bool(request.user and
      request.user.role == USER_ROLES['sports_board'])

class IsHostelBoard(BasePermission):
    """
    Allows access only to only hostel board.
    """

    def has_permission(self, request, _):
      return bool(request.user and
      request.user.role == USER_ROLES['hostel_board'])

class IsAcademicBoardUG(BasePermission):
    """
    Allows access only to only academic board ug.
    """

    def has_permission(self, request, _):
      return bool(request.user and
      request.user.role == USER_ROLES['academic_board_ug'])

class IsAcademicBoardPG(BasePermission):
    """
    Allows access only to only academic board pg.
    """

    def has_permission(self, request, _):
      return bool(request.user and
      request.user.role == USER_ROLES['academic_board_pg'])