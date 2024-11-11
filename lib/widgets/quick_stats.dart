import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Example icon library

class QuickStats extends StatelessWidget {
  final int paidCount;
  final int unpaidCount;
  final int totalCount;
  final int pendingCount;

  const QuickStats({
    Key? key,
    required this.paidCount,
    required this.unpaidCount,
    required this.totalCount,
    required this.pendingCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Slightly wider for a modern look
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            Colors.teal.shade400,
            Colors.blue.shade600
          ], // Modern gradient colors
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(16), // Padding for spaciousness
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kinerja Harian',
            style: TextStyle(
              fontSize: 20, // Increased font size for title
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12), // Increased space
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5, // Adjusted aspect ratio for modern cards
            children: [
              _buildStatCard(
                icon: FontAwesomeIcons.checkCircle,
                label: 'Sudah Bayar',
                value: paidCount.toString(),
                color: Colors.green.shade400,
              ),
              _buildStatCard(
                icon: FontAwesomeIcons.timesCircle,
                label: 'Belum Bayar',
                value: unpaidCount.toString(),
                color: Colors.red.shade400,
              ),
              _buildStatCard(
                icon: FontAwesomeIcons.infoCircle,
                label: 'Total',
                value: totalCount.toString(),
                color: Colors.blue.shade400,
              ),
              _buildStatCard(
                icon: FontAwesomeIcons.hourglassHalf,
                label: 'Pending',
                value: pendingCount.toString(),
                color: Colors.orange.shade400,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Stat Card Widget
  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Background color for the stat card
        borderRadius:
            BorderRadius.circular(10), // Rounded corners for modern look
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2), // Shadow position
          ),
        ],
      ),
      margin: const EdgeInsets.all(8), // Margin around each card
      padding: const EdgeInsets.all(12), // Padding inside each card
      child: Row(
        children: [
          Icon(icon, size: 30, color: color), // Updated icon size
          const SizedBox(width: 8), // Increased space
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 14), // Updated font size
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18, // Updated font size
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
