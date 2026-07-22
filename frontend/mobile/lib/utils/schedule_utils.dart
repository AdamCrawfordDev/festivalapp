import '../models/festival_set.dart';

const int festivalDayCutoffHour = 6;

/*
 * Outlook Origins 2026 takes place in Croatia
 * during July.
 *
 * Croatia is two hours ahead of UTC during
 * the festival dates.
 *
 * Convert from the absolute API timestamp to
 * the printed festival timetable time without
 * using the phone's own timezone.
 */
DateTime toFestivalTime(
  DateTime dateTime,
) {
  return dateTime
      .toUtc()
      .add(
        const Duration(
          hours: 2,
        ),
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
      const Duration(
        days: 1,
      ),
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
          () => <FestivalSet>[],
        )
        .add(
          festivalSet,
        );
  }

  return grouped;
}