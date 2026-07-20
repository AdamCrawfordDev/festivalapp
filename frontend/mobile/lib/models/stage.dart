class Stage {
  const Stage({
    required this.id,
    required this.festivalId,
    required this.name,
  });

  final int id;
  final int festivalId;
  final String name;

  factory Stage.fromJson(
    Map<String, dynamic> json,
  ) {
    return Stage(
      id: json['id'] as int,
      festivalId:
          json['festival'] as int,
      name:
          json['name'] as String? ??
          'Unnamed stage',
    );
  }
}