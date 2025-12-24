import 'package:blue_bird/features/add_team/domain/entities/player_entity.dart';
import 'package:blue_bird/features/attendance/data/models/attendance_model.dart';
import 'package:blue_bird/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:blue_bird/features/attendance/presentation/widgets/player_attendance_card.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:blue_bird/utils/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class AttendanceUiState extends ChangeNotifier {
  List<String?> selectedStatus;

  AttendanceUiState(int playerCount)
      : selectedStatus = List.generate(playerCount, (_) => null);

  void updateStatus(int index, String status) {
    selectedStatus[index] = status;
    notifyListeners();
  }
}

class AttendanceScreen extends StatelessWidget {
  final Map<String, dynamic>? arguments;

  const AttendanceScreen({super.key, this.arguments});

  @override
  Widget build(BuildContext context) {
    final trainerId = arguments?['trainerId'];
    final teamId = arguments?['teamId'];
    final sessionId = arguments?['sessionId'];
    final players = arguments?['players'] as List<PlayerEntity>?;

    if (trainerId == null ||
        teamId == null ||
        sessionId == null ||
        players == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Attendance")),
        body: const Center(child: Text("Missing parameters")),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AttendanceUiState(players.length),
        ),
        BlocProvider(
          create: (_) => GetIt.I<AttendanceCubit>(),
        ),
      ],
      child: Scaffold(
        body: AttendanceViewBody(
          trainerId: trainerId,
          teamId: teamId,
          sessionId: sessionId,
          players: players,
        ),
      ),
    );
  }
}

class AttendanceViewBody extends StatelessWidget {
  final String trainerId;
  final String teamId;
  final String sessionId;
  final List<PlayerEntity> players;

  const AttendanceViewBody({
    super.key,
    required this.trainerId,
    required this.teamId,
    required this.sessionId,
    required this.players,
  });

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: const BoxDecoration(
        color: ColorManager.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Attendance',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AttendanceCubit>();
    final uiState = context.watch<AttendanceUiState>();

    return BlocConsumer<AttendanceCubit, AttendanceState>(
      listener: (context, state) {
        if (state is AttendanceSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Attendance saved successfully!")),
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
            _buildHeader(context),
            Expanded(
              child: Container(
                color: Colors.grey.shade50,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppPadding.p8,
                        ),
                        itemCount: players.length,
                        itemBuilder: (context, index) {
                          final player = players[index];

                          return PlayerAttendanceCard(
                            playerName: player.name,
                            jerseyNumber: player.jerseyNumber,
                            selectedStatus: uiState.selectedStatus[index] ?? '',
                            onStatusChanged: (status) {
                              uiState.updateStatus(index, status);
                            },
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppPadding.p16,
                        horizontal: AppPadding.p16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: AppSize.s4,
                            offset: const Offset(0, -AppSize.s2),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: state is AttendanceLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () {
                                  final attendanceList =
                                      players.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final player = entry.value;
                                    return AttendanceModel(
                                      playerId: player.id,
                                      playerName: player.name,
                                      status: uiState.selectedStatus[index] ??
                                          'غائب',
                                    );
                                  }).toList();

                                  cubit.markAttendance(
                                    trainerId,
                                    teamId,
                                    sessionId,
                                    attendanceList,
                                  );
                                },
                                child: const Text("Save Attendance"),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
