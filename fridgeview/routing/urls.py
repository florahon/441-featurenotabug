"""routing URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from app import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('getinventory/', views.getinventory, name='getinventory'),
    path('additem/', views.additem, name='additem'),
    path('removeitem/', views.removeitem, name='removeitem'),
    path('updateitem/', views.updateitem, name='updateitem'),
    path('getrecipes/', views.getrecipes, name='getrecipes'),
    path('scanreceipt/', views.scanreceipt, name='scanreceipt'),
    path('scanimage/', views.scanimage, name='scanimage'),
    path('adduser/', views.adduser, name='adduser'),
    path('getitems/', views.getitems, name='getitems'),
]
