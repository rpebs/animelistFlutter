class Anime {
  final String id;
  final String title;
  final String posterImage;
  final int? episodeCount;
  final String? averageRating;

  Anime({
    required this.id,
    required this.title,
    required this.posterImage,
    this.episodeCount,
    this.averageRating,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['id'] as String,
      title: json['attributes']['canonicalTitle'] as String,
      posterImage: json['attributes']['posterImage']['medium'] as String,
      episodeCount: json['attributes']['episodeCount'] as int?,
      averageRating: json['attributes']['averageRating'] as String?,
    );
  }
}
