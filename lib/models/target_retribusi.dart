// models/target_retribusi.dart
class TargetRetribusi {
  final int id;
  final String tahun;
  final String targetAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  TargetRetribusi({
    required this.id,
    required this.tahun,
    required this.targetAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TargetRetribusi.fromJson(Map<String, dynamic> json) {
    return TargetRetribusi(
      id: json['id'],
      tahun: json['tahun'],
      targetAmount: json['target_amount'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}