import 'dart:io';

import 'package:flutter/services.dart';

class WidgetReloadService {
  WidgetReloadService._();

  static const String widgetKind =
      'NextSetWidget';

  static const MethodChannel _channel =
      MethodChannel(
    'com.adam.festivalcompanion/widget',
  );

  static Future<void>
      reloadScheduleWidget() async {
    if (!Platform.isIOS) {
      return;
    }

    try {
      await _channel.invokeMethod<void>(
        'reloadTimeline',
        <String, dynamic>{
          'kind': widgetKind,
        },
      );
    } on MissingPluginException {
      /*
       * The installed native application has not yet
       * been rebuilt with the matching method channel.
       *
       * Widget refresh is best-effort and must not
       * affect normal app behaviour.
       */
    } on PlatformException {
      /*
       * WidgetKit may reject or delay a reload request.
       * This must not make a successful like operation
       * fail.
       */
    }
  }

  static Future<void>
      reloadAllWidgets() async {
    if (!Platform.isIOS) {
      return;
    }

    try {
      await _channel.invokeMethod<void>(
        'reloadAllTimelines',
      );
    } on MissingPluginException {
      // Ignore until the native app is rebuilt.
    } on PlatformException {
      // Widget refresh remains best-effort.
    }
  }
}