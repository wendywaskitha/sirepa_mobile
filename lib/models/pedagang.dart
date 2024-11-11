class Pedagang {
  final int id;
  final String name;
  final String? nik;
  final String? alamat;
  final int pasarId;
  final String? pasarName;

  Pedagang({
    required this.id,
    required this.name,
    this.nik,
    this.alamat,
    required this.pasarId,
    this.pasarName,
  });

  factory Pedagang.fromJson(Map<String, dynamic> json) {
    return Pedagang(
      id: json['id'],
      name: json['name'] ?? '',
      nik: json['nik'],
      alamat: json['alamat'],
      pasarId: json['pasar_id'],
      // If pasar is a nested object
      pasarName: json['pasar'] != null ? json['pasar']['name'] : null,
    );
  }
}