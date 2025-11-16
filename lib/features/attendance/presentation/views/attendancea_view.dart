import 'package:blue_bird/features/attendance/data/models/attendance_model.dart';
import 'package:blue_bird/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:blue_bird/features/attendance/presentation/widgets/player_attendance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AttendanceScreen extends StatelessWidget {
  final Map<String, dynamic>? arguments;

  const AttendanceScreen({super.key, this.arguments});

  @override
  Widget build(BuildContext context) {
    final trainerId = arguments?['trainerId'];
    final teamId = arguments?['teamId'];
    final sessionId = arguments?['sessionId'];
    final List<Map<String, dynamic>>? players = arguments?['players']
        as List<Map<String, dynamic>>?; // Convert to List<Map<String, dynamic>>
    if (trainerId == null || teamId == null || sessionId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Attendance")),
        body: const Center(child: Text("Missing parameters")),
      );
    }

    return BlocProvider(
      create: (_) => GetIt.I<AttendanceCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تسجيل الحضور'),
          centerTitle: true,
        ),
        body: AttendanceViewBody(
          players: players ?? [],
          trainerId: trainerId,
          teamId: teamId,
          sessionId: sessionId,
        ),
      ),
    );
  }
}

class AttendanceViewBody extends StatefulWidget {
  final String trainerId;
  final String teamId;
  final String sessionId;
  final List<Map<String, dynamic>> players;
  const AttendanceViewBody({
    super.key,
    required this.trainerId,
    required this.teamId,
    required this.sessionId,
    required this.players,
  });

  @override
  State<AttendanceViewBody> createState() => _AttendanceViewBodyState();
}

class _AttendanceViewBodyState extends State<AttendanceViewBody> {
  /// Local temporary attendance storage (until backend fetch is ready)
  final Map<String, String> selectedStatus = {
    "1": "present",
    "2": "late",
  };

  List<Map<String, dynamic>> players = [];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AttendanceCubit>();

    return BlocConsumer<AttendanceCubit, AttendanceState>(
      listener: (context, state) {
        if (state is AttendanceSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم حفظ الحضور بنجاح!")),
          );
        } else if (state is AttendanceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  final id = player['id']!;

                  return PlayerAttendanceCard(
                    playerName: player['name']!,
                    jerseyNumber: player['number']!,
                    selectedStatus: selectedStatus[id]!,
                    onStatusChanged: (status) {
                      setState(() {
                        selectedStatus[id] = status;
                      });
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: state is AttendanceLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        final attendanceList = selectedStatus.entries.map(
                          (e) {
                            return AttendanceModel(
                              playerId: e.key,
                              status: e.value,
                              playerName: '',
                            );
                          },
                        ).toList();

                        cubit.markAttendance(
                          widget.trainerId,
                          widget.teamId,
                          widget.sessionId,
                          attendanceList,
                        );
                      },
                      child: const Text("حفظ الحضور"),
                    ),
            )
          ],
        );
      },
    );
  }
}
