class DownloadedDesign {
  final String id;
  final String designId;
  final String title;
  final String localPath; // Path to downloaded file
  final DateTime downloadedAt;
  final int fileSizeInBytes;

  DownloadedDesign({
    required this.id,
    required this.designId,
    required this.title,
    required this.localPath,
    required this.downloadedAt,
    required this.fileSizeInBytes,
  });

  String get fileSizeInMB => (fileSizeInBytes / (1024 * 1024)).toStringAsFixed(2);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'designId': designId,
      'title': title,
      'localPath': localPath,
      'downloadedAt': downloadedAt.toIso8601String(),
      'fileSizeInBytes': fileSizeInBytes,
    };
  }

  factory DownloadedDesign.fromJson(Map<String, dynamic> json) {
    return DownloadedDesign(
      id: json['id'] as String,
      designId: json['designId'] as String,
      title: json['title'] as String,
      localPath: json['localPath'] as String,
      downloadedAt: DateTime.parse(json['downloadedAt']),
      fileSizeInBytes: json['fileSizeInBytes'] as int,
    );
  }
}
