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

    profile_pic = models.ImageField(
        upload_to="profile_pic/",
        blank=True,
        null=True,
    )

    profile_picture = models.ImageField(
        upload_to="profile_pictures/",
        blank=True,
        null=True,
    )

    bio = models.TextField(blank=True)

    display_name = models.CharField(
        max_length=100,
        blank=True,
    )

