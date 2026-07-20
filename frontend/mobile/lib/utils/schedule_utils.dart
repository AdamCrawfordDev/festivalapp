import '../models/festival_set.dart';

const int festivalDayCutoffHour = 6;

DateTime getFestivalDay(
  DateTime dateTime,
) {
  final localTime = dateTime.toLocal();

  final calendarDate = DateTime(
    localTime.year,
    localTime.month,
    localTime.day,
  );

  if (
    localTime.hour <
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
      List<FestivalSet>.from(sets)
        ..sort(
          (first, second) =>
              first.startTime.compareTo(
            second.startTime,
          ),
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
        .add(festivalSet);
  }

  return grouped;
}