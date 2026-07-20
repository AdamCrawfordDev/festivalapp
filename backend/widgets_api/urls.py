from django.urls import path

from .views import WidgetScheduleView


urlpatterns = [
    path(
        "schedule/",
        WidgetScheduleView.as_view(),
        name="widget-schedule",
    ),
]