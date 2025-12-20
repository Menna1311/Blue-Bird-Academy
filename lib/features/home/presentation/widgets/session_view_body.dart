import 'package:blue_bird/core/di/di.dart';
import 'package:blue_bird/core/router/app_routes.dart';
import 'package:blue_bird/features/add_team/domain/entities/player_entity.dart';
import 'package:blue_bird/features/attendance/presentation/views/attendance_histoy_view.dart';
import 'package:blue_bird/features/home/presentation/widgets/session_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blue_bird/features/home/presentation/cubit/home_cubit.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:blue_bird/utils/strings_manager.dart';
import 'package:blue_bird/utils/values_manager.dart';

class SessionViewBody extends StatelessWidget {
  final String trainerId;
  final String teamId;
  final List<PlayerEntity> players;
  const SessionViewBody({
    super.key,
    required this.trainerId,
    required this.teamId,
    required this.players,
  });

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: const BoxDecoration(
        color: ColorManager.primary,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              StringsManager.sessions,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
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
    final cubit = getIt<HomeCubit>();
    // Pass both trainerId and teamId
    cubit.getSessions(trainerId, teamId);

    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: BlocBuilder<HomeCubit, HomeState>(
            bloc: cubit,
            builder: (context, state) {
              if (state is SessionLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SessionsLoaded) {
                final sessions = state.sessions;
                if (sessions.isEmpty) {
                  return Container(
                    color: Colors.grey.shade50,
                    child:
                        const Center(child: Text(StringsManager.noSessionsYet)),
                  );
                }

                return Container(
                  color: Colors.grey.shade50,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppPadding.p8),
                          itemCount: sessions.length,
                          itemBuilder: (context, index) {
                            final session = sessions[index];
                            final isUpcoming = session.status == 'upcoming';
                            final statusText =
                                isUpcoming ? 'Upcoming' : 'Completed';

                            return SessionCard(
                              dayName: session.day,
                              date: session.date,
                              time: session.time,
                              status: statusText,
                              isUpcoming: isUpcoming,
                              onPressed: () {
                                // Pass all three parameters: trainerId, teamId, sessionId
                                cubit.getSession(trainerId, teamId, session.id);
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.attendanceScreen,
                                  arguments: {
                                    'trainerId': trainerId,
                                    'teamId': teamId,
                                    'sessionId': session.id,
                                    'players': players,
                                  },
                                );
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
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AttendanceHistoryScreen(
                                    trainerId: trainerId,
                                    teamId: teamId,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primary,
                              padding: const EdgeInsets.symmetric(
                                  vertical: AppPadding.p14),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppSize.s12),
                              ),
                              elevation: AppSize.s2,
                              shadowColor:
                                  ColorManager.primary.withOpacity(0.3),
                            ),
                            child: const Text(
                              StringsManager.history,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: AppSize.s16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is SessionError) {
                return Container(
                  color: Colors.grey.shade50,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(StringsManager.errorLoadingSessions),
                        const SizedBox(height: AppSize.s16),
                        ElevatedButton(
                          onPressed: () {
                            cubit.getSessions(trainerId, teamId);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.primary,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppPadding.p12,
                              horizontal: AppPadding.p20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSize.s12),
                            ),
                          ),
                          child: const Text(
                            StringsManager.retry,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
