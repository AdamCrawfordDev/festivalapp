from django.contrib.auth import (
    get_user_model,
)
from django.core.management.base import (
    BaseCommand,
    CommandError,
)

from widgets_api.models import (
    WidgetToken,
)


class Command(BaseCommand):
    help = (
        "Create or replace the "
        "read-only widget token "
        "for a user."
    )

    def add_arguments(
        self,
        parser,
    ):
        parser.add_argument(
            "login",
            help=(
                "The user's username "
                "or email address."
            ),
        )

    def handle(
        self,
        *args,
        **options,
    ):
        login = options["login"].strip()

        User = get_user_model()

        user = User.objects.filter(
            username__iexact=login,
        ).first()

        if user is None:
            user = User.objects.filter(
                email__iexact=login,
            ).first()

        if user is None:
            raise CommandError(
                "No user was found for "
                f"'{login}'."
            )

        _, raw_token = (
            WidgetToken.generate_for_user(
                user,
            )
        )

        self.stdout.write(
            self.style.SUCCESS(
                "Widget token created.",
            ),
        )

        self.stdout.write(
            "",
        )

        self.stdout.write(
            "Copy this token now. "
            "Django stores only its hash:",
        )

        self.stdout.write(
            raw_token,
        )