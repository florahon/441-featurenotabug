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

# Sign-in imports:
from google.oauth2 import id_token
from google.auth.transport import requests

import hashlib

# Create your views here.

def getinventory(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    # Auth:
    userID = request.args.get('userID')
    cursor = connection.cursor()
    cursor.execute('SELECT username, expiration FROM users WHERE userID = %s;', (userID,))

    row = cursor.fetchone()
    now = time.time()
    if row is None or now > row[1]:
        # return an error if there is no chatter with that ID
        return HttpResponse(status=401) # 401 Unauthorized

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

    # Auth:
    userID = request.args.get('userID')
    cursor = connection.cursor()
    cursor.execute('SELECT username, expiration FROM users WHERE userID = %s;', (userID,))

    row = cursor.fetchone()
    now = time.time()
    if row is None or now > row[1]:
        # return an error if there is no chatter with that ID
        return HttpResponse(status=401) # 401 Unauthorized
    
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

    # Auth:
    userID = request.args.get('userID')
    cursor = connection.cursor()
    cursor.execute('SELECT username, expiration FROM users WHERE userID = %s;', (userID,))

    row = cursor.fetchone()
    now = time.time()
    if row is None or now > row[1]:
        # return an error if there is no chatter with that ID
        return HttpResponse(status=401) # 401 Unauthorized

    name = request.POST.get('name')
    dateadded = request.POST.get('dateadded')

    cursor = connection.cursor()
    cursor.execute("DELETE FROM inventory WHERE name = '{0}' AND dateadded = '{1}';".format(name, dateadded))
    return JsonResponse({})

@csrf_exempt
def updateitem(request):
    if request.method != 'POST':
        return HttpResponse(status=400)

    # Auth:
    userID = request.args.get('userID')
    cursor = connection.cursor()
    cursor.execute('SELECT username, expiration FROM users WHERE userID = %s;', (userID,))

    row = cursor.fetchone()
    now = time.time()
    if row is None or now > row[1]:
        # return an error if there is no chatter with that ID
        return HttpResponse(status=401) # 401 Unauthorized

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

def getrecipes(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    ingredients = request.args.get('ingredients')

    # TODO: Modify ingredient string as necessary

    os.chdir('../recipe_recommend/')
    import word2vec_rec
    recipes = word2vec_rec.send_recs(ingredients)
    os.chdir('../app/')

    # TODO: Modify recipes to desired format
    response = {
        "recipes": recipes,
    }

    return JsonResponse(response)

@csrf_exempt
def scanreceipt(request):
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
def scanimage(request):
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

@csrf_exempt
def adduser(request):
    if request.method != 'POST':
        return HttpResponse(status=404)

    json_data = json.loads(request.body)
    clientID = json_data['clientID']   # the front end app's OAuth 2.0 Client ID
    idToken = json_data['idToken']     # user's OpenID ID Token, a JSon Web Token (JWT)

    now = time.time()                  # secs since epoch (1/1/70, 00:00:00 UTC)

    try:
        # Collect user info from the Google idToken, verify_oauth2_token checks
        # the integrity of idToken and throws a "ValueError" if idToken or
        # clientID is corrupted or if user has been disconnected from Google
        # OAuth (requiring user to log back in to Google).
        # idToken has a lifetime of about 1 hour
        idinfo = id_token.verify_oauth2_token(idToken, requests.Request(), clientID)
    except ValueError:
        # Invalid or expired token
        return HttpResponse(status=511)  # 511 Network Authentication Required

    # get username
    try:
        username = idinfo['name']
    except:
        username = "Profile NA"

    # Compute chatterID and add to database
    backendSecret = "giveamouseacookie"   # or server's private key
    nonce = str(now)
    hashable = idToken + backendSecret + nonce
    userID = hashlib.sha256(hashable.strip().encode('utf-8')).hexdigest()

    # Lifetime of chatterID is min of time to idToken expiration
    # (int()+1 is just ceil()) and target lifetime, which should
    # be less than idToken lifetime (~1 hour).
    lifetime = min(int(idinfo['exp']-now)+1, 60) # secs, up to idToken's lifetime

    cursor = connection.cursor()
    # clean up db table of expired chatterIDs
    cursor.execute('DELETE FROM users WHERE %s > expiration;', (now, ))

    # insert new chatterID
    # Ok for chatterID to expire about 1 sec beyond idToken expiration
    cursor.execute('INSERT INTO users (userid, username, expiration) VALUES '
                   '(%s, %s, %s);', (userid, username, now+lifetime))

    # Return chatterID and its lifetime
    return JsonResponse({'userID': userID, 'lifetime': lifetime})
    
    