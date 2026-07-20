from django.utils import timezone

from rest_framework.permissions import (
    IsAuthenticated,
)
from rest_framework.response import Response
from rest_framework.views import APIView

from festivals.models import Set

from .authentication import (
    WidgetTokenAuthentication,
)


class WidgetScheduleView(APIView):
    """
    Read-only schedule endpoint used by the native
    iOS WidgetKit extension.

    Authentication:

        Authorization: WidgetToken <token>

    The token identifies the user whose liked schedule
    should be returned.
    """

    authentication_classes = [
        WidgetTokenAuthentication,
    ]

    permission_classes = [
        IsAuthenticated,
    ]

    def get(self, request):
        now = timezone.now()

        festival_sets = (
            Set.objects
            .filter(
                liked_by=request.user,
                end_time__gt=now,
            )
            .select_related(
                "artist",
                "stage",
                "stage__festival",
            )
            .order_by(
                "start_time",
                "id",
            )
        )

        schedule = [
            self._serialize_set(
                request,
                festival_set,
                now,
            )
            for festival_set
            in festival_sets
        ]

        current_set = next(
            (
                item
                for item in schedule
                if item["status"] == "live"
            ),
            None,
        )

        next_set = next(
            (
                item
                for item in schedule
                if item["status"] == "upcoming"
            ),
            None,
        )

        return Response(
            {
                "generated_at": (
                    now.isoformat()
                ),
                "current_set": current_set,
                "next_set": next_set,
                "sets": schedule,
            },
        )

    def _serialize_set(
        self,
        request,
        festival_set,
        now,
    ):
        if (
            festival_set.start_time
            <= now
            < festival_set.end_time
        ):
            schedule_status = "live"
        else:
            schedule_status = "upcoming"

        image_url = self._get_image_url(
            request,
            festival_set,
        )

        festival = (
            festival_set.stage.festival
        )

        return {
            "id": festival_set.id,
            "festival_id": festival.id,
            "festival_name": festival.name,
            "artist_name": (
                festival_set.artist.name
            ),
            "stage_name": (
                festival_set.stage.name
            ),
            "start_time": (
                festival_set
                .start_time
                .isoformat()
            ),
            "end_time": (
                festival_set
                .end_time
                .isoformat()
            ),
            "display_image": image_url,
            "status": schedule_status,
        }

    def _get_image_url(
        self,
        request,
        festival_set,
    ):
        image = None

        artist = festival_set.artist

        if (
            hasattr(
                artist,
                "image",
            )
            and artist.image
        ):
            image = artist.image
        elif (
            festival_set.stage.festival.image
        ):
            image = (
                festival_set
                .stage
                .festival
                .image
            )

        if image is None:
            return None

        try:
            image_url = image.url
        except ValueError:
            return None

        return request.build_absolute_uri(
            image_url,
        )