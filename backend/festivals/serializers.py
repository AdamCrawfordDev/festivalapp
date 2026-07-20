from rest_framework import serializers

from .models import Artist, Festival, Set, Stage


class FestivalSerializer(serializers.ModelSerializer):
    """
    Used by organisers to create, read and update their
    own festivals.
    """

    class Meta:
        model = Festival
        fields = [
            "id",
            "name",
            "description",
            "start_date",
            "end_date",
            "organiser",
            "image",
            "created_at",
            "updated_at",
        ]
        read_only_fields = [
            "id",
            "organiser",
            "created_at",
            "updated_at",
        ]

    def validate(self, attrs):
        start_date = attrs.get(
            "start_date",
            getattr(
                self.instance,
                "start_date",
                None,
            ),
        )

        end_date = attrs.get(
            "end_date",
            getattr(
                self.instance,
                "end_date",
                None,
            ),
        )

        if (
            start_date
            and end_date
            and end_date < start_date
        ):
            raise serializers.ValidationError({
                "end_date": (
                    "The end date cannot be before "
                    "the start date."
                ),
            })

        return attrs


class PublicFestivalSerializer(
    serializers.ModelSerializer
):
    """
    Used when regular users browse festivals.

    Includes enough organiser information to render the
    shared FestivalCard without exposing unnecessary user
    information.
    """

    organiser_name = serializers.SerializerMethodField()

    organiser_profile_picture = serializers.ImageField(
        source="organiser.profile_picture",
        read_only=True,
    )

    class Meta:
        model = Festival
        fields = [
            "id",
            "name",
            "description",
            "start_date",
            "end_date",
            "image",
            "organiser_name",
            "organiser_profile_picture",
        ]
        read_only_fields = fields

    def get_organiser_name(self, festival):
        display_name = (
            festival.organiser.display_name or ""
        ).strip()

        return (
            display_name
            or festival.organiser.username
        )


class StageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Stage
        fields = [
            "id",
            "festival",
            "name",
        ]
        read_only_fields = [
            "id",
            "festival",
        ]


class ArtistSerializer(serializers.ModelSerializer):
    class Meta:
        model = Artist
        fields = [
            "id",
            "festival",
            "name",
            "description",
            "image",
            "created_at",
            "updated_at",
        ]

        read_only_fields = [
            "id",
            "festival",
            "created_at",
            "updated_at",
        ]


class SetSerializer(serializers.ModelSerializer):
    festival = serializers.IntegerField(
        source="stage.festival_id",
        read_only=True,
    )

    stage_name = serializers.CharField(
        source="stage.name",
        read_only=True,
    )

    artist_name = serializers.CharField(
        source="artist.name",
        read_only=True,
    )

    display_image = serializers.SerializerMethodField()

    is_liked = serializers.SerializerMethodField()

    like_count = serializers.IntegerField(
        source="liked_by.count",
        read_only=True,
    )

    class Meta:
        model = Set
        fields = [
            "id",
            "festival",
            "stage",
            "stage_name",
            "artist",
            "artist_name",
            "start_time",
            "end_time",
            "image",
            "display_image",
            "is_liked",
            "like_count",
        ]

        read_only_fields = [
            "id",
            "festival",
            "stage_name",
            "artist_name",
            "display_image",
            "is_liked",
            "like_count",
        ]

    def get_display_image(self, obj):
        image = obj.image or obj.artist.image

        if not image:
            return None

        request = self.context.get("request")

        if request:
            return request.build_absolute_uri(
                image.url,
            )

        return image.url

    def get_is_liked(self, obj):
        request = self.context.get("request")

        if (
            request is None
            or not request.user.is_authenticated
        ):
            return False

        return obj.liked_by.filter(
            id=request.user.id,
        ).exists()

    def validate_stage(self, stage):
        request = self.context["request"]

        if stage.festival.organiser != request.user:
            raise serializers.ValidationError(
                "You cannot use this stage."
            )

        return stage

    def validate_artist(self, artist):
        request = self.context["request"]

        if artist.festival.organiser != request.user:
            raise serializers.ValidationError(
                "You cannot use this artist."
            )

        return artist

    def validate(self, attrs):
        start_time = attrs.get(
            "start_time",
            getattr(
                self.instance,
                "start_time",
                None,
            ),
        )

        end_time = attrs.get(
            "end_time",
            getattr(
                self.instance,
                "end_time",
                None,
            ),
        )

        stage = attrs.get(
            "stage",
            getattr(
                self.instance,
                "stage",
                None,
            ),
        )

        artist = attrs.get(
            "artist",
            getattr(
                self.instance,
                "artist",
                None,
            ),
        )

        errors = {}

        if (
            start_time
            and end_time
            and end_time <= start_time
        ):
            errors["end_time"] = (
                "The end time must be after "
                "the start time."
            )

        if (
            stage
            and artist
            and stage.festival_id
            != artist.festival_id
        ):
            errors["artist"] = (
                "The artist and stage must belong "
                "to the same festival."
            )

        if stage and start_time and end_time:
            festival = stage.festival

            if start_time.date() < festival.start_date:
                errors["start_time"] = (
                    "The set cannot begin before "
                    "the festival."
                )

            if end_time.date() > festival.end_date:
                errors["end_time"] = (
                    "The set cannot end after "
                    "the festival."
                )

        if errors:
            raise serializers.ValidationError(
                errors,
            )

        return attrs

