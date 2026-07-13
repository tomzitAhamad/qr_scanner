class HistoryItem {
  final String data;
  final DateTime scanTime;
  final String scanType;

  HistoryItem({
    required this.data,
    required this.scanTime,
    required this.scanType,
  });

  Map<String, dynamic> toJson() => {
        'data': data,
        'scanTime': scanTime.toIso8601String(),
        'scanType': scanType,
      };

  factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
        data: json['data'] as String,
        scanTime: DateTime.parse(json['scanTime'] as String),
        scanType: json['scanType'] as String,
      );
}
