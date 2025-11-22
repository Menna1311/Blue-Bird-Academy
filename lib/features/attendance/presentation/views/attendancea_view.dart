import 'package:blue_bird/features/add_team/domain/entities/player_entity.dart';
import 'package:blue_bird/features/attendance/data/models/attendance_model.dart';
import 'package:blue_bird/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:blue_bird/features/attendance/presentation/widgets/player_attendance_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  const AttendanceViewBody({
    super.key,
    required this.trainerId,
    required this.teamId,
    required this.sessionId,
  });

  @override
  State<AttendanceViewBody> createState() => _AttendanceViewBodyState();
}

class _AttendanceViewBodyState extends State<AttendanceViewBody> {
  final Map<String, String> selectedStatus = {}; // playerId -> status
  late List<PlayerEntity> players = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  /// 🔹 Load players from Firestore session
  Future<void> _loadPlayers() async {
    final sessionDoc = await FirebaseFirestore.instance
        .collection('trainers')
        .doc(widget.trainerId)
        .collection('teams')
        .doc(widget.teamId)
        .collection('sessions')
        .doc(widget.sessionId)
        .get();

    final playersData = sessionDoc['players'] as List<dynamic>? ?? [];

    setState(() {
      players = playersData.map((p) {
        // initialize default attendance as "present"
        selectedStatus[p['id']] = 'present';
        return PlayerEntity(
          id: p['id'],
          name: p['name'],
          jerseyNumber: p['jerseyNumber'],
        );
      }).toList();
      isLoading = false;
    });
  }

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
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  final id = player.id;

                  return PlayerAttendanceCard(
                    playerName: player.name,
                    jerseyNumber: player.jerseyNumber,
                    selectedStatus: selectedStatus[id] ?? 'present',
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
                        final attendanceList = players.map((player) {
                          return AttendanceModel(
                            playerId: player.id,
                            playerName: player.name,
                            status: selectedStatus[player.id] ?? 'present',
                          );
                        }).toList();

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
