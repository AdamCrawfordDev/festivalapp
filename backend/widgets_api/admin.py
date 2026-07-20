from django.contrib import admin

from .models import WidgetToken


@admin.register(WidgetToken)
class WidgetTokenAdmin(
    admin.ModelAdmin,
):
    list_display = [
        "user",
        "name",
        "is_active",
        "created_at",
        "last_used_at",
    ]

    list_filter = [
        "is_active",
        "created_at",
    ]

    search_fields = [
        "user__username",
        "user__email",
        "name",
    ]

    readonly_fields = [
        "token_hash",
        "created_at",
        "last_used_at",
    ]