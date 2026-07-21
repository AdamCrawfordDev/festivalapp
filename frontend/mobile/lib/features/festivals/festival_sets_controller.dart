import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/festival_set.dart';
import 'offline_festival_controller.dart';
import 'offline_model_mappers.dart';

class FestivalSetsController
    extends AsyncNotifier<List<FestivalSet>> {
  FestivalSetsController(
    this.festivalId,
  );

  final int festivalId;

  final Set<int> _pendingSetIds =
      <int>{};

  @override
  Future<List<FestivalSet>>
      build() async {
    final provider =
        offlineFestivalProvider(
      festivalId,
    );

    /*
     * Keep this controller synchronised with the
     * SQLite-backed festival provider.
     *
     * Cached data remains visible while network
     * synchronisation happens in the background.
     */
    ref.listen(
      provider,
      (
        previous,
        next,
      ) {
        final data = next.asData;

        if (data == null) {
          /*
           * Ignore loading and error emissions after
           * cached schedule data has been displayed.
           *
           * This prevents the schedule from disappearing
           * during a background refresh.
           */
          return;
        }

        final nextSets =
            List<FestivalSet>.unmodifiable(
          data.value.sets.map(
            cachedSetToModel,
          ),
        );

        state = AsyncData(
          nextSets,
        );
      },
    );

    /*
     * Read the initial cached bundle once.
     *
     * Future Drift changes are handled by the listener
     * above without rebuilding this asynchronous
     * controller.
     */
    final initialBundle =
        await ref.read(
      provider.future,
    );

    return List<FestivalSet>.unmodifiable(
      initialBundle.sets.map(
        cachedSetToModel,
      ),
    );
  }

  bool isSetPending(
    int setId,
  ) {
    return _pendingSetIds.contains(
      setId,
    );
  }

  Future<void> refresh() async {
    /*
     * Keep the cached schedule mounted while the
     * repository refreshes festival data from Django.
     */
    await ref
        .read(
          offlineFestivalProvider(
            festivalId,
          ).notifier,
        )
        .forceSync();
  }

  Future<void> toggleLike(
    int setId,
  ) async {
    if (_pendingSetIds.contains(setId)) {
      return;
    }

    final currentSets =
        state.asData?.value;

    if (currentSets == null) {
      return;
    }

    final setIndex =
        currentSets.indexWhere(
      (festivalSet) {
        return festivalSet.id ==
            setId;
      },
    );

    if (setIndex == -1) {
      return;
    }

    final originalSet =
        currentSets[setIndex];

    final nextIsLiked =
        !originalSet.isLiked;

    final nextLikeCount =
        nextIsLiked
            ? originalSet.likeCount + 1
            : originalSet.likeCount > 0
                ? originalSet.likeCount - 1
                : 0;

    _pendingSetIds.add(
      setId,
    );

    /*
     * Apply the optimistic state immediately.
     *
     * The controller remains AsyncData throughout the
     * operation, preventing the schedule screen from
     * being replaced by a loading state.
     */
    final optimisticSets =
        List<FestivalSet>.from(
      currentSets,
    );

    optimisticSets[setIndex] =
        originalSet.copyWith(
      isLiked: nextIsLiked,
      likeCount: nextLikeCount,
    );

    state = AsyncData(
      List<FestivalSet>.unmodifiable(
        optimisticSets,
      ),
    );

    try {
      /*
       * OfflineFestivalController delegates to the
       * offline repository.
       *
       * The repository:
       *
       * 1. writes the desired state to SQLite;
       * 2. stores a pending server mutation;
       * 3. attempts to reconcile the desired state
       *    with Django;
       * 4. asks WidgetKit to reload the schedule
       *    widget after Django confirms the state.
       *
       * A normal network failure leaves the mutation
       * queued and does not cause this optimistic
       * change to roll back.
       */
      await ref
          .read(
            offlineFestivalProvider(
              festivalId,
            ).notifier,
          )
          .setLike(
            setId: setId,
            isLiked: nextIsLiked,
          );
    } catch (
      error,
      stackTrace
    ) {
      /*
       * This catch block represents a genuine local
       * failure, such as SQLite failing to persist the
       * desired state.
       *
       * Normal offline network failures are handled
       * by the repository and do not reach here.
       */
      final latestSets =
          state.asData?.value;

      if (latestSets != null) {
        final rollbackIndex =
            latestSets.indexWhere(
          (festivalSet) {
            return festivalSet.id ==
                setId;
          },
        );

        if (rollbackIndex != -1) {
          final rollbackSets =
              List<FestivalSet>.from(
            latestSets,
          );

          rollbackSets[rollbackIndex] =
              originalSet;

          state = AsyncData(
            List<FestivalSet>.unmodifiable(
              rollbackSets,
            ),
          );
        }
      }

      Error.throwWithStackTrace(
        error,
        stackTrace,
      );
    } finally {
      _pendingSetIds.remove(
        setId,
      );
    }
  }
}

final festivalSetsProvider =
    AsyncNotifierProvider.family<
      FestivalSetsController,
      List<FestivalSet>,
      int
    >(
  FestivalSetsController.new,
);

final likedFestivalSetsProvider =
    Provider.family<
      List<FestivalSet>,
      int
    >(
  (
    ref,
    festivalId,
  ) {
    final sets = ref.watch(
      festivalSetsProvider(
        festivalId,
      ),
    );

    final items =
        sets.asData?.value;

    if (items == null) {
      return const <FestivalSet>[];
    }

    return List<FestivalSet>.unmodifiable(
      items.where(
        (festivalSet) {
          return festivalSet.isLiked;
        },
      ),
    );
  },
);