from django.contrib import admin
from .models import Genre, Movie

class GenreAdmin(admin.ModelAdmin):
    list_display = ('id','name',)
    search_fields = ('name',)
    ordering = ('id',)

class MovieAdmin(admin.ModelAdmin):
    list_display = ('id', 'title', 'genre', 'release_date', 'rating', 'number_in_stock', 'daily_rate')
    exclude = ('date_created',)
    ordering = ('id',)
    search_fields = ('title', 'genre__name')
    list_filter = ('genre',)

# Register your models here.
admin.site.register(Genre, GenreAdmin)
admin.site.register(Movie, MovieAdmin)