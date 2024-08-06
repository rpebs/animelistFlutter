class Ongoing {
  final String title;
  final String thumb;
  final String totalEpisode;
  final String updatedOn;
  final String updatedDay;
  final String endpoint;

  Ongoing({
    required this.title,
    required this.thumb,
    required this.totalEpisode,
    required this.updatedOn,
    required this.updatedDay,
    required this.endpoint,
  });

  factory Ongoing.fromJson(Map<String, dynamic> json) {
    return Ongoing(
      title: json['title'],
      thumb: json['thumb'],
      totalEpisode: json['total_episode'],
      updatedOn: json['updated_on'],
      updatedDay: json['updated_day'],
      endpoint: json['endpoint'],
    );
  }
}
