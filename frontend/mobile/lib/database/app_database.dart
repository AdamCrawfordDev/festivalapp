import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class CachedFestivals extends Table {
  IntColumn get id => integer()();

  TextColumn get name => text()();

  TextColumn get description =>
      text().withDefault(
        const Constant(''),
      )();

  DateTimeColumn get startDate =>
      dateTime()();

  DateTimeColumn get endDate =>
      dateTime()();

  TextColumn get image =>
      text().nullable()();

  TextColumn get organiserName =>
      text().withDefault(
        const Constant(''),
      )();

  TextColumn get organiserProfilePicture =>
      text().nullable()();

  DateTimeColumn get syncedAt =>
      dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {
        id,
      };
}

class CachedStages extends Table {
  IntColumn get id => integer()();

  IntColumn get festivalId =>
      integer().references(
        CachedFestivals,
        #id,
        onDelete: KeyAction.cascade,
      )();

  TextColumn get name => text()();

  @override
  Set<Column<Object>> get primaryKey => {
        id,
      };
}

class CachedFestivalSets extends Table {
  IntColumn get id => integer()();

  IntColumn get festivalId =>
      integer().references(
        CachedFestivals,
        #id,
        onDelete: KeyAction.cascade,
      )();

  IntColumn get stageId =>
      integer()();

  TextColumn get stageName =>
      text()();

  IntColumn get artistId =>
      integer()();

  TextColumn get artistName =>
      text()();

  DateTimeColumn get startTime =>
      dateTime()();

  DateTimeColumn get endTime =>
      dateTime()();

  TextColumn get image =>
      text().nullable()();

  TextColumn get displayImage =>
      text().nullable()();

  BoolColumn get isLiked =>
      boolean().withDefault(
        const Constant(false),
      )();

  IntColumn get likeCount =>
      integer().withDefault(
        const Constant(0),
      )();

  DateTimeColumn get syncedAt =>
      dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {
        id,
      };
}

/*
 * A desired final like state, not merely "toggle once".
 *
 * This is important because a toggle endpoint is not
 * idempotent. During synchronisation Flutter compares the
 * desired state against Django's current state and only
 * calls the toggle endpoint when they differ.
 */
class PendingSetLikes extends Table {
  IntColumn get setId => integer()();

  IntColumn get festivalId =>
      integer()();

  BoolColumn get desiredIsLiked =>
      boolean()();

  DateTimeColumn get createdAt =>
      dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {
        setId,
      };
}

@DriftDatabase(
  tables: [
    CachedFestivals,
    CachedStages,
    CachedFestivalSets,
    PendingSetLikes,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(
          driftDatabase(
            name:
                'festival_companion.sqlite',
          ),
        );

  /*
   * No database columns or tables have changed,
   * so no schema migration is required.
   */
  @override
  int get schemaVersion => 1;

  Stream<List<CachedFestival>>
      watchFestivals() {
    return (
      select(cachedFestivals)
        ..orderBy([
          (table) =>
              OrderingTerm.asc(
            table.startDate,
          ),
        ])
    ).watch();
  }

  Future<List<CachedFestival>>
      getFestivals() {
    return (
      select(cachedFestivals)
        ..orderBy([
          (table) =>
              OrderingTerm.asc(
            table.startDate,
          ),
        ])
    ).get();
  }

  Stream<CachedFestival?>
      watchFestival(
    int festivalId,
  ) {
    return (
      select(cachedFestivals)
        ..where(
          (table) =>
              table.id.equals(
            festivalId,
          ),
        )
    ).watchSingleOrNull();
  }

  Future<CachedFestival?>
      getFestival(
    int festivalId,
  ) {
    return (
      select(cachedFestivals)
        ..where(
          (table) =>
              table.id.equals(
            festivalId,
          ),
        )
    ).getSingleOrNull();
  }

  Stream<List<CachedStage>>
      watchStages(
    int festivalId,
  ) {
    return (
      select(cachedStages)
        ..where(
          (table) =>
              table.festivalId.equals(
            festivalId,
          ),
        )
        ..orderBy([
          (table) =>
              OrderingTerm.asc(
            table.name,
          ),
        ])
    ).watch();
  }

  Future<List<CachedStage>>
      getStages(
    int festivalId,
  ) {
    return (
      select(cachedStages)
        ..where(
          (table) =>
              table.festivalId.equals(
            festivalId,
          ),
        )
        ..orderBy([
          (table) =>
              OrderingTerm.asc(
            table.name,
          ),
        ])
    ).get();
  }

  Stream<List<CachedFestivalSet>>
      watchFestivalSets(
    int festivalId,
  ) {
    return (
      select(cachedFestivalSets)
        ..where(
          (table) =>
              table.festivalId.equals(
            festivalId,
          ),
        )
        ..orderBy([
          (table) =>
              OrderingTerm.asc(
            table.startTime,
          ),
        ])
    ).watch();
  }

  Future<List<CachedFestivalSet>>
      getFestivalSets(
    int festivalId,
  ) {
    return (
      select(cachedFestivalSets)
        ..where(
          (table) =>
              table.festivalId.equals(
            festivalId,
          ),
        )
        ..orderBy([
          (table) =>
              OrderingTerm.asc(
            table.startTime,
          ),
        ])
    ).get();
  }

  Future<List<CachedFestivalSet>>
      getAllLikedSets() {
    return (
      select(cachedFestivalSets)
        ..where(
          (table) =>
              table.isLiked.equals(
            true,
          ),
        )
        ..orderBy([
          (table) =>
              OrderingTerm.asc(
            table.startTime,
          ),
        ])
    ).get();
  }

  Future<List<PendingSetLike>>
      getPendingLikes({
    int? festivalId,
  }) {
    final query =
        select(pendingSetLikes);

    if (festivalId != null) {
      query.where(
        (table) =>
            table.festivalId.equals(
          festivalId,
        ),
      );
    }

    query.orderBy([
      (table) =>
          OrderingTerm.asc(
        table.createdAt,
      ),
    ]);

    return query.get();
  }

  Future<PendingSetLike?>
      getPendingLike(
    int setId,
  ) {
    return (
      select(pendingSetLikes)
        ..where(
          (table) =>
              table.setId.equals(
            setId,
          ),
        )
    ).getSingleOrNull();
  }

  /*
   * Update festival discovery metadata without deleting
   * stages or sets that have already been downloaded.
   *
   * Calling replaceFestival() here would remove the
   * detailed offline schedule because of its delete and
   * replace behaviour.
   */
  Future<void> upsertFestivalSummaries(
    List<CachedFestivalsCompanion>
        festivals,
  ) async {
    if (festivals.isEmpty) {
      return;
    }

    await transaction(() async {
      for (final festival in festivals) {
        await into(cachedFestivals)
            .insertOnConflictUpdate(
          festival,
        );
      }
    });
  }

  Future<void> replaceFestival({
    required CachedFestivalsCompanion
        festival,
    required List<
            CachedStagesCompanion>
        stages,
    required List<
            CachedFestivalSetsCompanion>
        sets,
  }) async {
    final festivalId =
        festival.id.value;

    await transaction(() async {
      await into(cachedFestivals)
          .insertOnConflictUpdate(
        festival,
      );

      await (
        delete(cachedStages)
          ..where(
            (table) =>
                table.festivalId.equals(
              festivalId,
            ),
          )
      ).go();

      await (
        delete(cachedFestivalSets)
          ..where(
            (table) =>
                table.festivalId.equals(
              festivalId,
            ),
          )
      ).go();

      if (stages.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(
            cachedStages,
            stages,
          );
        });
      }

      if (sets.isNotEmpty) {
        await batch((batch) {
          batch.insertAll(
            cachedFestivalSets,
            sets,
          );
        });
      }
    });
  }

  Future<void> setLocalLike({
    required int setId,
    required int festivalId,
    required bool isLiked,
  }) async {
    await transaction(() async {
      final existing = await (
        select(cachedFestivalSets)
          ..where(
            (table) =>
                table.id.equals(
              setId,
            ),
          )
      ).getSingleOrNull();

      if (existing == null) {
        return;
      }

      final nextLikeCount =
          isLiked
              ? existing.likeCount + 1
              : existing.likeCount > 0
                  ? existing.likeCount - 1
                  : 0;

      await (
        update(cachedFestivalSets)
          ..where(
            (table) =>
                table.id.equals(
              setId,
            ),
          )
      ).write(
        CachedFestivalSetsCompanion(
          isLiked:
              Value(isLiked),
          likeCount:
              Value(nextLikeCount),
        ),
      );

      await into(pendingSetLikes)
          .insertOnConflictUpdate(
        PendingSetLikesCompanion.insert(
          setId:
              Value(setId),
          festivalId:
              festivalId,
          desiredIsLiked:
              isLiked,
          createdAt:
              DateTime.now().toUtc(),
        ),
      );
    });
  }

  Future<void> confirmLike({
    required int setId,
    required bool isLiked,
    required int likeCount,
  }) async {
    await transaction(() async {
      await (
        update(cachedFestivalSets)
          ..where(
            (table) =>
                table.id.equals(
              setId,
            ),
          )
      ).write(
        CachedFestivalSetsCompanion(
          isLiked:
              Value(isLiked),
          likeCount:
              Value(likeCount),
        ),
      );

      await (
        delete(pendingSetLikes)
          ..where(
            (table) =>
                table.setId.equals(
              setId,
            ),
          )
      ).go();
    });
  }

  Future<void> removePendingLike(
    int setId,
  ) {
    return (
      delete(pendingSetLikes)
        ..where(
          (table) =>
              table.setId.equals(
            setId,
          ),
        )
    ).go();
  }

  Future<void> clearAllCachedData() async {
    await transaction(() async {
      await delete(
        pendingSetLikes,
      ).go();

      await delete(
        cachedFestivalSets,
      ).go();

      await delete(
        cachedStages,
      ).go();

      await delete(
        cachedFestivals,
      ).go();
    });
  }
}