import 'package:blue_bird/features/add_team/domain/entities/player_entity.dart';
import 'package:blue_bird/features/attendance/data/models/attendance_model.dart';
import 'package:blue_bird/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:blue_bird/features/attendance/presentation/widgets/player_attendance_card.dart';
import 'package:blue_bird/utils/assets_manager.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:blue_bird/utils/strings_manager.dart';
import 'package:blue_bird/utils/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';

class AttendanceScreen extends StatelessWidget {
  final Map<String, dynamic>? arguments;

  const AttendanceScreen({super.key, this.arguments});

  @override
  Widget build(BuildContext context) {
    final trainerId = arguments?['trainerId'];
    final teamId = arguments?['teamId'];
    final players = arguments?['players'] as List<PlayerEntity>?;

    if (trainerId == null || teamId == null || players == null) {
      return const Scaffold(
        body: Center(child: Text('Missing parameters')),
      );
    }

    return BlocProvider(
      create: (_) => GetIt.I<AttendanceCubit>()
        ..initAttendance(trainerId, teamId, players),
      child: AttendanceViewBody(
        trainerId: trainerId,
        teamId: teamId,
        players: players,
      ),
    );
  }
}

class AttendanceViewBody extends StatelessWidget {
  final String trainerId;
  final String teamId;
  final List<PlayerEntity> players;

  const AttendanceViewBody({
    super.key,
    required this.trainerId,
    required this.teamId,
    required this.players,
  });

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorManager.primary,
            ColorManager.lightPrimary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            StringsManager.attendance.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, color: Colors.white, size: 26),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            LottieAssets.loading,
            width: 180,
          ),
          Text(
            StringsManager.loading.tr(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AttendanceCubit>();

    return BlocConsumer<AttendanceCubit, AttendanceState>(
      listener: (context, state) {
        if (state is AttendanceSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(StringsManager.attendancesavedSuccessfully.tr()),
            ),
          );
        } else if (state is AttendanceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is AttendanceLoading) {
          return Scaffold(body: _buildLoading());
        }

        if (state is AttendanceAlreadyMarked) {
          return Scaffold(
            body: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          LottieAssets.done,
                          width: 180,
                        ),
                        const Text(
                          'Attendance already marked',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppPadding.p12,
                        horizontal: AppPadding.p16,
                      ),
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        final player = players[index];
                        final selectedStatus =
                            cubit.selectedStatuses[player.id] ?? '';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: PlayerAttendanceCard(
                            playerName: player.name,
                            jerseyNumber: player.jerseyNumber,
                            selectedStatus: selectedStatus,
                            onStatusChanged: (status) {
                              cubit.updateStatus(player.id, status);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppPadding.p16),
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [
                            ColorManager.primary,
                            ColorManager.lightPrimary,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: ColorManager.primary.withOpacity(0.4),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          final attendanceList = players.map((player) {
                            return AttendanceModel(
                              playerId: player.id,
                              playerName: player.name,
                              status:
                                  cubit.selectedStatuses[player.id] ?? 'غائب',
                            );
                          }).toList();

                          cubit.markAttendance(
                            trainerId,
                            teamId,
                            attendanceList,
                          );
                        },
                        child: Text(
                          StringsManager.saveAttendance.tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
