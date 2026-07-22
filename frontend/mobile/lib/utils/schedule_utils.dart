import 'package:timezone/timezone.dart' as tz;

import '../models/festival_set.dart';

const int festivalDayCutoffHour = 6;

final tz.Location festivalTimeZone =
    tz.getLocation(
  'Europe/Zagreb',
);

tz.TZDateTime toFestivalTime(
  DateTime dateTime,
) {
  return tz.TZDateTime.from(
    dateTime,
    festivalTimeZone,
  );
}

DateTime getFestivalDay(
  DateTime dateTime,
) {
  final festivalTime =
      toFestivalTime(
    dateTime,
  );

  final calendarDate =
      DateTime(
    festivalTime.year,
    festivalTime.month,
    festivalTime.day,
  );

  if (
    festivalTime.hour <
    festivalDayCutoffHour
  ) {
    return calendarDate.subtract(
      const Duration(days: 1),
    );
  }

  return calendarDate;
}

Map<DateTime, List<FestivalSet>>
    groupSetsByFestivalDay(
  List<FestivalSet> sets,
) {
  final grouped =
      <DateTime, List<FestivalSet>>{};

  final sortedSets =
      List<FestivalSet>.from(
    sets,
  )
        ..sort(
          (
            first,
            second,
          ) {
            return first.startTime
                .compareTo(
              second.startTime,
            );
          },
        );

  for (final festivalSet in sortedSets) {
    final festivalDay =
        getFestivalDay(
      festivalSet.startTime,
    );

    grouped
        .putIfAbsent(
          festivalDay,
          () => [],
        )
        .add(
          festivalSet,
        );
  }

  return grouped;
}
