import '../database/app_database.dart';

class OfflineFestivalBundle {
  const OfflineFestivalBundle({
    required this.festival,
    required this.stages,
    required this.sets,
    required this.isSyncing,
    this.syncError,
  });

  final CachedFestival? festival;
  final List<CachedStage> stages;
  final List<CachedFestivalSet> sets;

  final bool isSyncing;
  final Object? syncError;

  bool get hasCachedData =>
      festival != null;

  OfflineFestivalBundle copyWith({
    CachedFestival? festival,
    List<CachedStage>? stages,
    List<CachedFestivalSet>? sets,
    bool? isSyncing,
    Object? syncError,
    bool clearSyncError = false,
  }) {
    return OfflineFestivalBundle(
      festival:
          festival ?? this.festival,
      stages:
          stages ?? this.stages,
      sets:
          sets ?? this.sets,
      isSyncing:
          isSyncing ?? this.isSyncing,
      syncError:
          clearSyncError
              ? null
              : syncError ??
                  this.syncError,
    );
  }
}
