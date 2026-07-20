from rest_framework import serializers

from .models import User


class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(
        write_only=True,
        min_length=8,
    )

    class Meta:
        model = User
        fields = [
            "id",
            "username",
            "email",
            "password",
            "account_type",
        ]
        read_only_fields = ["id"]

    def create(self, validated_data):
        return User.objects.create_user(
            **validated_data,
        )


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = [
            "id",
            "username",
            "email",
            "display_name",
            "bio",
            "profile_picture",
            "account_type",
        ]
        read_only_fields = [
            "id",
            "username",
            "email",
            "account_type",
        ]

from django.contrib.auth import authenticate
from django.contrib.auth import get_user_model

from rest_framework import serializers


User = get_user_model()


class MobileLoginSerializer(serializers.Serializer):
    login = serializers.CharField(
        write_only=True,
    )

    password = serializers.CharField(
        write_only=True,
        trim_whitespace=False,
        style={
            "input_type": "password",
        },
    )

    def validate(self, attrs):
        login = attrs["login"].strip()
        password = attrs["password"]

        username = login

        if "@" in login:
            user = User.objects.filter(
                email__iexact=login,
            ).first()

            if user is not None:
                username = user.get_username()

        user = authenticate(
            request=self.context.get(
                "request",
            ),
            username=username,
            password=password,
        )

        if user is None:
            raise serializers.ValidationError(
                {
                    "detail": (
                        "The email, username or "
                        "password is incorrect."
                    ),
                },
            )

        if not user.is_active:
            raise serializers.ValidationError(
                {
                    "detail": (
                        "This account is disabled."
                    ),
                },
            )

        attrs["user"] = user

        return attrs