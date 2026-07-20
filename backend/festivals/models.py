from django.conf import settings
from django.core.exceptions import ValidationError
from django.db import models


class Festival(models.Model):
    name = models.CharField(max_length=200)
    description = models.TextField(blank=True)

    start_date = models.DateField()
    end_date = models.DateField()

    organiser = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="organised_festivals",
    )

    image = models.ImageField(
        upload_to="festival_images/",
        blank=True,
        null=True,
    )

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def clean(self):
        if self.end_date < self.start_date:
            raise ValidationError({
                "end_date": (
                    "The end date cannot be before the start date."
                )
            })

    def __str__(self):
        return self.name


class Stage(models.Model):
    festival = models.ForeignKey(
        Festival,
        on_delete=models.CASCADE,
        related_name="stages",
    )

    name = models.CharField(max_length=200)

    class Meta:
        ordering = ["name"]

        constraints = [
            models.UniqueConstraint(
                fields=["festival", "name"],
                name="unique_stage_name_per_festival",
            )
        ]

    def __str__(self):
        return f"{self.festival.name} — {self.name}"


class Artist(models.Model):
    festival = models.ForeignKey(
        Festival,
        on_delete=models.CASCADE,
        related_name="artists",
    )

    name = models.CharField(max_length=200)

    description = models.TextField(blank=True)

    image = models.ImageField(
        upload_to="artist_images/",
        blank=True,
        null=True,
    )

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ["name"]

        constraints = [
            models.UniqueConstraint(
                fields=["festival", "name"],
                name="unique_artist_name_per_festival",
            )
        ]

    def __str__(self):
        return self.name


class Set(models.Model):
    stage = models.ForeignKey(
        Stage,
        on_delete=models.CASCADE,
        related_name="sets",
    )

    artist = models.ForeignKey(
        Artist,
        on_delete=models.CASCADE,
        related_name="sets",
    )

    start_time = models.DateTimeField()
    end_time = models.DateTimeField()

    image = models.ImageField(
        upload_to="sets_images/",
        blank=True,
    )

    liked_by = models.ManyToManyField(
        settings.AUTH_USER_MODEL,
        related_name="liked_sets",
        blank=True,
    )

    def clean(self):
        errors = {}

        if self.end_time <= self.start_time:
            errors["end_time"] = (
                "The end time must be after the start time."
            )

        if (
            self.stage_id
            and self.artist_id
            and self.stage.festival_id
            != self.artist.festival_id
        ):
            errors["artist"] = (
                "The artist and stage must belong to "
                "the same festival."
            )

        if errors:
            raise ValidationError(errors)

    class Meta:
        ordering = ["start_time"]

        constraints = [
            models.UniqueConstraint(
                fields=[
                    "stage",
                    "artist",
                    "start_time",
                    "end_time",
                ],
                name="unique_festival_set",
            )
        ]

    def __str__(self):
        return (
            f"{self.artist.name} — "
            f"{self.stage.name}"
        )