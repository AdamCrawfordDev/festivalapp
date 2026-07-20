class WidgetScheduleEntry {
  const WidgetScheduleEntry({
    required this.id,
    required this.festivalId,
    required this.artistName,
    required this.stageName,
    required this.startTime,
    required this.endTime,
    this.displayImage,
  });

  final int id;
  final int festivalId;

  final String artistName;
  final String stageName;

  final DateTime startTime;
  final DateTime endTime;

  final String? displayImage;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'festival_id': festivalId,
      'artist_name': artistName,
      'stage_name': stageName,
      'start_time': startTime.toUtc().toIso8601String(),
      'end_time': endTime.toUtc().toIso8601String(),
      'display_image': displayImage,
    };
  }
}
