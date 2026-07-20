import '../../database/app_database.dart';
import '../../models/festival.dart';
import '../../models/festival_set.dart';
import '../../models/stage.dart';

Festival cachedFestivalToModel(
  CachedFestival cached,
) {
  return Festival(
    id: cached.id,
    name: cached.name,
    description:
        cached.description,
    startDate:
        cached.startDate.toLocal(),
    endDate:
        cached.endDate.toLocal(),
    image:
        cached.image,
    organiserName:
        cached.organiserName,
    organiserProfilePicture:
        cached.organiserProfilePicture,
  );
}

Stage cachedStageToModel(
  CachedStage cached,
) {
  return Stage(
    id: cached.id,
    festivalId:
        cached.festivalId,
    name: cached.name,
  );
}

FestivalSet cachedSetToModel(
  CachedFestivalSet cached,
) {
  return FestivalSet(
    id: cached.id,
    festivalId:
        cached.festivalId,
    stageId:
        cached.stageId,
    stageName:
        cached.stageName,
    artistId:
        cached.artistId,
    artistName:
        cached.artistName,
    startTime:
        cached.startTime.toLocal(),
    endTime:
        cached.endTime.toLocal(),
    image:
        cached.image,
    displayImage:
        cached.displayImage,
    isLiked:
        cached.isLiked,
    likeCount:
        cached.likeCount,
  );
}
