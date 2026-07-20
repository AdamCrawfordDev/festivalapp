from django.contrib.auth import authenticate, login, logout
from django.middleware.csrf import get_token

from rest_framework import status
from rest_framework.decorators import (
    api_view,
    parser_classes,
    permission_classes,
)
from rest_framework.parsers import (
    FormParser,
    JSONParser,
    MultiPartParser,
)
from rest_framework.permissions import (
    AllowAny,
    IsAuthenticated,
)
from rest_framework.response import Response

from .serializers import (
    RegisterSerializer,
    UserSerializer,
)


@api_view(["POST"])
@permission_classes([AllowAny])
def register_view(request):
    serializer = RegisterSerializer(
        data=request.data,
    )

    if serializer.is_valid():
        user = serializer.save()

        return Response(
            {
                "id": user.id,
                "username": user.username,
                "email": user.email,
                "account_type": user.account_type,
            },
            status=status.HTTP_201_CREATED,
        )

    return Response(
        serializer.errors,
        status=status.HTTP_400_BAD_REQUEST,
    )


@api_view(["POST"])
@permission_classes([AllowAny])
def login_view(request):
    username = request.data.get("username")
    password = request.data.get("password")

    user = authenticate(
        request,
        username=username,
        password=password,
    )

    if user is None:
        return Response(
            {
                "error": (
                    "Invalid username or password"
                )
            },
            status=status.HTTP_401_UNAUTHORIZED,
        )

    login(request, user)

    serializer = UserSerializer(
        user,
        context={"request": request},
    )

    return Response({
        "message": "Logged in successfully",
        "user": serializer.data,
    })


@api_view(["GET"])
@permission_classes([AllowAny])
def csrf_view(request):
    return Response({
        "csrfToken": get_token(request),
    })


@api_view(["POST"])
@permission_classes([IsAuthenticated])
def logout_view(request):
    logout(request)

    return Response({
        "message": "Logged out successfully",
    })


@api_view(["GET", "PATCH"])
@permission_classes([IsAuthenticated])
@parser_classes([
    MultiPartParser,
    FormParser,
    JSONParser,
])
def me_view(request):
    user = request.user

    if request.method == "GET":
        serializer = UserSerializer(
            user,
            context={"request": request},
        )

        return Response(serializer.data)

    serializer = UserSerializer(
        user,
        data=request.data,
        partial=True,
        context={"request": request},
    )

    if not serializer.is_valid():
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST,
        )

    serializer.save()

    return Response(serializer.data)

from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView

from .serializers import MobileLoginSerializer


class MobileLoginView(APIView):
    authentication_classes = []
    permission_classes = [
        AllowAny,
    ]

    def post(self, request):
        serializer = MobileLoginSerializer(
            data=request.data,
            context={
                "request": request,
            },
        )

        serializer.is_valid(
            raise_exception=True,
        )

        user = serializer.validated_data[
            "user"
        ]

        token, _ = Token.objects.get_or_create(
            user=user,
        )

        return Response(
            {
                "token": token.key,
                "user": {
                    "id": user.id,
                    "username": (
                        user.get_username()
                    ),
                    "email": user.email,
                    "account_type": (
                        getattr(
                            user,
                            "account_type",
                            "user",
                        )
                    ),
                },
            },
            status=status.HTTP_200_OK,
        )

from rest_framework.permissions import IsAuthenticated


class MobileLogoutView(APIView):
    permission_classes = [
        IsAuthenticated,
    ]

    def post(self, request):
        if request.auth is not None:
            request.auth.delete()

        return Response(
            status=status.HTTP_204_NO_CONTENT,
        )