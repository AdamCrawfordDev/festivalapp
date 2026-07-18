from django.contrib.auth.models import AbstractUser
from django.db import models


class AccountType(models.TextChoices):
    USER = "user", "User"
    ORGANISER = "organiser", "Organiser"


class User(AbstractUser):
    account_type = models.CharField(
        max_length=20,
        choices=AccountType.choices,
        default=AccountType.USER,
    )