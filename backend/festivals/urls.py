from django.urls import path

from .views import (
    FestivalArtistListCreateView,
    FestivalDetailView,
    FestivalListCreateView,
    FestivalSetListView,
    FestivalStageListCreateView,
    PublicFestivalDetailView,
    PublicFestivalListView,
    PublicFestivalSetListView,
    PublicFestivalStageListView,
    SetCreateView,
    SetDetailView, toggle_set_like_view,
)


urlpatterns = [
    # -----------------------------------------------------
    # Public/user-facing routes
    # -----------------------------------------------------

    path(
        "discover/",
        PublicFestivalListView.as_view(),
        name="public-festival-list",
    ),

    path(
        "discover/<int:pk>/",
        PublicFestivalDetailView.as_view(),
        name="public-festival-detail",
    ),

    path(
        "discover/<int:festival_id>/stages/",
        PublicFestivalStageListView.as_view(),
        name="public-festival-stage-list",
    ),

    path(
        "discover/<int:festival_id>/sets/",
        PublicFestivalSetListView.as_view(),
        name="public-festival-set-list",
    ),

    # -----------------------------------------------------
    # Organiser festival routes
    # -----------------------------------------------------

    path(
        "",
        FestivalListCreateView.as_view(),
        name="festival-list-create",
    ),

    path(
        "sets/",
        SetCreateView.as_view(),
        name="set-create",
    ),

    path(
        "sets/<int:pk>/",
        SetDetailView.as_view(),
        name="set-detail",
    ),

    path(
        "<int:festival_id>/stages/",
        FestivalStageListCreateView.as_view(),
        name="festival-stage-list-create",
    ),

    path(
        "<int:festival_id>/artists/",
        FestivalArtistListCreateView.as_view(),
        name="festival-artist-list-create",
    ),

    path(
        "<int:festival_id>/sets/",
        FestivalSetListView.as_view(),
        name="festival-set-list",
    ),

    path(
        "<int:pk>/",
        FestivalDetailView.as_view(),
        name="festival-detail",
    ),

path(
        "sets/<int:set_id>/like/",
        toggle_set_like_view,
        name="toggle-set-like",
    ),
]