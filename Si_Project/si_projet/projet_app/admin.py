from django.contrib import admin
from .models import HR_Manager, Service, Employe, Conge, Contrat, Salaire, Formation, Participer, Recrutement

admin.site.register(HR_Manager)
admin.site.register(Service)
admin.site.register(Employe)
admin.site.register(Conge)
admin.site.register(Contrat)
admin.site.register(Salaire)
admin.site.register(Formation)
admin.site.register(Participer)
admin.site.register(Recrutement)