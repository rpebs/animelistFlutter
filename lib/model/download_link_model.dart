class DownloadLink {
  final String quality;
  final String odFiles;
  final String pdrain;
  final String acefile;
  final String goFile;
  final String mega;
  final String kFiles;

  DownloadLink({
    required this.quality,
    required this.odFiles,
    required this.pdrain,
    required this.acefile,
    required this.goFile,
    required this.mega,
    required this.kFiles,
  });

  factory DownloadLink.fromJson(Map<String, dynamic> json) {
    return DownloadLink(
      quality: json['quality'],
      odFiles: json['odFiles'],
      pdrain: json['pdrain'],
      acefile: json['acefile'],
      goFile: json['goFile'],
      mega: json['mega'],
      kFiles: json['kFiles'],
    );
  }
}
