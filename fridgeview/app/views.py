from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json
import os, time
from django.conf import settings
from django.core.files.storage import FileSystemStorage

import pytesseract
import re
try:
    from PIL import Image
except ImportError:
    import Image

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
    cursor.execute("INSERT INTO inventory (name, category, expiration, imageurl, quantity) "
                    "VALUES (?, ?, ?, ?, ?);", (name, category, expiration, imageurl, quantity,))
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

@csrf_exempt
def updateitem(request):
    if request.method != 'POST':
        return HttpResponse(status=400)

    name = request.POST.get('name')
    dateadded = request.POST.get('dateadded')
    category = request.POST.get('category')
    expiration = request.POST.get('expiration')
    quantity = request.POST.get('quantity')

    cursor = connection.cursor()
    cursor.execute("UPDATE inventory SET category = '{0}', expiration = '{1}', "
                    "imageurl = '{3}', quantity = '{4}' WHERE name = '{5}' AND "
                    "dateadded = '{6}';".format(category, expiration, imageurl, quantity, name, dateadded))
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

@csrf_exempt
def scan_receipt(request):
    if request.method != 'GET':
        return HttpResponse(status=400)

    # Call to library to get the required items from the image:

    # TODO: Figurre out how the image will be passed in
    receipt = request.args.get("receipt")
    # receipt = '../static/admin/img/grocery_receipt1'

    # Send items back to client
    text = pytesseract.image_to_string(Image.open(receipt))
    pricePattern = r'([0-9]+\.[0-9]+)'
    # show the output of filtering out *only* the line items in the
    # loop over each of the line items in the OCR'd receipt
    items = []
    for row in text.split("\n"):
        # check to see if the price regular expression matches the current
        # row
        if re.search(pricePattern, row) is not None:
            # print(row)
            split_text = row.split(' ')
            item = ""
            for i in range(len(split_text)):
                if (split_text[i].isalpha() and len(split_text[i]) > 1):
                    item = (split_text[i])
            if (len(item) > 0):
                items.append(item.lower())

    if (len(items) >= 3):
        if ('total' in items[-3]):
            items = items[:-3]
        if ('total' in items[-1]):
            items = items[:-1]

    response = {}
    response['items'] = items

    return JsonResponse(response)
