import 'package:flutter/material.dart';

class PlayerAttendanceCard extends StatelessWidget {
  final String playerName;
  final String jerseyNumber;
  final String selectedStatus; // 'حاضر', 'غائب', 'متأخر'
  final ValueChanged<String> onStatusChanged;

  const PlayerAttendanceCard({
    super.key,
    required this.playerName,
    required this.jerseyNumber,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    Color getStatusColor(String status) {
      switch (status) {
        case 'حاضر':
          return Colors.green;
        case 'غائب':
          return Colors.red;
        case 'متأخر':
          return Colors.orange;
        default:
          return Colors.grey;
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Player Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playerName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'رقم القميص: $jerseyNumber',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Status Buttons
            Row(
              children: ['حاضر', 'غائب', 'متأخر'].map((status) {
                final isSelected = selectedStatus == status;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ElevatedButton(
                    onPressed: () => onStatusChanged(status),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? getStatusColor(status)
                          : Colors.grey[200],
                      foregroundColor:
                          isSelected ? Colors.white : Colors.black87,
                      minimumSize: const Size(60, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    child: Text(status, style: const TextStyle(fontSize: 12)),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
