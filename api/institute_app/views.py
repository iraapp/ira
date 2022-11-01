from django.http import HttpResponse


def welcome(request):
    return HttpResponse('IRA is online')
