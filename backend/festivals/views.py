from django.shortcuts import get_object_or_404

from rest_framework import generics, status
from rest_framework.decorators import (
    api_view,
    permission_classes,
)
from rest_framework.parsers import (
    FormParser,
    JSONParser,
    MultiPartParser,
)
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from .models import Artist, Festival, Set, Stage
from .serializers import (
    ArtistSerializer,
    FestivalSerializer,
    PublicFestivalSerializer,
    SetSerializer,
    StageSerializer,
)


# =========================================================
# Organiser festival management
# =========================================================


class FestivalListCreateView(
    generics.ListCreateAPIView
):
    """
    GET:
        Return only festivals owned by the logged-in
        organiser.

    POST:
        Create a festival owned by the logged-in user.
    """

    serializer_class = FestivalSerializer
    permission_classes = [IsAuthenticated]

    parser_classes = [
        MultiPartParser,
        FormParser,
        JSONParser,
    ]

    def get_queryset(self):
        return (
            Festival.objects
            .filter(organiser=self.request.user)
            .order_by("start_date", "name")
        )

    def perform_create(self, serializer):
        serializer.save(
            organiser=self.request.user,
        )


class FestivalDetailView(
    generics.RetrieveUpdateDestroyAPIView
):
    """
    Organiser-only detail, update and delete endpoint.
    """

    serializer_class = FestivalSerializer
    permission_classes = [IsAuthenticated]

    parser_classes = [
        MultiPartParser,
        FormParser,
        JSONParser,
    ]

    def get_queryset(self):
        return Festival.objects.filter(
            organiser=self.request.user,
        )


# =========================================================
# Public/user-facing festival browsing
# =========================================================


class PublicFestivalListView(
    generics.ListAPIView
):
    """
    Return every festival for the user discovery page.
    """

    serializer_class = PublicFestivalSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return (
            Festival.objects
            .select_related("organiser")
            .order_by("start_date", "name")
        )


class PublicFestivalDetailView(
    generics.RetrieveAPIView
):
    """
    Return one festival without requiring the logged-in
    user to be its organiser.
    """

    serializer_class = PublicFestivalSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Festival.objects.select_related(
            "organiser",
        )


class PublicFestivalStageListView(
    generics.ListAPIView
):
    """
    Read-only stage list for regular festival visitors.
    """

    serializer_class = StageSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return (
            Stage.objects
            .filter(
                festival_id=self.kwargs["festival_id"],
            )
            .select_related("festival")
            .order_by("name")
        )


class PublicFestivalSetListView(
    generics.ListAPIView
):
    """
    Read-only timetable for regular festival visitors.
    """

    serializer_class = SetSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return (
            Set.objects
            .filter(
                stage__festival_id=(
                    self.kwargs["festival_id"]
                ),
            )
            .select_related(
                "artist",
                "stage",
                "stage__festival",
            )
            .prefetch_related("liked_by")
            .order_by("start_time")
        )


# =========================================================
# Set likes
# =========================================================


@api_view(["POST"])
@permission_classes([IsAuthenticated])
def toggle_set_like_view(request, set_id):
    """
    Like or unlike a set for the currently authenticated
    user.
    """

    festival_set = get_object_or_404(
        Set.objects.prefetch_related("liked_by"),
        id=set_id,
    )

    user = request.user

    if festival_set.liked_by.filter(
        id=user.id,
    ).exists():
        festival_set.liked_by.remove(user)
        is_liked = False
    else:
        festival_set.liked_by.add(user)
        is_liked = True

    return Response(
        {
            "set_id": festival_set.id,
            "is_liked": is_liked,
            "like_count": (
                festival_set.liked_by.count()
            ),
        },
        status=status.HTTP_200_OK,
    )


# =========================================================
# Organiser stage and artist management
# =========================================================


class FestivalStageListCreateView(
    generics.ListCreateAPIView
):
    serializer_class = StageSerializer
    permission_classes = [IsAuthenticated]

    def get_festival(self):
        return get_object_or_404(
            Festival,
            id=self.kwargs["festival_id"],
            organiser=self.request.user,
        )

    def get_queryset(self):
        return (
            Stage.objects
            .filter(
                festival=self.get_festival(),
            )
            .order_by("name")
        )

    def perform_create(self, serializer):
        serializer.save(
            festival=self.get_festival(),
        )


class FestivalArtistListCreateView(
    generics.ListCreateAPIView
):
    serializer_class = ArtistSerializer
    permission_classes = [IsAuthenticated]

    parser_classes = [
        MultiPartParser,
        FormParser,
        JSONParser,
    ]

    def get_festival(self):
        return get_object_or_404(
            Festival,
            id=self.kwargs["festival_id"],
            organiser=self.request.user,
        )

    def get_queryset(self):
        return (
            Artist.objects
            .filter(
                festival=self.get_festival(),
            )
            .order_by("name")
        )

    def perform_create(self, serializer):
        serializer.save(
            festival=self.get_festival(),
        )


# =========================================================
# Organiser set management
# =========================================================


class FestivalSetListView(
    generics.ListAPIView
):
    serializer_class = SetSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return (
            Set.objects
            .filter(
                stage__festival_id=(
                    self.kwargs["festival_id"]
                ),
                stage__festival__organiser=(
                    self.request.user
                ),
            )
            .select_related(
                "artist",
                "stage",
                "stage__festival",
            )
            .prefetch_related("liked_by")
            .order_by("start_time")
        )


class SetCreateView(
    generics.CreateAPIView
):
    serializer_class = SetSerializer
    permission_classes = [IsAuthenticated]

    parser_classes = [
        MultiPartParser,
        FormParser,
        JSONParser,
    ]


class SetDetailView(
    generics.RetrieveUpdateDestroyAPIView
):
    serializer_class = SetSerializer
    permission_classes = [IsAuthenticated]

    parser_classes = [
        MultiPartParser,
        FormParser,
        JSONParser,
    ]

    def get_queryset(self):
        return (
            Set.objects
            .filter(
                stage__festival__organiser=(
                    self.request.user
                ),
            )
            .select_related(
                "artist",
                "stage",
                "stage__festival",
            )
            .prefetch_related("liked_by")
        )
