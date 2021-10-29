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
def additem(request):
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
        imageurl = fs.url(filename)
    else:
        imageurl = None

    cursor = connection.cursor()
    cursor.execute('INSERT INTO inventory (name, category, expiration, imageurl, quantity) VALUES ' '(%s, %s, %s, %s, %s);', (name, category, expiration, imageurl, quantity))
    return JsonResponse({})

@csrf_exempt
def removeitem(request):
    if request.method != 'POST':
        return HttpResponse(status=400)

    name = request.POST.get('name')
    dateadded = request.POST.get('dateadded')

    cursor = connection.cursor()
    cursor.execute("DELETE FROM inventory WHERE name = '{0}' AND dateadded = '{1}';".format(name, dateadded))
    return JsonResponse({})

def get_recipes(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    ingredients = request.args.get('ingredients')

    # TODO: Modify ingredient string as necessary

    os.chdir('../recipe_recommend/')
    recipes = word2vec_rec.send_recs(ingredients)
    os.chdir('../app/')

    # TODO: Modify recipes to desired format

    return JsonResponse(recipes)
