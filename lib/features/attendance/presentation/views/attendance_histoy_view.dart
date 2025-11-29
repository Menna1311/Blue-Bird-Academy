import 'package:blue_bird/features/attendance/data/models/attendance_history_model.dart';
import 'package:blue_bird/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  final String trainerId;
  final String teamId;

  const AttendanceHistoryScreen({
    super.key,
    required this.trainerId,
    required this.teamId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<AttendanceCubit>()..getHistory(trainerId, teamId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("سجل الحضور الشهري"),
          centerTitle: true,
        ),
        body: BlocBuilder<AttendanceCubit, AttendanceState>(
          builder: (context, state) {
            if (state is AttendanceHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AttendanceHistoryLoaded) {
              final history = state.history;

              if (history.isEmpty) {
                return const Center(
                  child: Text("لا يوجد سجل حضور لهذا الشهر"),
                );
              }

              // Group by sessionDate
              final Map<String, List<AttendanceHistoryModel>> grouped = {};
              for (var record in history) {
                grouped.putIfAbsent(record.sessionDate, () => []).add(record);
              }

              final sessionDates = grouped.keys.toList()..sort();

              return ListView(
                padding: const EdgeInsets.all(12),
                children: sessionDates
                    .map((date) => SessionAttendanceCard(
                          sessionDate: date,
                          players: grouped[date]!,
                        ))
                    .toList(),
              );
            }

            if (state is AttendanceHistoryError) {
              return Center(
                child: Text("خطأ: ${state.message}"),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class SessionAttendanceCard extends StatefulWidget {
  final String sessionDate;
  final List<AttendanceHistoryModel> players;

  const SessionAttendanceCard({
    super.key,
    required this.sessionDate,
    required this.players,
  });

  @override
  State<SessionAttendanceCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionAttendanceCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          ListTile(
            title: Text(
              "الجلسة: ${widget.sessionDate}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Icon(isExpanded
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down),
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
          if (isExpanded)
            Column(
              children: widget.players.map((player) {
                return ListTile(
                  title: Text(player.playerName),
                  trailing: Text(
                    _statusText(player.status),
                    style: TextStyle(
                      color: _statusColor(player.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  String _statusText(String status) {
    switch (status) {
      case "present":
        return "حاضر";
      case "late":
        return "متأخر";
      case "absent":
        return "غائب";
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case "present":
        return Colors.green;
      case "late":
        return Colors.orange;
      case "absent":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
