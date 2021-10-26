from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json
import os, time
from django.conf import settings
from django.core.files.storage import FileSystemStorage

# Create your views here.

def getinventory(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    cursor = connection.cursor()
    cursor.execute('SELECT * FROM inventory ORDER BY dateAdded DESC;')
    rows = cursor.fetchall()

    response = {}
    response['inventory'] = rows
    return JsonResponse(response)

@csrf_exempt
def postinventory(request):
    if request.method != 'POST':
        return HttpResponse(status=400)
    
    name = request.POST.get('name')
    category = request.POST.get('category')
    expiration = request.POST.get('expiration')
    quantity = request.POST.get('quantity')

    if request.FILES.get("image"):
        content = request.FILES['image']
        filename = username+str(time.time())+".jpeg"
        fs = FileSystemStorage()
        filename = fs.save(filename, content)
        imageUrl = fs.url(filename)
    else:
        imageUrl = None

    cursor = connection.cursor()
    cursor.execute('INSERT INTO inventory (name, category, expiration, imageUrl, quantity) VALUES ' '(%s, %s, %s, %s, %s);', (name, category, expiration, imageUrl, quantity))
    return JsonResponse({})

@csrf_exempt
def removeitem(request):
    if request.method != 'POST':
        return HttpResponse(status=400)

    name = request.POST.get('name')
    
    cursor = connection.cursor()
    cursor.execute('DELETE FROM inventory WHERE name = {};'.format('name'))
    return JsonResponse({})
