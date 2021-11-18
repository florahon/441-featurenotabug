from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json
import os, time
from django.conf import settings
from django.core.files.storage import FileSystemStorage
from nltk.corpus import wordnet as wn

# Google Vision API imports
from google.cloud import vision
import io

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
    response = {
        "recipes": recipes,
    }

    return JsonResponse(response)

@csrf_exempt
def scan_receipt(request):
    if request.method != 'GET':
        return HttpResponse(status=400)

    receipt = request.args.get("receipt")
    # receipt = '../static/admin/img/grocery_receipt1'

    text = pytesseract.image_to_string(Image.open(receipt))
    pricePattern = r'([0-9]+\.[0-9]+)'
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
    # Remove the items that involve some total, either 'total' or 'subtotal tax total'
    if (len(items) >= 3):
        if ('total' in items[-3]):
            items = items[:-3]
        if ('total' in items[-1]):
            items = items[:-1]

    response = {}
    response['items'] = items

    return JsonResponse(response)

@csrf_exempt
def scan_image(request):
    """
    Scans image from the request and returns the contents of the image
    Example JsonResponse response:
    {
        "tomato": 2,
        "banana": 3,
        ...
    }
    """
    image_content = request.args.get("image")
    # Instantiates a client
    client = vision.ImageAnnotatorClient()
    # Loads the image into memory
    with io.open(image_content, 'rb') as image_file:
        content = image_file.read()

    image = vision.Image(content=content)

    # Performs label detection on the image file
    response = client.label_detection(image=image)
    labels = response.label_annotations

    # TODO: make sure the label is a food item
    # This is necessary since if the user takes a picture
    # of food on a table, for example, the vision API will return 
    # "table" as a label

    # Obtain food_names list from wordnet
    food = wn.synset('food.n.02')
    hypo = lambda s: s.hyponyms()
    food_names = set()
    for synset in wn.synsets('food'):
        food_names |= set([b.replace("_", " ").lower() for s in synset.closure(hypo) for b in s.lemma_names()])

    # Store the counts of each label
    labels_map = {}
    for label in labels:
        if (label.lower() in food_names):
            labels_map[label] += 1

    # Create the response:
    response = {}
    for key in labels_map:
        response[key] = labels_map[key]

    return JsonResponse(response)
    
    