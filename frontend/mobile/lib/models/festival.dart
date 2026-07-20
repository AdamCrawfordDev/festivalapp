class Festival {
  const Festival({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.image,
    required this.organiserName,
    required this.organiserProfilePicture,
  });

  final int id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String? image;
  final String organiserName;
  final String? organiserProfilePicture;

  factory Festival.fromJson(
    Map<String, dynamic> json,
  ) {
    return Festival(
      id: json['id'] as int,
      name:
          json['name'] as String? ??
          'Unnamed festival',
      description:
          json['description'] as String? ??
          '',
      startDate: DateTime.parse(
        json['start_date'] as String,
      ),
      endDate: DateTime.parse(
        json['end_date'] as String,
      ),
      image: json['image'] as String?,
      organiserName:
          json['organiser_name']
              as String? ??
          '',
      organiserProfilePicture:
          json['organiser_profile_picture']
              as String?,
    );
  }
}