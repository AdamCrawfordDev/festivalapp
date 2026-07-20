import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/app_database.dart';
import '../../models/festival.dart';
import '../../repositories/offline_festival_repository.dart';
import 'offline_model_mappers.dart';

class FestivalListState {
  const FestivalListState({
    required this.festivals,
    required this.isSyncing,
    this.syncError,
  });

  final List<Festival> festivals;
  final bool isSyncing;
  final Object? syncError;
}

class FestivalListController
    extends AsyncNotifier<
      FestivalListState
    > {
  StreamSubscription<
    List<CachedFestival>
  >? _festivalSubscription;

  List<CachedFestival>
      _cachedFestivals =
      const [];

  bool _isSyncing = false;
  Object? _syncError;

  @override
  Future<FestivalListState>
      build() async {
    final repository = ref.read(
      offlineFestivalRepositoryProvider,
    );

    final initialFestivals =
        Completer<void>();

    _festivalSubscription =
        repository
            .watchFestivals()
            .listen(
      (festivals) {
        _cachedFestivals =
            festivals;

        if (
          !initialFestivals
              .isCompleted
        ) {
          initialFestivals.complete();
        }

        _emit();
      },
      onError: (
        Object error,
        StackTrace stackTrace,
      ) {
        if (
          !initialFestivals
              .isCompleted
        ) {
          initialFestivals
              .completeError(
            error,
            stackTrace,
          );
        }
      },
    );

    ref.onDispose(() {
      _festivalSubscription
          ?.cancel();
    });

    /*
     * Drift emits immediately, including when the database
     * contains no festivals. Waiting for this first event
     * ensures the initial screen is based on local data.
     */
    await initialFestivals.future;

    /*
     * Return local data first. The network request runs
     * without blocking the first usable screen.
     */
    unawaited(
      syncSilently(),
    );

    return _currentState();
  }

  FestivalListState
      _currentState() {
    final festivals =
        _cachedFestivals
            .map(
              cachedFestivalToModel,
            )
            .toList(
              growable: false,
            );

    return FestivalListState(
      festivals:
          List.unmodifiable(
        festivals,
      ),
      isSyncing:
          _isSyncing,
      syncError:
          _syncError,
    );
  }

  void _emit() {
    if (!state.hasValue) {
      return;
    }

    state = AsyncData(
      _currentState(),
    );
  }

  Future<void> syncSilently() async {
    if (_isSyncing) {
      return;
    }

    _isSyncing = true;
    _syncError = null;
    _emit();

    try {
      await ref
          .read(
            offlineFestivalRepositoryProvider,
          )
          .syncFestivalList();
    } catch (error) {
      /*
       * Keep displaying whatever is already in SQLite.
       * A connection failure is a refresh failure, not a
       * reason to discard the cached festival list.
       */
      _syncError = error;
    } finally {
      _isSyncing = false;
      _emit();
    }
  }

  Future<void> forceSync() async {
    if (_isSyncing) {
      return;
    }

    _isSyncing = true;
    _syncError = null;
    _emit();

    try {
      await ref
          .read(
            offlineFestivalRepositoryProvider,
          )
          .syncFestivalList();
    } catch (error) {
      _syncError = error;
      rethrow;
    } finally {
      _isSyncing = false;
      _emit();
    }
  }
}

final festivalListProvider =
    AsyncNotifierProvider<
      FestivalListController,
      FestivalListState
    >(
  FestivalListController.new,
);