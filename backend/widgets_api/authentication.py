from django.utils import timezone
from rest_framework.authentication import (
    BaseAuthentication,
)
from rest_framework.exceptions import (
    AuthenticationFailed,
)

from .models import WidgetToken


class WidgetTokenAuthentication(
    BaseAuthentication,
):
    keyword = "WidgetToken"

    def authenticate(
        self,
        request,
    ):
        authorization = request.headers.get(
            "Authorization",
            "",
        ).strip()

        if not authorization:
            return None

        parts = authorization.split(
            " ",
            1,
        )

        if (
            len(parts) != 2
            or parts[0] != self.keyword
        ):
            return None

        raw_token = parts[1].strip()

        if not raw_token:
            raise AuthenticationFailed(
                "Missing widget token.",
            )

        token_hash = (
            WidgetToken.hash_token(
                raw_token,
            )
        )

        try:
            widget_token = (
                WidgetToken.objects
                .select_related("user")
                .get(
                    token_hash=token_hash,
                    is_active=True,
                )
            )
        except WidgetToken.DoesNotExist as error:
            raise AuthenticationFailed(
                "Invalid widget token.",
            ) from error

        if not widget_token.user.is_active:
            raise AuthenticationFailed(
                "This user is inactive.",
            )

        WidgetToken.objects.filter(
            pk=widget_token.pk,
        ).update(
            last_used_at=timezone.now(),
        )

        return (
            widget_token.user,
            widget_token,
        )