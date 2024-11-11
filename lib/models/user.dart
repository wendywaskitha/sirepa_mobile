import 'dart:convert';

class User {
  final int id;
  final String name;
  final String email;
  final String? token;
  final List<String> roles;
  final List<Pasar> pasars;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    required this.roles,
    required this.pasars,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? json['access_token'],
      roles: json['roles'] != null
          ? List<String>.from(json['roles'].map((role) => role.toString()))
          : [],
      pasars: json['pasars'] != null
          ? (json['pasars'] as List)
              .map((pasar) => Pasar.fromJson(pasar))
              .toList()
          : [],
    );
  }

  String get marketName {
    try {
      if (pasars.isNotEmpty) {
        final firstPasar = pasars.first; // firstPasar is of type Pasar
        return firstPasar.name; // Access the name property directly
      }
      return 'Tidak diketahui';
    } catch (e) {
      print('Error in marketName getter: $e');
      return 'Tidak diketahui';
    }
  }

  // Factory constructor for API response
  factory User.fromApiResponse(Map<String, dynamic> json) {
    final userData = json['data']['user'] ?? json;
    return User(
      id: userData['id'] ?? 0,
      name: userData['name'] ?? '',
      email: userData['email'] ?? '',
      token: json['data']?['token'],
      roles: userData['roles'] != null
          ? List<String>.from(userData['roles'].map((role) => role.toString()))
          : [],
      pasars: userData['pasars'] != null
          ? (userData['pasars'] as List)
              .map((pasar) => Pasar.fromJson(pasar))
              .toList()
          : [],
    );
  }

  // Convert user to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'roles': roles,
      'pasars': pasars.map((pasar) => pasar.toJson()).toList(),
    };
  }

  // Convert user to JSON string for storage
  String toJsonString() {
    return jsonEncode(toJson());
  }

  // Create user from JSON string
  factory User.fromJsonString(String jsonString) {
    return User.fromJson(jsonDecode(jsonString));
  }

  // Check if user has a specific role
  bool hasRole(String role) {
    return roles.contains(role);
  }

  // Check if user is a kolektor
  bool get isKolektor => hasRole('kolektor');
}

class Pasar {
  final int id;
  final String name;
  final String? address;
  final double? latitude;
  final double? longitude;

  Pasar(
      {required this.id,
      required this.name,
      this.address,
      this.latitude,
      this.longitude});

  factory Pasar.fromJson(Map<String, dynamic> json) {
    return Pasar(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'],
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  String toString() {
    return name;
  }
}
