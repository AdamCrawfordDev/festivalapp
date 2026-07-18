from django.contrib import admin
from django.contrib.auth.admin import UserAdmin

from .models import User


@admin.register(User)
class CustomUserAdmin(UserAdmin):
    fieldsets = UserAdmin.fieldsets + (
        (
            "Account role",
            {
                "fields": ("account_type",),
            },
        ),
    )

    add_fieldsets = UserAdmin.add_fieldsets + (
        (
            "Account role",
            {
                "fields": ("email", "account_type"),
            },
        ),
    )

    list_display = (
        "username",
        "email",
        "account_type",
        "is_staff",
        "is_active",
    )