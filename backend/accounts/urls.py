from django.urls import path


from .views import (
    csrf_view,
    login_view,
    logout_view,
    me_view,
    register_view,
    MobileLoginView,
    MobileLogoutView,
)


urlpatterns = [
    path("csrf/", csrf_view),
    path("register/", register_view),
    path("login/", login_view),
    path("logout/", logout_view),
    path("profile/", me_view),
path(
        "mobile/login/",
        MobileLoginView.as_view(),
        name="mobile-login",
    ),
    path(
        "mobile/logout/",
        MobileLogoutView.as_view(),
        name="mobile-logout",
    ),
]