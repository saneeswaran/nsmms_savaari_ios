// models/commission_model.dart
class Commission {
  final double percentage;
  final DateTime lastUpdated;

  Commission({
    required this.percentage,
    required this.lastUpdated,
  });

  factory Commission.fromJson(Map<String, dynamic> json) => Commission(
    percentage: json['percentage']?.toDouble() ?? 0.0,
    lastUpdated: DateTime.parse(json['lastUpdated']),
  );

  Map<String, dynamic> toJson() => {
    'percentage': percentage,
    'lastUpdated': lastUpdated.toIso8601String(),
  };
}