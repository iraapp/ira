import binascii
import os
import uuid
from django.db import models
from django.contrib.auth.models import PermissionsMixin
from django.contrib.auth.base_user import AbstractBaseUser
from django.utils import timezone
from django.utils.translation import gettext_lazy as _

from institute_app import settings

from .managers import CustomUserManager

STAFF_ROLE_IDS = {
    'guard': 1,
    'mess_manager': 2,
    'medical_manager': 3,
}

USER_ROLES={
    'student': 1,
    'employee': 2,
    'admin': 3,
    'swo_office': 4,
    'academic_office_ug': 5,
    'academic_office_pg': 6,
    'gymkhana': 7,
    'cultural_board':8,
    'technical_board':9,
    'sports_board':10,
    'hostel_board':11,
    'academic_board_ug':12,
    'academic_board_pg':13,
    'ira_team':14,
}

# Create your models here.
class User(AbstractBaseUser, PermissionsMixin):

    # These fields tie to the roles!


    ROLE_CHOICES = (
        (USER_ROLES['admin'], 'Admin'),
        (USER_ROLES['student'], 'Student'),
        (USER_ROLES['employee'], 'Employee'),
        (USER_ROLES['swo_office'], 'SWO Office'),
        (USER_ROLES['academic_office_ug'], 'Academic Office UG'),
        (USER_ROLES['academic_office_pg'], 'Academic Office PG'),
        (USER_ROLES['gymkhana'], 'Gymkhana'),
        (USER_ROLES['cultural_board'], 'Cultural Board'),
        (USER_ROLES['technical_board'], 'Technical Board'),
        (USER_ROLES['sports_board'], 'Sports Board'),
        (USER_ROLES['hostel_board'], 'Hostel Board'),
        (USER_ROLES['academic_board_ug'], 'Academic Board UG'),
        (USER_ROLES['academic_board_pg'], 'Academic Board PG'),
        (USER_ROLES['ira_team'], 'IRA Team'),
    )

    # Roles created here
    uid = models.UUIDField(unique=True, editable=False,
                           default=uuid.uuid4, verbose_name='Public identifier')
    email = models.EmailField(unique=True)
    first_name = models.CharField(max_length=30, blank=True)
    last_name = models.CharField(max_length=50, blank=True)
    role = models.PositiveSmallIntegerField(
        choices=ROLE_CHOICES, blank=True, null=True, default=3)
    date_joined = models.DateTimeField(auto_now_add=True)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=True)
    is_deleted = models.BooleanField(default=False)
    created_date = models.DateTimeField(default=timezone.now)
    modified_date = models.DateTimeField(default=timezone.now)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []

    objects = CustomUserManager()

    def __str__(self):
        return self.email

    class Meta:
        verbose_name = 'user'
        verbose_name_plural = 'users'


class UserToken(models.Model):
    """
    The staff authorization token model.
    """
    key = models.CharField(_("Key"), max_length=40, primary_key=True)
    user = models.OneToOneField(
        User, related_name='id_token',
        on_delete=models.CASCADE, verbose_name=_("User")
    )
    created = models.DateTimeField(_("Created"), auto_now_add=True)

    class Meta:
        abstract = 'rest_framework.authtoken' not in settings.INSTALLED_APPS
        verbose_name = _("User Token")
        verbose_name_plural = _("User Tokens")

    def save(self, *args, **kwargs):
        if not self.key:
            self.key = self.generate_key()
        return super().save(*args, **kwargs)

    @classmethod
    def generate_key(cls):
        return binascii.hexlify(os.urandom(20)).decode()

    def __str__(self):
        return self.key


class Staff(models.Model):
    # These fields tie to the roles!
    STAFF_ROLE_CHOICES = (
        (STAFF_ROLE_IDS['guard'], 'Guard'),
        (STAFF_ROLE_IDS['mess_manager'], 'Mess Manager'),
        (STAFF_ROLE_IDS['medical_manager'], 'Medical Manager'),
    )

    first_name = models.CharField(max_length=30)
    last_name = models.CharField(max_length=30)
    username = models.CharField(max_length=20, unique=True)
    password = models.CharField(_('password'), max_length=128, help_text=_(
        "Use '[algo]$[salt]$[hexdigest]' or use the <a href=\"password/\">change password form</a>."))
    role = models.PositiveSmallIntegerField(
        choices=STAFF_ROLE_CHOICES, default=1)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    @property
    def is_authenticated(self):
        return True
    def __str__(self):
        return self.first_name + ' ' + self.last_name


class StaffToken(models.Model):
    """
    The staff authorization token model.
    """
    key = models.CharField(_("Key"), max_length=40, primary_key=True)
    user = models.OneToOneField(
        Staff, related_name='auth_token',
        on_delete=models.CASCADE, verbose_name=_("Staff")
    )
    created = models.DateTimeField(_("Created"), auto_now_add=True)

    class Meta:
        abstract = 'rest_framework.authtoken' not in settings.INSTALLED_APPS
        verbose_name = _("Staff Token")
        verbose_name_plural = _("Staff Tokens")

    def save(self, *args, **kwargs):
        if not self.key:
            self.key = self.generate_key()
        return super().save(*args, **kwargs)

    @classmethod
    def generate_key(cls):
        return binascii.hexlify(os.urandom(20)).decode()

    def __str__(self):
        return self.key
