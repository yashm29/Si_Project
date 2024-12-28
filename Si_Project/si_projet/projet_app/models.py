from django.db import models   
# Create your models here.


class HR_Manager(models.Model):  
    Nom_HR_manager = models.CharField(max_length=50)
    Prenom_HR_manager = models.CharField(max_length=50)
    Email_HR_manager = models.EmailField(max_length=254)
    password = models.CharField(max_length=50)

    def __str__(self):
        return f"{self.Prenom_HR_manager} {self.Nom_HR_manager}"


class Service(models.Model):  
    Nom_service = models.CharField(max_length=50)
    description_ser = models.CharField(max_length=50)
    hr_manager = models.ForeignKey(HR_Manager, on_delete=models.CASCADE)

    def __str__(self):
        return self.Nom_service


class Employe(models.Model):  
    NomEmp = models.CharField(max_length=50)
    PrenomEmp = models.CharField(max_length=50)
    Date_nais_Emp = models.DateField()
    Date_Rec = models.DateField()
    AdressEmp = models.CharField(max_length=50)
    Employes_service = models.ForeignKey(Service, on_delete=models.CASCADE)

    def __str__(self):
        return f"{self.PrenomEmp} {self.NomEmp}"


class Conge(models.Model):  
    Date_deb = models.DateField()
    Date_fin = models.DateField()
    TypeConge = models.CharField(max_length=50)
    SatutCng = models.CharField(max_length=50)
    Employe_conge = models.ForeignKey(Employe, on_delete=models.CASCADE)

    def __str__(self):
        return f"{self.TypeConge} ({self.Date_deb} - {self.Date_fin})"


class Contrat(models.Model):  
    TypeContrat = models.CharField(max_length=50)
    Date_deb_cnt = models.DateField()
    Date_fin_cnt = models.DateField()
    salaireMenseul = models.DecimalField(max_digits=10, decimal_places=2)
    Employe_cnt = models.ForeignKey(Employe, on_delete=models.CASCADE)

    def __str__(self):
        return f"{self.TypeContrat} ({self.Date_deb_cnt} - {self.Date_fin_cnt})"


class Salaire(models.Model):  
    Mois = models.CharField(max_length=50)
    annee = models.IntegerField()
    Montant = models.DecimalField(max_digits=10, decimal_places=2)
    statutSalaire = models.CharField(max_length=50)
    Employe_sal = models.ForeignKey(Employe, on_delete=models.CASCADE)

    def __str__(self):
        return f"{self.Mois} {self.annee}: {self.Montant}"


class Formation(models.Model):  
    NomFormation = models.CharField(max_length=50)
    DateDebFor = models.DateField()
    DateFinFor = models.DateField()
    Employes_for = models.ManyToManyField(Employe, through='Participer')

    def __str__(self):
        return self.NomFormation


class Participer(models.Model):  
    employe = models.ForeignKey(Employe, on_delete=models.CASCADE)
    formation = models.ForeignKey(Formation, on_delete=models.CASCADE)
    date_participation = models.DateField()

    def __str__(self):
        return f"{self.employe} -> {self.formation}"


class Recrutement(models.Model):  
    DateRec = models.DateField()
    Poste = models.CharField(max_length=50)
    StatutRec = models.CharField(max_length=50)
    Employe_recruter = models.ForeignKey(Employe, on_delete=models.CASCADE)

    def __str__(self):
        return f"{self.Poste} ({self.DateRec})"
