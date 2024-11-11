class DashboardStats {
  final double targetRetribusi;
  final double realisasiRetribusi;
  final double todayIncome;
  final int totalPedagang;
  final int totalPasar;
  final double persentaseRealisasi;

  DashboardStats({
    required this.targetRetribusi,
    required this.realisasiRetribusi,
    required this.todayIncome,
    required this.totalPedagang,
    required this.totalPasar,
    required this.persentaseRealisasi,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    // Safely parse numeric values with default fallbacks
    double parseDouble(dynamic value, [double defaultValue = 0.0]) {
      if (value == null) return defaultValue;
      return (value is num) 
        ? value.toDouble() 
        : double.tryParse(value.toString()) ?? defaultValue;
    }

    // Safely parse integer values with default fallbacks
    int parseInt(dynamic value, [int defaultValue = 0]) {
      if (value == null) return defaultValue;
      return (value is num) 
        ? value.toInt() 
        : int.tryParse(value.toString()) ?? defaultValue;
    }

    // Calculate percentage of realization
    double calculatePersentaseRealisasi(double target, double realisasi) {
      if (target == 0) return 0.0;
      return (realisasi / target) * 100;
    }

    // Extract values from JSON, using null-safe parsing
    final target = parseDouble(json['target_retribusi']);
    final realisasi = parseDouble(json['realisasi_retribusi']);

    return DashboardStats(
      targetRetribusi: target,
      realisasiRetribusi: realisasi,
      todayIncome: parseDouble(json['today_income']),
      totalPedagang: parseInt(json['total_pedagang']),
      totalPasar: parseInt(json['total_pasar']),
      persentaseRealisasi: calculatePersentaseRealisasi(target, realisasi),
    );
  }

  // Convert to JSON for potential storage or transmission
  Map<String, dynamic> toJson() {
    return {
      'target_retribusi': targetRetribusi,
      'realisasi_retribusi': realisasiRetribusi,
      'today_income': todayIncome,
      'total_pedagang': totalPedagang,
      'total_pasar': totalPasar,
      'persentase_realisasi': persentaseRealisasi,
    };
  }

  // Getter for formatted percentage
  String get formattedPersentaseRealisasi {
    return '${persentaseRealisasi.toStringAsFixed(2)}%';
  }

  // Formatted currency method
  String formatCurrency(double value) {
    // You can customize this based on your locale
    return 'Rp ${value.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  // Formatted getters for easy access
  String get formattedTargetRetribusi => formatCurrency(targetRetribusi);
  String get formattedRealisasiRetribusi => formatCurrency(realisasiRetribusi);
  String get formattedTodayIncome => formatCurrency(todayIncome);
}