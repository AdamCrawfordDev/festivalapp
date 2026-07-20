class FestivalSet {
  const FestivalSet({
    required this.id,
    required this.festivalId,
    required this.stageId,
    required this.stageName,
    required this.artistId,
    required this.artistName,
    required this.startTime,
    required this.endTime,
    required this.image,
    required this.displayImage,
    required this.isLiked,
    required this.likeCount,
  });

  final int id;
  final int festivalId;

  final int stageId;
  final String stageName;

  final int artistId;
  final String artistName;

  final DateTime startTime;
  final DateTime endTime;

  final String? image;
  final String? displayImage;

  final bool isLiked;
  final int likeCount;

  factory FestivalSet.fromJson(
    Map<String, dynamic> json,
  ) {
    return FestivalSet(
      id: json['id'] as int,
      festivalId:
          json['festival'] as int,
      stageId:
          json['stage'] as int,
      stageName:
          json['stage_name']
                  as String? ??
              'Unknown stage',
      artistId:
          json['artist'] as int,
      artistName:
          json['artist_name']
                  as String? ??
              'Unknown artist',
      startTime: DateTime.parse(
        json['start_time'] as String,
      ),
      endTime: DateTime.parse(
        json['end_time'] as String,
      ),
      image:
          json['image'] as String?,
      displayImage:
          json['display_image']
              as String?,
      isLiked:
          json['is_liked'] as bool? ??
          false,
      likeCount:
          json['like_count'] as int? ??
          0,
    );
  }

  FestivalSet copyWith({
    bool? isLiked,
    int? likeCount,
  }) {
    return FestivalSet(
      id: id,
      festivalId: festivalId,
      stageId: stageId,
      stageName: stageName,
      artistId: artistId,
      artistName: artistName,
      startTime: startTime,
      endTime: endTime,
      image: image,
      displayImage: displayImage,
      isLiked:
          isLiked ?? this.isLiked,
      likeCount:
          likeCount ?? this.likeCount,
    );
  }
}