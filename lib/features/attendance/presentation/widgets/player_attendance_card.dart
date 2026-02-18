import 'package:blue_bird/core/responsive_helper/size_helper_extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerAttendanceCard extends StatefulWidget {
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
  State<PlayerAttendanceCard> createState() => _PlayerAttendanceCardState();
}

class _PlayerAttendanceCardState extends State<PlayerAttendanceCard> {
  Color _getStatusColor(String status) {
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: context.setWidth(16),
        vertical: context.setHeight(8),
      ),
      elevation: context.setMinSize(2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          context.setMinSize(12),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          context.setWidth(12),
        ),
        child: Row(
          children: [
            /// Player Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.playerName,
                    style: GoogleFonts.balooThambi2(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: context.setSp(16),
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: context.setHeight(4)),
                  Text(
                    'رقم القميص: ${widget.jerseyNumber}',
                    style: GoogleFonts.balooThambi2(
                      textStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: context.setSp(14),
                      ),
                    ),
                  ),
                  if (widget.selectedStatus.isEmpty)
                    Text(
                      'لم يتم اختيار الحالة بعد',
                      style: GoogleFonts.balooThambi2(
                        textStyle: TextStyle(
                          color: Colors.orange,
                          fontSize: context.setSp(12),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            /// Status Buttons
            Row(
              children: ['حاضر', 'غائب', 'متأخر'].map((status) {
                final isSelected = widget.selectedStatus == status;

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.setWidth(4),
                  ),
                  child: SizedBox(
                    width: context.setWidth(56),
                    height: context.setHeight(36),
                    child: ElevatedButton(
                      onPressed: () => widget.onStatusChanged(status),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? _getStatusColor(status)
                            : Colors.grey.shade200,
                        foregroundColor:
                            isSelected ? Colors.white : Colors.black87,
                        padding: EdgeInsets.symmetric(
                          horizontal: context.setWidth(4),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            context.setMinSize(8),
                          ),
                        ),
                      ),
                      child: Text(
                        status,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.balooThambi2(
                          textStyle: TextStyle(
                            fontSize: context.setSp(12),
                          ),
                        ),
                      ),
                    ),
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
