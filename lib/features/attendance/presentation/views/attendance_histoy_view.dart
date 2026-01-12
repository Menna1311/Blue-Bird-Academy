import 'package:blue_bird/core/di/di.dart';
import 'package:blue_bird/core/router/app_routes.dart';
import 'package:blue_bird/features/add_team/data/models/team_model.dart';
import 'package:blue_bird/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:blue_bird/utils/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceHistoryTeamsScreen extends StatelessWidget {
  const AttendanceHistoryTeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AttendanceCubit>()..getLoggedInUser(),
      child: const _AttendanceHistoryTeamsView(),
    );
  }
}

class _AttendanceHistoryTeamsView extends StatelessWidget {
  const _AttendanceHistoryTeamsView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AttendanceCubit, AttendanceState>(
      listener: (context, state) {
        if (state is AttendanceUserLoaded) {
          final user = (state).user;
          context.read<AttendanceCubit>().getTeams(user.id);
        }
      },
      builder: (context, state) {
        // Loading state
        if (state is AttendanceInitial || state is AttendanceUserLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: ColorManager.primary),
            ),
          );
        }

        // Error state
        if (state is AttendanceUserError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(StringsManager.somethingWentWrong.tr()),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<AttendanceCubit>().getLoggedInUser(),
                    child: Text(StringsManager.tryAgain.tr()),
                  ),
                ],
              ),
            ),
          );
        }

        // Teams loading state
        if (state is AttendanceTeamsLoading) {
          return Scaffold(
            body: Column(
              children: [
                _Header(),
                const Expanded(
                  child: Center(
                    child:
                        CircularProgressIndicator(color: ColorManager.primary),
                  ),
                ),
              ],
            ),
          );
        }

        // Teams loaded state
        if (state is AttendanceTeamsLoaded) {
          final teams = state.teams;
          final user = context.read<AttendanceCubit>().currentUser;

          if (teams.isEmpty) {
            return Scaffold(
              body: Column(
                children: [
                  _Header(),
                  Expanded(
                    child: Center(
                      child: Text(
                        StringsManager.noTeamsYet.tr(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Scaffold(
            body: Column(
              children: [
                _Header(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: teams.length,
                    itemBuilder: (_, i) {
                      final team = teams[i];
                      return _TeamCard(
                        team: team,
                        trainerId: user!.id,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }

        // Teams error state
        if (state is AttendanceTeamsError) {
          return Scaffold(
            body: Column(
              children: [
                _Header(),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            final user =
                                context.read<AttendanceCubit>().currentUser;
                            if (user != null) {
                              context.read<AttendanceCubit>().getTeams(user.id);
                            }
                          },
                          child: Text(StringsManager.tryAgain.tr()),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const Scaffold(
          body: Center(child: Text('Unexpected state')),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorManager.primary, ColorManager.lightPrimary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
            Expanded(
              child: Text(
                StringsManager.attendanceHistory.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
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
}

class _TeamCard extends StatelessWidget {
  final TeamModel team;
  final String trainerId;

  const _TeamCard({required this.team, required this.trainerId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.historyDetails,
          arguments: {
            'trainerId': trainerId,
            'teamId': team.id,
            'teamName': team.teamName,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorManager.primary.withOpacity(.95),
              ColorManager.primary.withOpacity(.8),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: ColorManager.primary.withOpacity(.35),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(team.teamName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(
                    "${team.teamAgeCategory} • ${team.players.length} players",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const Icon(Icons.sports_soccer, color: Colors.white54, size: 36),
          ],
        ),
      ),
    );
  }
}
