// lib/widgets/quick_actions.dart

import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback onPaymentTap;
  final VoidCallback onReportTap;

  const QuickActions({
    Key? key,
    required this.onPaymentTap,
    required this.onReportTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionCard(
                icon: Icons.payment,
                label: 'Pembayaran',
                onTap: onPaymentTap,
              ),
              _buildActionCard(
                icon: Icons.receipt,
                label: 'Laporan',
                onTap: onReportTap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Action Card Widget
  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: Colors.blue.shade800),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(fontSize: 16, color: Colors.blue.shade800)),
          ],
        ),
      ),
    );
  }
}