from django.contrib import admin

from .models import Artist, Festival, Set, Stage


@admin.register(Festival)
class FestivalAdmin(admin.ModelAdmin):
    list_display = [
        "name",
        "organiser",
        "start_date",
        "end_date",
    ]

    search_fields = [
        "name",
        "organiser__username",
        "organiser__email",
    ]

    list_filter = [
        "start_date",
        "end_date",
    ]


@admin.register(Stage)
class StageAdmin(admin.ModelAdmin):
    list_display = [
        "name",
        "festival",
    ]

    search_fields = [
        "name",
        "festival__name",
    ]

    list_filter = [
        "festival",
    ]


@admin.register(Artist)
class ArtistAdmin(admin.ModelAdmin):
    list_display = [
        "name",
        "festival",
    ]

    search_fields = [
        "name",
        "festival__name",
    ]

    list_filter = [
        "festival",
    ]


@admin.register(Set)
class SetAdmin(admin.ModelAdmin):
    list_display = [
        "artist",
        "stage",
        "start_time",
        "end_time",
    ]

    search_fields = [
        "artist__name",
        "stage__name",
        "stage__festival__name",
    ]

    list_filter = [
        "stage__festival",
        "stage",
        "artist",
    ]