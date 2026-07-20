import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/app_database.dart';
import '../../models/offline_festival_bundle.dart';
import '../../repositories/offline_festival_repository.dart';

class OfflineFestivalController
    extends AsyncNotifier<
      OfflineFestivalBundle
    > {
  OfflineFestivalController(
    this.festivalId,
  );

  final int festivalId;

  StreamSubscription<
    CachedFestival?
  >? _festivalSubscription;

  StreamSubscription<
    List<CachedStage>
  >? _stageSubscription;

  StreamSubscription<
    List<CachedFestivalSet>
  >? _setSubscription;

  CachedFestival? _festival;
  List<CachedStage> _stages =
      const [];
  List<CachedFestivalSet> _sets =
      const [];

  bool _isSyncing = false;
  Object? _syncError;

  @override
  Future<OfflineFestivalBundle>
      build() async {
    final repository = ref.read(
      offlineFestivalRepositoryProvider,
    );

    final initialFestival =
        Completer<void>();
    final initialStages =
        Completer<void>();
    final initialSets =
        Completer<void>();

    _festivalSubscription =
        repository
            .watchFestival(
              festivalId,
            )
            .listen(
      (festival) {
        _festival = festival;

        if (!initialFestival.isCompleted) {
          initialFestival.complete();
        }

        _emit();
      },
      onError: (
        Object error,
        StackTrace stackTrace,
      ) {
        if (!initialFestival.isCompleted) {
          initialFestival.completeError(
            error,
            stackTrace,
          );
        }
      },
    );

    _stageSubscription =
        repository
            .watchStages(
              festivalId,
            )
            .listen(
      (stages) {
        _stages = stages;

        if (!initialStages.isCompleted) {
          initialStages.complete();
        }

        _emit();
      },
      onError: (
        Object error,
        StackTrace stackTrace,
      ) {
        if (!initialStages.isCompleted) {
          initialStages.completeError(
            error,
            stackTrace,
          );
        }
      },
    );

    _setSubscription =
        repository
            .watchSets(
              festivalId,
            )
            .listen(
      (sets) {
        _sets = sets;

        if (!initialSets.isCompleted) {
          initialSets.complete();
        }

        _emit();
      },
      onError: (
        Object error,
        StackTrace stackTrace,
      ) {
        if (!initialSets.isCompleted) {
          initialSets.completeError(
            error,
            stackTrace,
          );
        }
      },
    );

    ref.onDispose(() {
      _festivalSubscription?.cancel();
      _stageSubscription?.cancel();
      _setSubscription?.cancel();
    });

    await Future.wait([
      initialFestival.future,
      initialStages.future,
      initialSets.future,
    ]);

    /*
     * Cached data is returned immediately. Network sync
     * happens without delaying the first usable screen.
     */
    unawaited(
      syncSilently(),
    );

    return _currentBundle();
  }

  OfflineFestivalBundle
      _currentBundle() {
    return OfflineFestivalBundle(
      festival:
          _festival,
      stages:
          List.unmodifiable(
        _stages,
      ),
      sets:
          List.unmodifiable(
        _sets,
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
      _currentBundle(),
    );
  }

  Future<void> syncSilently() async {
    _isSyncing = true;
    _syncError = null;
    _emit();

    try {
      await ref
          .read(
            offlineFestivalRepositoryProvider,
          )
          .syncFestival(
            festivalId,
          );
    } catch (error) {
      _syncError = error;
    } finally {
      _isSyncing = false;
      _emit();
    }
  }

  Future<void> forceSync() async {
    _isSyncing = true;
    _syncError = null;
    _emit();

    try {
      await ref
          .read(
            offlineFestivalRepositoryProvider,
          )
          .syncFestival(
            festivalId,
          );
    } catch (error) {
      _syncError = error;
      rethrow;
    } finally {
      _isSyncing = false;
      _emit();
    }
  }

  Future<void> setLike({
    required int setId,
    required bool isLiked,
  }) {
    return ref
        .read(
          offlineFestivalRepositoryProvider,
        )
        .setLike(
          festivalId:
              festivalId,
          setId:
              setId,
          desiredIsLiked:
              isLiked,
        );
  }
}

final offlineFestivalProvider =
    AsyncNotifierProvider.family<
      OfflineFestivalController,
      OfflineFestivalBundle,
      int
    >(
  OfflineFestivalController.new,
);
