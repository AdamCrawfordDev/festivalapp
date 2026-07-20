import hashlib
import secrets

from django.conf import settings
from django.db import models


class WidgetToken(models.Model):
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="widget_token",
    )

    token_hash = models.CharField(
        max_length=64,
        unique=True,
        editable=False,
    )

    name = models.CharField(
        max_length=100,
        default="iOS schedule widget",
    )

    is_active = models.BooleanField(
        default=True,
    )

    created_at = models.DateTimeField(
        auto_now_add=True,
    )

    last_used_at = models.DateTimeField(
        null=True,
        blank=True,
    )

    class Meta:
        ordering = [
            "-created_at",
        ]

    def __str__(self):
        return (
            f"{self.user} — "
            f"{self.name}"
        )

    @staticmethod
    def hash_token(
        raw_token,
    ):
        return hashlib.sha256(
            raw_token.encode("utf-8"),
        ).hexdigest()

    @classmethod
    def generate_for_user(
        cls,
        user,
        *,
        name="iOS schedule widget",
    ):
        raw_token = secrets.token_urlsafe(
            48,
        )

        token_hash = cls.hash_token(
            raw_token,
        )

        token, _ = cls.objects.update_or_create(
            user=user,
            defaults={
                "token_hash": token_hash,
                "name": name,
                "is_active": True,
            },
        )

        return token, raw_token