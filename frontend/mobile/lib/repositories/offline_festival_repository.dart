import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';
import '../services/schedule_widget_service.dart';

class OfflineFestivalRepository {
  OfflineFestivalRepository({
    required Dio dio,
    required AppDatabase database,
  })  : _dio = dio,
        _database = database;

  final Dio _dio;
  final AppDatabase _database;

  Stream<List<CachedFestival>> watchFestivals() {
    return _database.watchFestivals();
  }

  Stream<CachedFestival?> watchFestival(
    int festivalId,
  ) {
    return _database.watchFestival(
      festivalId,
    );
  }

  Stream<List<CachedStage>> watchStages(
    int festivalId,
  ) {
    return _database.watchStages(
      festivalId,
    );
  }

  Stream<List<CachedFestivalSet>> watchSets(
    int festivalId,
  ) {
    return _database.watchFestivalSets(
      festivalId,
    );
  }

  /*
   * Refresh the festival discovery list.
   *
   * This only upserts festival summary rows. It does not
   * delete cached festivals, stages or schedules that are
   * absent from the latest discovery response.
   */
  Future<void> syncFestivalList() async {
    final response = await _dio.get<dynamic>(
      '/festivals/discover/',
    );

    final data = response.data;

    if (data is! List) {
      throw const FormatException(
        'Expected the festival discovery '
        'endpoint to return a list.',
      );
    }

    final now = DateTime.now().toUtc();

    final festivals = data.map(
      (item) {
        if (item is! Map) {
          throw const FormatException(
            'Expected each festival to '
            'be a JSON object.',
          );
        }

        final json = Map<String, dynamic>.from(
          item,
        );

        return CachedFestivalsCompanion.insert(
          id: Value(
            json['id'] as int,
          ),
          name: json['name'] as String? ??
              'Unnamed festival',
          description: Value(
            json['description'] as String? ??
                '',
          ),
          startDate: DateTime.parse(
            json['start_date'] as String,
          ).toUtc(),
          endDate: DateTime.parse(
            json['end_date'] as String,
          ).toUtc(),
          image: Value(
            json['image'] as String?,
          ),
          organiserName: Value(
            json['organiser_name'] as String? ??
                '',
          ),
          organiserProfilePicture: Value(
            json['organiser_profile_picture']
                as String?,
          ),
          syncedAt: now,
        );
      },
    ).toList(
      growable: false,
    );

    await _database.upsertFestivalSummaries(
      festivals,
    );
  }

  Future<void> syncFestival(
    int festivalId,
  ) async {
    /*
     * Fetch all public festival resources concurrently.
     */
    final responses = await Future.wait([
      _dio.get<dynamic>(
        '/festivals/discover/'
        '$festivalId/',
      ),
      _dio.get<dynamic>(
        '/festivals/discover/'
        '$festivalId/stages/',
      ),
      _dio.get<dynamic>(
        '/festivals/discover/'
        '$festivalId/sets/',
      ),
    ]);

    final festivalJson =
        Map<String, dynamic>.from(
      responses[0].data as Map,
    );

    final stagesJson =
        (responses[1].data as List)
            .map(
              (item) =>
                  Map<String, dynamic>.from(
                item as Map,
              ),
            )
            .toList(
              growable: false,
            );

    final setsJson =
        (responses[2].data as List)
            .map(
              (item) =>
                  Map<String, dynamic>.from(
                item as Map,
              ),
            )
            .toList(
              growable: false,
            );

    final pendingLikes =
        await _database.getPendingLikes(
      festivalId: festivalId,
    );

    final pendingBySetId = {
      for (final pending in pendingLikes)
        pending.setId:
            pending.desiredIsLiked,
    };

    final now = DateTime.now().toUtc();

    final festival =
        CachedFestivalsCompanion.insert(
      id: Value(
        festivalJson['id'] as int,
      ),
      name: festivalJson['name']
              as String? ??
          'Festival',
      description: Value(
        festivalJson['description']
                as String? ??
            '',
      ),
      startDate: DateTime.parse(
        festivalJson['start_date']
            as String,
      ).toUtc(),
      endDate: DateTime.parse(
        festivalJson['end_date']
            as String,
      ).toUtc(),
      image: Value(
        festivalJson['image'] as String?,
      ),
      organiserName: Value(
        festivalJson['organiser_name']
                as String? ??
            '',
      ),
      organiserProfilePicture: Value(
        festivalJson[
                'organiser_profile_picture']
            as String?,
      ),
      syncedAt: now,
    );

    final stages = stagesJson.map(
      (json) {
        return CachedStagesCompanion.insert(
          id: Value(
            json['id'] as int,
          ),
          festivalId:
              json['festival'] as int,
          name: json['name'] as String? ??
              'Stage',
        );
      },
    ).toList(
      growable: false,
    );

    final serverLikeState = <int, bool>{};

    final sets = setsJson.map(
      (json) {
        final setId = json['id'] as int;

        final serverIsLiked =
            json['is_liked'] as bool? ??
                false;

        serverLikeState[setId] =
            serverIsLiked;

        /*
         * Pending local intent always wins over stale server
         * state while a mutation is waiting to reconcile.
         */
        final localIsLiked =
            pendingBySetId[setId] ??
                serverIsLiked;

        return CachedFestivalSetsCompanion
            .insert(
          id: Value(
            setId,
          ),
          festivalId:
              json['festival'] as int,
          stageId: json['stage'] as int,
          stageName:
              json['stage_name'] as String? ??
                  'Stage',
          artistId:
              json['artist'] as int,
          artistName:
              json['artist_name']
                      as String? ??
                  'Artist',
          startTime: DateTime.parse(
            json['start_time'] as String,
          ).toUtc(),
          endTime: DateTime.parse(
            json['end_time'] as String,
          ).toUtc(),
          image: Value(
            json['image'] as String?,
          ),
          displayImage: Value(
            json['display_image']
                as String?,
          ),
          isLiked: Value(
            localIsLiked,
          ),
          likeCount: Value(
            json['like_count'] as int? ??
                0,
          ),
          syncedAt: now,
        );
      },
    ).toList(
      growable: false,
    );

    /*
     * Replace the complete cached festival in one transaction.
     *
     * Pending desired states have already been overlaid, so
     * locally queued likes do not flicker back to stale server
     * values during synchronisation.
     */
    await _database.replaceFestival(
      festival: festival,
      stages: stages,
      sets: sets,
    );

    /*
     * Reconcile queued likes against Django after the refreshed
     * data has been written to SQLite.
     */
    await _flushPendingLikes(
      festivalId: festivalId,
      serverLikeState: serverLikeState,
    );

    /*
     * HomeWidget is a secondary presentation surface.
     *
     * A widget-platform failure must not make the primary SQLite
     * synchronisation fail.
     */
    await _updateWidgetSilently();
  }

  Future<void> setLike({
    required int festivalId,
    required int setId,
    required bool desiredIsLiked,
  }) async {
    /*
     * SQLite is the source of truth.
     *
     * This transaction updates the cached set and records the
     * desired final state in PendingSetLikes.
     *
     * If this operation succeeds, the local like operation has
     * succeeded. Later widget or network failures must not cause
     * the UI to roll it back.
     */
    await _database.setLocalLike(
      setId: setId,
      festivalId: festivalId,
      isLiked: desiredIsLiked,
    );

    /*
     * Updating HomeWidget is best-effort.
     *
     * HomeWidget may throw because of platform configuration,
     * an unavailable widget provider, app-group configuration or
     * another native integration issue.
     *
     * None of those conditions means the SQLite like failed.
     */
    await _updateWidgetSilently();

    /*
     * Try to reconcile immediately.
     *
     * A network failure is expected while offline. The pending
     * SQLite row remains queued for a later sync.
     */
    try {
      await _flushOnePendingLike(
        setId,
      );
    } catch (_) {
      // Leave the desired state queued.
    }
  }

  Future<void> flushAllPendingLikes() async {
    final pending =
        await _database.getPendingLikes();

    for (final item in pending) {
      try {
        await _flushOnePendingLike(
          item.setId,
        );
      } catch (_) {
        /*
         * Keep the item queued. A future app launch, refresh or
         * connectivity retry can reconcile it.
         */
      }
    }

    await _updateWidgetSilently();
  }

  Future<void> _flushPendingLikes({
    required int festivalId,
    required Map<int, bool>
        serverLikeState,
  }) async {
    final pending =
        await _database.getPendingLikes(
      festivalId: festivalId,
    );

    for (final item in pending) {
      final serverState =
          serverLikeState[item.setId];

      if (serverState == null) {
        continue;
      }

      if (serverState ==
          item.desiredIsLiked) {
        final localSets =
            await _database.getFestivalSets(
          festivalId,
        );

        var localLikeCount = 0;

        for (final set in localSets) {
          if (set.id == item.setId) {
            localLikeCount =
                set.likeCount;
            break;
          }
        }

        await _database.confirmLike(
          setId: item.setId,
          isLiked:
              item.desiredIsLiked,
          likeCount: localLikeCount,
        );

        continue;
      }

      try {
        final response =
            await _dio.post<dynamic>(
          '/festivals/sets/'
          '${item.setId}/like/',
        );

        final json =
            Map<String, dynamic>.from(
          response.data as Map,
        );

        await _database.confirmLike(
          setId: item.setId,
          isLiked:
              json['is_liked'] as bool,
          likeCount:
              json['like_count'] as int,
        );
      } catch (_) {
        // Keep the desired state queued.
      }
    }
  }

  Future<void> _flushOnePendingLike(
    int setId,
  ) async {
    final pending =
        await _database.getPendingLike(
      setId,
    );

    if (pending == null) {
      return;
    }

    /*
     * Django currently exposes a toggle endpoint rather than an
     * idempotent "set like state" endpoint.
     *
     * Fetch the current server state first and only toggle when
     * it differs from the locally desired state.
     */
    final response =
        await _dio.get<dynamic>(
      '/festivals/discover/'
      '${pending.festivalId}/sets/',
    );

    final data = response.data;

    if (data is! List) {
      throw const FormatException(
        'Expected festival sets endpoint '
        'to return a list.',
      );
    }

    Map<String, dynamic>? serverSet;

    for (final item in data) {
      if (item is! Map) {
        continue;
      }

      final json =
          Map<String, dynamic>.from(
        item,
      );

      if (json['id'] == setId) {
        serverSet = json;
        break;
      }
    }

    if (serverSet == null) {
      /*
       * Keep the mutation queued if the set is temporarily absent
       * from the public response.
       */
      return;
    }

    final serverIsLiked =
        serverSet['is_liked'] as bool? ??
            false;

    if (serverIsLiked ==
        pending.desiredIsLiked) {
      await _database.confirmLike(
        setId: setId,
        isLiked: serverIsLiked,
        likeCount:
            serverSet['like_count']
                    as int? ??
                0,
      );

      return;
    }

    final toggleResponse =
        await _dio.post<dynamic>(
      '/festivals/sets/'
      '$setId/like/',
    );

    final toggleData =
        toggleResponse.data;

    if (toggleData is! Map) {
      throw const FormatException(
        'Expected like endpoint to '
        'return an object.',
      );
    }

    final toggleJson =
        Map<String, dynamic>.from(
      toggleData,
    );

    await _database.confirmLike(
      setId: setId,
      isLiked:
          toggleJson['is_liked'] as bool,
      likeCount:
          toggleJson['like_count'] as int,
    );
  }

  /*
   * Updating the platform widget must never determine whether an
   * offline database operation succeeded.
   *
   * The app schedule remains authoritative and functional even
   * when the native widget cannot currently be updated.
   */
  Future<void> _updateWidgetSilently() async {
    try {
      await ScheduleWidgetService
          .updateFromDatabase(
        _database,
      );
    } catch (_) {
      /*
       * Ignore widget integration failures.
       *
       * A later successful update, app launch or reconciliation
       * will refresh the widget from the authoritative SQLite
       * state.
       */
    }
  }

  Future<void> clearAll() async {
    await _database.clearAllCachedData();

    await _updateWidgetSilently();
  }
}

final offlineFestivalRepositoryProvider =
    Provider<OfflineFestivalRepository>(
  (ref) {
    return OfflineFestivalRepository(
      dio: ref.watch(
        dioProvider,
      ),
      database: ref.watch(
        appDatabaseProvider,
      ),
    );
  },
);