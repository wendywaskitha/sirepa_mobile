class RetribusiPembayaran {
  final int id;
  final int pedagangId;
  final int pasarId;
  final DateTime tanggalBayar;
  final String status;
  final double totalBiaya;
  final Pedagang pedagang;
  final Pasar pasar;
  final User user;
  final List<Item> items;

  RetribusiPembayaran({
    required this.id,
    required this.pedagangId,
    required this.pasarId,
    required this.tanggalBayar,
    required this.status,
    required this.totalBiaya,
    required this.pedagang,
    required this.pasar,
    required this.user,
    required this.items,
  });

  factory RetribusiPembayaran.fromJson(Map<String, dynamic> json) {
    return RetribusiPembayaran(
      id: json['id'],
      pedagangId: json['pedagang_id'],
      pasarId: json['pasar_id'],
      tanggalBayar: DateTime.parse(json['tanggal_bayar']),
      status: json['status'],
      totalBiaya: (json['total_biaya'] is String)
          ? double.parse(json['total_biaya'])
          : json['total_biaya'].toDouble(), // Handle both string and double
      pedagang: Pedagang.fromJson(json['pedagang']),
      pasar: Pasar.fromJson(json['pasar']),
      user: User.fromJson(json['user']),
      items: List<Item>.from(json['items'].map((item) => Item.fromJson(item))),
    );
  }
}

class Pedagang {
  final int id;
  final String name;
  final String nik;
  final String pasarName;

  Pedagang({
    required this.id,
    required this.name,
    required this.nik,
    required this.pasarName,
  });

  factory Pedagang.fromJson(Map<String, dynamic> json) {
    return Pedagang(
      id: json['id'],
      name: json['name'],
      nik: json['nik'],
      pasarName: json['pasar_name'],
    );
  }
}

class Pasar {
  final int id;
  final String name;

  Pasar({
    required this.id,
    required this.name,
  });

  factory Pasar.fromJson(Map<String, dynamic> json) {
    return Pasar(
      id: json['id'],
      name: json['name'],
    );
  }
}

class User {
  final int id;
  final String name;

  User({
    required this.id,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Item {
  final int id;
  final String retribusiName;
  final double biaya;

  Item({
    required this.id,
    required this.retribusiName,
    required this.biaya,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      retribusiName: json['retribusi_name'],
      biaya: (json['biaya'] is String)
          ? double.parse(json['biaya'])
          : json['biaya'].toDouble(), // Handle both string and double
    );
  }
}