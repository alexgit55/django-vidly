from django.db import models
from django.utils import timezone

# Create your models here.
class Genre(models.Model):
    name = models.CharField(max_length=255)

    def __str__(self):
        return self.name
    
class Movie(models.Model):
    title = models.CharField(max_length=255)
    genre = models.ForeignKey(Genre, on_delete=models.CASCADE)
    release_date = models.DateField()
    rating = models.DecimalField(max_digits=3, decimal_places=1)
    number_in_stock = models.PositiveIntegerField()
    daily_rate = models.DecimalField(max_digits=5, decimal_places=2)
    date_created = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return self.title