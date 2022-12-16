import zoneinfo

from django.utils import timezone

class AsiaKolkataTimeMiddleware:
  def __init__(self, get_response):
    self.get_response = get_response

  def __call__(self, request):
    tzname = 'Asia/Kolkata'
    timezone.activate(zoneinfo.ZoneInfo(tzname))

    return self.get_response(request)
