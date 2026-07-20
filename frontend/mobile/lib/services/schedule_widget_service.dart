import 'dart:convert';

import 'package:home_widget/home_widget.dart';

import '../database/app_database.dart';

class ScheduleWidgetService {
  ScheduleWidgetService._();

  static const String appGroupId =
      'group.com.adam.festivalapp';

  static const String iosWidgetName =
      'NextSetWidget';

  static const String androidWidgetName =
      'NextSetWidgetProvider';

  static const String scheduleKey =
      'widget_schedule_json';

  static const String lastUpdatedKey =
      'widget_schedule_last_updated';

  static Future<void> configure() {
    return HomeWidget.setAppGroupId(
      appGroupId,
    );
  }

  static Future<void> updateFromDatabase(
    AppDatabase database,
  ) async {
    final now =
        DateTime.now().toUtc();

    final likedSets =
        await database.getAllLikedSets();

    final activeAndUpcoming =
        likedSets.where(
      (set) {
        return set.endTime.isAfter(
          now,
        );
      },
    ).toList(growable: false);

    final payload = activeAndUpcoming
        .map(
          (set) => {
            'id': set.id,
            'festival_id':
                set.festivalId,
            'artist_name':
                set.artistName,
            'stage_name':
                set.stageName,
            'start_time':
                set.startTime
                    .toUtc()
                    .toIso8601String(),
            'end_time':
                set.endTime
                    .toUtc()
                    .toIso8601String(),
            'display_image':
                set.displayImage,
          },
        )
        .toList(growable: false);

    await HomeWidget.saveWidgetData<String>(
      scheduleKey,
      jsonEncode(payload),
    );

    await HomeWidget.saveWidgetData<String>(
      lastUpdatedKey,
      now.toIso8601String(),
    );

    await HomeWidget.updateWidget(
      iOSName: iosWidgetName,
      androidName:
          androidWidgetName,
    );
  }
}
