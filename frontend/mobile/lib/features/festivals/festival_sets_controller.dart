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

  final Set<int> _pendingSetIds = <int>{};

  @override
  Future<List<FestivalSet>> build() async {
    final provider = offlineFestivalProvider(
      festivalId,
    );

    /*
     * Listen to future SQLite-backed updates without watching
     * provider.future from this asynchronous build method.
     *
     * The listener's types are deliberately inferred from
     * `provider`. This avoids coupling this controller to the
     * generated Drift row types or requiring an explicit
     * OfflineFestivalBundle type annotation.
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
           * Ignore loading and error emissions after cached data
           * has already been displayed.
           *
           * The current schedule remains visible and mounted.
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
     * Read the initial offline bundle once.
     *
     * Later Drift emissions are handled by the listener above,
     * without rebuilding this asynchronous controller.
     */
    final initialBundle = await ref.read(
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
     * Keep the cached schedule visible while the repository
     * attempts to refresh it from Django.
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

    final currentSets = state.asData?.value;

    if (currentSets == null) {
      return;
    }

    final setIndex = currentSets.indexWhere(
      (festivalSet) {
        return festivalSet.id == setId;
      },
    );

    if (setIndex == -1) {
      return;
    }

    final originalSet = currentSets[setIndex];

    final nextIsLiked = !originalSet.isLiked;

    final nextLikeCount = nextIsLiked
        ? originalSet.likeCount + 1
        : originalSet.likeCount > 0
            ? originalSet.likeCount - 1
            : 0;

    _pendingSetIds.add(
      setId,
    );

    /*
     * Apply the optimistic change immediately.
     *
     * The provider remains AsyncData throughout the operation,
     * preventing FestivalScreen from replacing the schedule with
     * its loading sliver.
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
       * OfflineFestivalController delegates this operation to the
       * offline repository.
       *
       * The repository writes to SQLite first, updates the home
       * widget, queues the desired mutation and attempts to
       * reconcile it with Django.
       *
       * Network failures leave the operation queued and do not
       * cause an optimistic rollback.
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
       * This rollback is only for a local failure, such as the
       * SQLite write failing.
       *
       * Normal offline network failures are handled internally by
       * the repository and do not reach this block.
       */
      final latestSets = state.asData?.value;

      if (latestSets != null) {
        final rollbackIndex =
            latestSets.indexWhere(
          (festivalSet) {
            return festivalSet.id == setId;
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
    Provider.family<List<FestivalSet>, int>(
  (
    ref,
    festivalId,
  ) {
    final sets = ref.watch(
      festivalSetsProvider(
        festivalId,
      ),
    );

    final items = sets.asData?.value;

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