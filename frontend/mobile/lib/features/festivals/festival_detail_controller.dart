import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/festival.dart';
import '../../models/stage.dart';
import 'offline_festival_controller.dart';
import 'offline_model_mappers.dart';

final festivalDetailProvider =
    Provider.family<
      AsyncValue<Festival>,
      int
    >(
  (ref, festivalId) {
    final bundle = ref.watch(
      offlineFestivalProvider(
        festivalId,
      ),
    );

    return bundle.whenData(
      (offlineBundle) {
        final cachedFestival =
            offlineBundle.festival;

        if (cachedFestival == null) {
          throw StateError(
            'This festival has not been '
            'downloaded yet.',
          );
        }

        return cachedFestivalToModel(
          cachedFestival,
        );
      },
    );
  },
);

final festivalStagesProvider =
    Provider.family<
      AsyncValue<List<Stage>>,
      int
    >(
  (ref, festivalId) {
    final bundle = ref.watch(
      offlineFestivalProvider(
        festivalId,
      ),
    );

    return bundle.whenData(
      (offlineBundle) {
        return List.unmodifiable(
          offlineBundle.stages.map(
            cachedStageToModel,
          ),
        );
      },
    );
  },
);